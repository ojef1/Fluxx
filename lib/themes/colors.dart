part of 'app_theme.dart';

abstract class ColorsInterface {
  Color get appBackgroundColor;
  Color get itemBackgroundColor;
  Color get hintColor;
  Color get lightHintColor;
  Color get transparent;
  Color get primaryTextColor;
  Color get hintTextColor;
  Color get grayD4;
  Color get white;
  Color get black;
  Color get red;
}

class _DefaultColors implements ColorsInterface {
  _DefaultColors._internal();

  static final _DefaultColors _singleton = _DefaultColors._internal();

  factory _DefaultColors() {
    return _singleton;
  }

  @override
  Color get appBackgroundColor => const Color(0xFF121212);
  @override
  Color get itemBackgroundColor => const Color(0xFF1E1E1E);
  @override
  Color get hintColor => const Color(0xFF0077FF);
  @override
  Color get lightHintColor => const Color(0xFF5BA7FF);
  @override
  Color get transparent => Colors.transparent;
  @override
  Color get primaryTextColor => const Color(0xffD9D9D9);
  @override
  Color get hintTextColor => const Color(0xffbabcbd);
  @override
  Color get grayD4 => const Color(0xffd4d4d4);
  @override
  Color get white => const Color(0xffffffff);
  @override
  Color get black => const Color(0xff000000);
  @override
  Color get red => const Color(0xffff4242);
}
