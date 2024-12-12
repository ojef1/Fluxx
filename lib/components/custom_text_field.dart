import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  const CustomTextField(
      {super.key,
      required this.icon,
      required this.controller,
      this.inputFormatters,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: mediaQuery.width * .85,
      height: mediaQuery.height * .07,
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
      decoration: BoxDecoration(
        gradient: AppTheme.colors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            inputFormatters: inputFormatters,
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            
            style: AppTheme.textStyles.bodyTextStyle,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
            width: 1,
            color: Colors.white,
          ),
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          )
        ],
      ),
    );
  }
}
