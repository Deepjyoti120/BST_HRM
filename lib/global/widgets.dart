import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showMessage(message, isFailed, BuildContext context) {
  final snackBar = SnackBar(
      elevation: 5,
      backgroundColor: isFailed ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
