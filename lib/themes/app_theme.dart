import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'colors.dart';
part 'text_styles.dart';
part 'font_sizes.dart';

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: colors.transparent,
      dividerColor: colors.grayD4,
      scaffoldBackgroundColor: colors.transparent,
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colors.transparent,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.black.withOpacity(0.6),
        selectionHandleColor: colors.transparent,
      ),
      brightness: Brightness.light,
      fontFamily: "Inter",
    );
  }

  static ColorsInterface get colors => _DefaultColors();
  static TextStylesInterface get textStyles => _DefaultTextStyles();
  static FontSizesInterface get fontSizes => _DefaultFontSizes();
}
