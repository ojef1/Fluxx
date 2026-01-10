import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoading extends StatelessWidget {
  final EdgeInsets? padding;
  const CustomLoading({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 150),
      child: Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: AppTheme.colors.hintColor,
          size: 30,
        ),
      ),
    );
  }
}
