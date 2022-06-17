import 'dart:async';
import 'dart:io';

import 'package:fapp_shell/webview.dart';
import 'package:fapp_shell/webview_stack.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:fapp_shell/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fapp_shell/firebase_messaging.dart';
import 'package:fapp_shell/sendNotificationView.dart';
import 'package:fapp_shell/model/message.dart';

import 'package:webview_flutter/webview_flutter.dart';

// Initialize Firebase
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// Global Key for the state of the pages within bar navigation
GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

// Webview Url
var url = 'https://www.theguardian.com/world/ukraine';

final List<NotificationMessage> messages = [];

// Is user currently a sender?
bool isSender = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //runApp(const MyApp());
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final navKey = GlobalKey<NavigatorState>();

  const MyApp({required this.webViewController, Key? key}) : super(key: key);

  // Webview
  final Completer<WebViewController> webViewController;

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<MyApp> {
  /// This initializes the main app. In here we define what happens when a notification
  /// is received in the different states: onLaunch, onResume, onMessage.
  @override
  Future<void> initState() async {
    super.initState();

    // Handling of messages/notifications
    var authStatus = requestPermissionMessaging();
    await authStatus;
    if (authStatus == AuthorizationStatus.authorized) {
      await initMessageHandling();
    }
  }

  /// Request the permission for notifications for iOS, macOS -> only needed for iOS.
  ///
  /// Return the `authorizationStatus` property:
  /// * `authorized`: The user granted permission.
  /// * `denied`: The user denied permission.
  /// * `notDetermined`: The user has not yet chosen whether to grant permission.
  /// * `provisional`: The user granted provisional permission
  ///
  /// On Android authorizationStatus will return `authorized` if the user has not disabled notifications for the app via the operating systems settings.
  ///
  requestPermissionMessaging() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
    return settings.authorizationStatus;
  }

  initMessageHandling() async {
    // Subscribe to the topic "all".
    // Needed when we send a notification.
    // Notifications is sent to all the devices subscribed to "all"
    await _firebaseMessaging.subscribeToTopic("all");

    // Handling of messages/notifications while the app is in
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("foreground onMessage: $message");
        print('Message data: ${message.data}');
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }

      setState(() {
        url = extractURL(message.data);
        //if it is the sender no alert needs to pop up
        if (isSender != true) {
          showMyDialog();
        } else {
          isSender = false;
        }
      });
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // Handling of messages/notifications while the app is in
    // Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to Open from
    // a Terminated state.
    // onLaunch
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      if (kDebugMode) {
        print("Launching on notif msg");
      }
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // onResume
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (kDebugMode) {
      print("Handle message: $message");
    }
    if (message.data['type'] == 'test') {
      // Navigator.pushNamed(context, '/chat',
      //   arguments: ChatArguments(message),
      // );

      // messages.add(NotificationMessage(
      //     title: message.data['title'],
      //     body: message.data['body'],
      //     type: message.data['type'])
      // );

      setState(() {
        url = extractURL(message.data);
        showMyDialog();
      });
    }
  }

  //Extract URL from received payload. Different depending if iOS or Android.
  String extractURL(Map<String, dynamic> message) {
    if (Platform.isIOS) {
      url = message['url'];
    } else if (Platform.isAndroid) {
      var notification = message['data'];
      url = notification['url'];
    }
    if (kDebugMode) {
      print('LOG: Received URL is: $url');
    }
    return url;
  }

  // ===============================================================

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navKey,
      title: 'fApp.Shell',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('fApp.Shell'),
        ),
        body: Column(
          children: [
            //Add children widget if needed
            Expanded(
              child: FirebaseMessagingWidget(messages),
            ),
            Expanded(
              flex: 10,
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (wvController) {
                      widget.webViewController.complete(wvController);
                    },
                  ),
                  SendNotificationView(_firebaseMessaging),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            key: navBarGlobalKey,
            backgroundColor: Colors.grey[200],
            currentIndex: _currentIndex,
            items: const [
              //Add items if needed
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'WebView'),
              BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send URL')
            ],
            onTap: (int index) async {
              setState(() {
                _currentIndex = index;
                widget.webViewController.loadUrl(url);
              });
            },
          ),
      ),
    );
  }

  // BottomNavigationBar ====

  // current index 0 is the 1 page of the bottomNavigation bar. and so on.
  int _currentIndex = 0;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

Future<void> showMyDialog() async {
  return showDialog<void>(
    context: MyApp.navKey.currentState!.overlay!.context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('You received a new URL :)'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Your peer wants to open: $url'),
              const Text('Would you like to open it in the WebView?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Allow'),
            onPressed: () {
              final BottomNavigationBar navigationBar =
                  navBarGlobalKey.currentWidget as BottomNavigationBar;
              navigationBar.onTap!(0);
              widget.webViewController.loadUrl(url);
              //this makes the aler go away
              Navigator.of(context).pop();
              //onTabTapped(Icons.home);
            },
          ),
          TextButton(
            child: const Text('Deny'),
            onPressed: () {
              //this makes the aler go away
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
