import 'package:flutter/material.dart';

class Utilities{
  static void showSnackBar(msg,context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 3.0,
        backgroundColor: Colors.green,
      ),
    );
  }
}