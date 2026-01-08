import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Function()? backButton;
  const CustomAppBar({super.key, required this.title, this.actions, this.backButton});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors.appBackgroundColor,
      title: Text(
        title,
        style: AppTheme.textStyles.titleTextStyle,
        softWrap: true,
        maxLines: 2,
      ),
      leading: IconButton(
        onPressed: backButton ?? ()=> Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: AppTheme.colors.hintColor,
      ),
      actions: actions,
      actionsPadding: const EdgeInsets.only(right: 20),
      centerTitle: true,
    );
  }
}
