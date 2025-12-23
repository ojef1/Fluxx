import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBigTextField extends StatelessWidget {
  final double? height;
  final String hint;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int maxLines;
  const CustomBigTextField(
      {super.key,
      required this.controller,
      this.inputFormatters,
      this.keyboardType,
      required this.hint,
      this.height, required this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: mediaQuery.width * .85,
      height: height ?? mediaQuery.height * .07,
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .05),
      decoration: BoxDecoration(
        color: AppTheme.colors.itemBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        maxLines: maxLines,
        textAlignVertical: TextAlignVertical.top,
        
        cursorColor: Colors.white,
        inputFormatters: inputFormatters,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        style: AppTheme.textStyles.bodyTextStyle,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          
          hintStyle: AppTheme.textStyles.bodyTextStyle,
        ),
      ),
    );
  }
}
