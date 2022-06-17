import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fapp_shell/main.dart';

//This is the server token taken from the firebase project.
final String serverToken =
    'AAAAEike9qQ:APA91bG9AvlSWWaMIZy-jybRs--uMgc7Ybjz7_wavGloY3ArfrZ1eDMcj-FDt2hRUrInmIo4_872rqjHouOi7vr-IgYSqxqZH04uXJqdWJBehY_O_SwKBUiI078xkYFN2aFraaYEu3o4';

class SendNotificationView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final FirebaseMessaging _firebaseMessaging;

  SendNotificationView(this._firebaseMessaging);

  TextEditingController _teController = new TextEditingController();
  String finalUrl = '';

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    //change isSender to true
    isSender = true;
    print('LOG: You are about to send a message');
    // await _firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //       sound: true, badge: true, alert: true, provisional: false),
    // );
    await _firebaseMessaging.requestPermission();

    //Make API call
    await http.post(
        Uri(scheme: 'https', host: 'fcm.googleapis.com', path: 'fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': finalUrl,
              'title': finalUrl,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              // This is important for Android, it shows what needs to be done when the push notification is clicked.
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'url': finalUrl
            },
            // This is important because all the devices are subscribed to this subject.
            "to": "/topics/all",
          },
        ));

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _teController,
              decoration: const InputDecoration(
                hintText: 'Enter your URL',
              ),
              validator: (value) {
                print('LOG: Validator value = $value');
                if (value!.isEmpty) {
                  return 'Please enter your text';
                } else if (!value.startsWith("https://")) {
                  return 'Please start with https://';
                }
                finalUrl = value;
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  finalUrl = _teController.text;
                  print('LOG Finalurl $finalUrl');
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Sending URL to other devices')));
                    sendAndRetrieveMessage();
                  }
                  _teController.clear();
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                },
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
