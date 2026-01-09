import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Function() onPressed;
  const SecondaryButton(
      {super.key, required this.onPressed, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return ListTile(
      titleTextStyle: AppTheme.textStyles.bodyTextStyle,
      titleAlignment: ListTileTitleAlignment.center,
      tileColor: AppTheme.colors.itemBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minTileHeight: mediaQuery.height * .055,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      splashColor: AppTheme.colors.hintColor,
      title: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.textStyles.bodyTextStyle.copyWith(
                  color: AppTheme.colors.primaryTextColor,
                ),
              ),
            ],
          ),
          if (icon != null)
            Icon(
              icon,
              size: 22,
              color: AppTheme.colors.hintColor,
            ),
        ],
      ),
      onTap: onPressed,
    );
  }
}
