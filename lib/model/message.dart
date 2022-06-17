import 'package:flutter/material.dart';

@immutable
class NotificationMessage {
  final String title;
  final String body;
  final String type;

  const NotificationMessage({
    required this.title,
    required this.body,
    required this.type,
  });
}