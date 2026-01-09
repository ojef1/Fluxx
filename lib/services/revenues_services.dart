import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/revenue_model.dart';

Future<List<RevenueModel>> getRevenues(int monthId) async {
  try {
    final results = await Future.wait([
      _getMonthlyRevenue(monthId),
      _getSingleRevenue(monthId),
    ]);

    final combinedRevenuesList = [
      ...results[0],
      ...results[1],
    ];
    return combinedRevenuesList;
  } catch (error) {
    rethrow;
  }
}

Future<List<RevenueModel>> _getMonthlyRevenue(int monthId) async {
  try {
    final revenue = await Db.getMonthlyRevenues(monthId);

    final monthlyRevenuesList =
        revenue.map((item) => RevenueModel.fromJson(item)).toList();
    return monthlyRevenuesList;
  } catch (error) {
    log('$error', name: '_getMonthlyRevenue');

    return [];
  }
}

Future<List<RevenueModel>> _getSingleRevenue(int monthId) async {
  try {
    final revenue = await Db.getSingleRevenues(monthId);

    final singleRevenuesList =
        revenue.map((item) => RevenueModel.fromJson(item)).toList();
    return singleRevenuesList;
  } catch (error) {
    log('$error', name: '_getSingleRevenue');
    return [];
  }
}

Future<List<RevenueModel>> calcAvailableValue(int monthId, List<RevenueModel> revenues) async {
  try {
    final usedMap = await Db.getTotalUsedByPaymentId(monthId);

    return revenues.map((revenue) {
      final used = usedMap[revenue.id] ?? 0.0;

      return revenue.copyWith(
        value: (revenue.value ?? 0) - used,
      );
    }).toList();
  } catch (error) {
    log('$error', name: 'calcAvailableValue');
    return [];
  }
}
