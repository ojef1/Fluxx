import 'package:Fluxx/themes/app_theme.dart';
import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';

abstract class CustomFlushbar {
  static Future<dynamic> show({
    required BuildContext context,
    required String message,
    required bool isError,
  }) async {
    // Calcular duração: 2 segundos + 0.05 seg por caractere, mínimo 2s, máximo 5s
    final durationSeconds = (2 + message.length * 0.05).clamp(2, 5);
    return FlashyFlushbar(
      leadingWidget: Icon(
        isError ? Icons.warning_rounded : Icons.check_rounded,
        color: isError ? AppTheme.colors.white : AppTheme.colors.hintColor,
        size: 24,
      ),
      message: message,
      messageStyle: AppTheme.textStyles.bodyTextStyle.copyWith(
        color: isError ? AppTheme.colors.white : AppTheme.colors.hintColor,
        overflow: TextOverflow.visible,
      ),
      comingFromTop: true,
      margin: const EdgeInsets.all(24),
      duration: Duration(seconds: durationSeconds.toInt()),
      backgroundColor: isError ? Colors.red : AppTheme.colors.white,
      messageHorizontalSpacing: 20,
      trailingWidget: IconButton(
        icon: Icon(
          Icons.close,
          color: isError ? AppTheme.colors.white : AppTheme.colors.hintColor,
          size: 24,
        ),
        onPressed: () {
          FlashyFlushbar.cancelAll();
        },
      ),
      isDismissible: true,
      dismissDirection: DismissDirection.vertical,
    ).show();
  }
}
