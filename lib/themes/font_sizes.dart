part of 'app_theme.dart';

abstract class FontSizesInterface {
  double get xsmall;
  double get small;
  double get medium;
  double get large;
  double get xlarge;
}

class _DefaultFontSizes implements FontSizesInterface {
  _DefaultFontSizes._internal();

  static final _DefaultFontSizes _singleton = _DefaultFontSizes._internal();

  factory _DefaultFontSizes() {
    return _singleton;
  }

  @override
  double get large => 21;

  @override
  double get medium => 16;

  @override
  double get small => 13;

  @override
  double get xlarge => 23;

  @override
  double get xsmall => 10;
}
