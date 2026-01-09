import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class RevenueListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Function() onPressed;
  const RevenueListTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onPressed,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        splashColor: AppTheme.colors.hintColor,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        tileColor: isSelected
            ? AppTheme.colors.hintColor
            : AppTheme.colors.itemBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          title,
          style: AppTheme.textStyles.bodyTextStyle,
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.textStyles.secondaryTextStyle.copyWith(
            color: isSelected
                ? AppTheme.colors.white
                : AppTheme.colors.hintTextColor,
          ),
          textAlign: TextAlign.center,
        ),
        onTap: onPressed,
      ),
    );
  }
}
