part of 'app_theme.dart';

abstract class TextStylesInterface {
  TextStyle get defaultTextStyle;
  TextStyle get titleTextStyle;
  TextStyle get itemTitleTextStyle;
  TextStyle get bodyTextStyle;
  TextStyle get tileTextStyle;
  TextStyle get subTileTextStyle;
  TextStyle get itemTextStyle;
  TextStyle get secondaryTextStyle;
  TextStyle get descTextStyle;
}

class _DefaultTextStyles implements TextStylesInterface {
  _DefaultTextStyles._internal();

  static final _DefaultTextStyles _singleton = _DefaultTextStyles._internal();

  factory _DefaultTextStyles() {
    return _singleton;
  }

  @override
  TextStyle get defaultTextStyle =>
      TextStyle(fontSize: AppTheme.fontSizes.medium, fontFamily: 'Mulish');

  @override
  TextStyle get titleTextStyle => TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: AppTheme.fontSizes.xlarge,
      color: AppTheme.colors.primaryTextColor,
      overflow: TextOverflow.ellipsis,
      fontFamily: 'Mulish');

  @override
  TextStyle get itemTitleTextStyle => TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: AppTheme.fontSizes.xlarge,
      color: AppTheme.colors.black,
      overflow: TextOverflow.ellipsis,
      fontFamily: 'Mulish');

  @override
  TextStyle get bodyTextStyle => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: AppTheme.fontSizes.medium,
        color: AppTheme.colors.primaryTextColor,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Mulish',
      );
  @override
  TextStyle get tileTextStyle => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: AppTheme.fontSizes.large,
        color:  AppTheme.colors.hintTextColor,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Mulish',
      );
  @override
  TextStyle get subTileTextStyle => TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: AppTheme.fontSizes.medium,
        color:  AppTheme.colors.hintTextColor,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Mulish',
      );
  @override
  TextStyle get itemTextStyle => TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: AppTheme.fontSizes.medium,
        color:  Colors.black,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Mulish',
      );
  @override
  TextStyle get secondaryTextStyle => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: AppTheme.fontSizes.small,
        color: AppTheme.colors.hintTextColor,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Mulish',
      );
  @override
  TextStyle get descTextStyle => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: AppTheme.fontSizes.small,
        color: AppTheme.colors.black,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Mulish',
      );
}
