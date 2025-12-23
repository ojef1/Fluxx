
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final double width;
  final String text;
  final Function() onPressed;
  final Color color;
  final TextStyle textStyle;
  final bool isLoading;
  const PrimaryButton({super.key, required this.text, required this.onPressed, required this.width, required this.color, required this.textStyle, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        height: 60,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(3),
        width: width,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                text,
                style: textStyle,
              ),
      ),
    );
  }
}
