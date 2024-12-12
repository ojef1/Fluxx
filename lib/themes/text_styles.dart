part of 'app_theme.dart';

abstract class TextStylesInterface {
  TextStyle get defaultTextStyle;
  TextStyle get titleTextStyle;
  TextStyle get bodyTextStyle;
  TextStyle get tileTextStyle;
  TextStyle get subTileTextStyle;
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
      TextStyle(fontSize: AppTheme.fontSizes.medium, fontFamily: 'Inter');

  @override
  TextStyle get titleTextStyle => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: AppTheme.fontSizes.large,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
      fontFamily: 'Inter');

  @override
  TextStyle get bodyTextStyle => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: AppTheme.fontSizes.medium,
        color: Colors.white,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Inter',
      );
  @override
  TextStyle get tileTextStyle => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: AppTheme.fontSizes.large,
        color: Colors.black,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Inter',
      );
  @override
  TextStyle get subTileTextStyle => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: AppTheme.fontSizes.medium,
        color: Colors.black,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Inter',
      );
  @override
  TextStyle get descTextStyle => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: AppTheme.fontSizes.medium,
        color: Colors.grey,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Inter',
      );
}
