

import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/month_model.dart';

Future<MonthModel?> getMonthIdFromDate(DateTime date) async {
    final yearId = await Db.getYearId(date.year);

    final monthId = await Db.getMonthId(
      yearId: yearId,
      month: date.month,
    );

    final getMonth = await Db.getMonthById(monthId);
    MonthModel? month = getMonth != null ? MonthModel.fromJson(getMonth) : null;
    log('monthId: $monthId, e YearId : $yearId',
        name: 'resolveMonthIdFromDate');
    return month;
  }