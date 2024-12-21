import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class AnimatedCheckButton extends StatefulWidget {
  final String text;

  const AnimatedCheckButton({Key? key, required this.text}) : super(key: key);

  @override
  _AnimatedCheckButtonState createState() => _AnimatedCheckButtonState();
}

class _AnimatedCheckButtonState extends State<AnimatedCheckButton> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.colors.accentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            width: isChecked ? mediaQuery.width * .75 : mediaQuery.width * .85,
            child: Center(
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isChecked ? 24 : 0,
            child: isChecked
                ? const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 24,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
