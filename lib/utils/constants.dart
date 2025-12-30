import 'package:Fluxx/models/month_model.dart';

class Constants {
  static const defaultPicture = 'assets/images/default_user.jpeg';
  static const topMargin = 20.0;
}

class AppMonths {
  static List<MonthModel> all = [
    MonthModel(monthNumber: 1, name: 'Janeiro'),
    MonthModel(monthNumber: 2, name: 'Fevereiro'),
    MonthModel(monthNumber: 3, name: 'Março'),
    MonthModel(monthNumber: 4, name: 'Abril'),
    MonthModel(monthNumber: 5, name: 'Maio'),
    MonthModel(monthNumber: 6, name: 'Junho'),
    MonthModel(monthNumber: 7, name: 'Julho'),
    MonthModel(monthNumber: 8, name: 'Agosto'),
    MonthModel(monthNumber: 9, name: 'Setembro'),
    MonthModel(monthNumber: 10, name: 'Outubro'),
    MonthModel(monthNumber: 11, name: 'Novembro'),
    MonthModel(monthNumber: 12, name: 'Dezembro'),
  ];
}
