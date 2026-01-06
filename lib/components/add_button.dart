import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final Function() onPressed;
  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleTextStyle: AppTheme.textStyles.bodyTextStyle,
      titleAlignment: ListTileTitleAlignment.center,
      tileColor: AppTheme.colors.itemBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Adicionar',
                textAlign: TextAlign.center,
                style: AppTheme.textStyles.tileTextStyle.copyWith(
                  color: AppTheme.colors.primaryTextColor,
                ),
              ),
            ],
          ),
          Icon(
            Icons.add,
            size: 22,
            color: AppTheme.colors.hintColor,
          ),
        ],
      ),
      onTap: onPressed,
    );
  }
}
