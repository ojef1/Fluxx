import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final double width;
  final String text;
  final Function() onPressed;
  const PrimaryButton({super.key, required this.text, required this.onPressed, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: AppTheme.colors.accentColor,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(3),
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.colors.accentColor,
          minimumSize: const Size(50, 50),
        ),
        child: Text(text, style: AppTheme.textStyles.bodyTextStyle),
      ),
    );
  }
}
