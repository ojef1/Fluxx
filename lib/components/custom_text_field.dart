import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final IconData? icon;
  final bool showIcon;
  final double? height;
  final String hint;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  const CustomTextField(
      {super.key,
      this.icon,
      required this.controller,
      this.inputFormatters,
      this.keyboardType,
      required this.hint,
      this.height,
      this.showIcon = true});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: mediaQuery.width * .85,
      height: height ?? mediaQuery.height * .07,
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
      decoration: BoxDecoration(
        color: AppTheme.colors.itemBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              maxLines: icon != null
                  ? 1
                  : 6, // se não tiver icone significa que é uma caixa grande (ex.descrição)
              textAlignVertical: TextAlignVertical.top,
              cursorColor: Colors.white,
              inputFormatters: inputFormatters,
              controller: controller,
              keyboardType: keyboardType ?? TextInputType.text,
              style: AppTheme.textStyles.bodyTextStyle,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ),
          if (showIcon)
            Container(
              margin: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
              width: 1,
              color: AppTheme.colors.hintColor,
            ),
          if (showIcon)
            Icon(
              icon,
              color: AppTheme.colors.hintColor,
              size: 30,
            )
        ],
      ),
    );
  }
}
