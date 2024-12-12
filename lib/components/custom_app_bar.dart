import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Function()? firstFunction;
  final Function() secondFunction;
  final String title;
  final IconData firstIcon;
  final double? firstIconSize;
  final IconData functionIcon;
  const CustomAppBar(
      {super.key,
      this.firstFunction,
      required this.secondFunction,
      required this.title,
      required this.firstIcon,
      required this.functionIcon,
      this.firstIconSize});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(
            right: mediaQuery.height * .02,
          ),
          width: mediaQuery.width * .7,
          height: mediaQuery.height * .06,
          decoration: BoxDecoration(
            gradient: AppTheme.colors.primaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: GestureDetector(
            onTap: firstFunction,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    firstIcon,
                    color: Colors.white,
                    size: firstIconSize ?? 32,
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTheme.textStyles.titleTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: secondFunction,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.colors.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircleAvatar(
              radius: mediaQuery.width * .06,
              backgroundColor: Colors.transparent,
              child: Icon(
                functionIcon,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
