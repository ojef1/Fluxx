import 'package:flutter/material.dart';

class Constants {
  static const List<String> categories = [
    'Casa',
    'Transporte',
    'Saúde',
    'Lazer',
    'Alimentação',
  ];
  static final Map<String, IconData> categoriesIcons = {
    'Casa': Icons.home_rounded,
    'Transporte': Icons.directions_car_filled_rounded,
    'Saúde': Icons.vaccines_rounded,
    'Lazer': Icons.beach_access_rounded,
    'Alimentação': Icons.local_dining_rounded,
  };

  static const defaultPicture = 'assets/images/default_user.jpeg';

  static const topMargin = 30.0;
}
