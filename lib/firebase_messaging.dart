import 'package:flutter/material.dart';

import 'main.dart';
import 'model/message.dart';

class FirebaseMessagingWidget extends StatefulWidget {
  final List<NotificationMessage> messages;

  FirebaseMessagingWidget(this.messages);

  @override
  FirebaseMessagingWidgetState createState() =>
      FirebaseMessagingWidgetState(messages);
}

// This just shows the current url
class FirebaseMessagingWidgetState extends State<FirebaseMessagingWidget> {
  final List<NotificationMessage> messages;

  FirebaseMessagingWidgetState(this.messages);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: new EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Text('Current URL: $url',
            style: TextStyle(fontSize: 16,),
            textAlign: TextAlign.center
        ),
    );

  }
}
