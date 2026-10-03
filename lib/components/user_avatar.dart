import 'dart:io';

import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? picture;
  final String? name;
  final double size;

  const UserAvatar({
    super.key,
    required this.picture,
    required this.name,
    required this.size,
  });

  bool get _hasPicture =>
      picture != null &&
      picture!.isNotEmpty &&
      picture != Constants.defaultPicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.colors.itemBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: _hasPicture
            ? Image.file(
                File(picture!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _initials(),
              )
            : _initials(),
      ),
    );
  }

  Widget _initials() {
    return Center(
      child: Text(
        getInitials(name),
        style: AppTheme.textStyles.titleTextStyle.copyWith(
          fontSize: size * .38,
          color: AppTheme.colors.hintColor,
        ),
      ),
    );
  }
}
