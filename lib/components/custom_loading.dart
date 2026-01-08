import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final EdgeInsets? padding;
  const CustomLoading({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 150),
      child: Center(
        child: CircularProgressIndicator(
          constraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 30,
          ),
          backgroundColor: AppTheme.colors.hintColor,
          valueColor:
              AlwaysStoppedAnimation<Color>(AppTheme.colors.lightHintColor),
        ),
      ),
    );
  }
}
