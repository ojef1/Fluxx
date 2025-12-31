import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AutoMarqueeText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double height;

  const AutoMarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return SizedBox(
          height: height,
          child: isOverflowing
              ? Marquee(
                  text: text,
                  style: style,
                  scrollAxis: Axis.horizontal,
                  velocity: 60,
                  blankSpace: 80,
                  startPadding: 10,
                )
              : Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style,
                ),
        );
      },
    );
  }
}
