import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/month_model.dart';

class AppPeriodService {
  static final AppPeriodService _instance = AppPeriodService._internal();

  factory AppPeriodService() => _instance;

  AppPeriodService._internal();

  late MonthModel _currentMonth;
  late MonthModel _monthInFocus;

  MonthModel get currentMonth => _currentMonth;
  MonthModel get monthInFocus => _monthInFocus;

  Future<void> init(int year) async {
    try {
      final result = await Db.getMonths(year);

      _currentMonth = result.firstWhere(
        (m) => m.monthNumber == DateTime.now().month,
      );

      _monthInFocus = _currentMonth;
    } catch (e, s) {
      log('Error initializing AppPeriodService', error: e, stackTrace: s);
      rethrow;
    }
  }

  void updateMonthInFocus(MonthModel month) {
    _monthInFocus = month;
  }
}
