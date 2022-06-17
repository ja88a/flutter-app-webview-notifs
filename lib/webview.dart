import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {

  // // Hybrid Composition mode for Android devices
  // import 'dart:io';
  // @override
  // void initState() {
  //   if (Platform.isAndroid) {
  //     WebView.platform = SurfaceAndroidWebView(); 
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Ukraine'),
      ),
      body: const WebView(
        initialUrl: 'https://www.theguardian.com/world/ukraine',
      ),
    );
  }
}
