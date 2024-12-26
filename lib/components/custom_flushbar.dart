import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

abstract class CustomSnackBar {
  static Future<dynamic> show({
    required BuildContext context,
    required String message,
    required IconData? icon,
    required Color color,
  }) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          icon != null
              ? Icon(
                  icon,
                  color: Colors.white,
                )
              : const SizedBox(),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 40),
      backgroundColor: color,
      duration: const Duration(seconds: 4),
      flushbarStyle: FlushbarStyle.GROUNDED,
      maxWidth: double.infinity,
    ).show(context);
  }
}
