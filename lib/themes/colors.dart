part of 'app_theme.dart';

abstract class ColorsInterface {
  Gradient get backgroundColor;
  Gradient get primaryColor;
  Color get darkPurple;
  Color get transparent;
  Color get grayD4;
  Color get hintTextsColor;
}

class _DefaultColors implements ColorsInterface {
  _DefaultColors._internal();

  static final _DefaultColors _singleton = _DefaultColors._internal();

  factory _DefaultColors() {
    return _singleton;
  }

  @override
  Gradient get backgroundColor => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFF865BC4),
        ],
      );
  @override
  Gradient get primaryColor => const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topCenter,
        colors: [
          Color(0xFF844FCF),
          Color(0xFF4B1E8A),
        ],
      );

  @override
  Color get darkPurple => const Color(0xFF4B1E8A);
  @override
  Color get transparent => Colors.transparent;
  @override
  Color get grayD4 => const Color(0xffd4d4d4);
  @override
  Color get hintTextsColor => const Color(0xffbabcbd);
}
