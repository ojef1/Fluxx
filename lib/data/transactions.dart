part of 'database.dart';

Future<int> _getMonthIdTx({
  required sql.Transaction txn,
  required int yearId,
  required int month,
}) async {
  final result = await txn.query(
    Tables.months,
    where: 'year_id = ? AND month_number = ?',
    whereArgs: [yearId, month],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['id'] as int;
  }

  return await _insertMonthTx(
    txn: txn,
    monthNumber: month,
    yearId: yearId,
  );
}

Future<int> _insertMonthTx({
  required sql.Transaction txn,
  required int monthNumber,
  required int yearId,
}) async {
  final monthName = AppMonths.all
      .firstWhere((month) => month.monthNumber == monthNumber)
      .name;
  int result = await txn.insert(
    Tables.months,
    {
      'name': monthName,
      'month_number': monthNumber,
      'year_id': yearId,
    },
    conflictAlgorithm: sql.ConflictAlgorithm.ignore,
  );
  return result;
}

Future<int> _getYearIdTx({
  required sql.Transaction txn,
  required int year,
}) async {
  final result = await txn.query(
    Tables.years,
    where: 'value = ?',
    whereArgs: [year],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['id'] as int;
  }

  return await _insertYearTx(txn: txn, yearValue: year);
}

Future<int> _insertYearTx({
  required sql.Transaction txn,
  required int yearValue,
}) async {
  try {
    int result = await txn.insert(
      Tables.years,
      {'value': yearValue},
      conflictAlgorithm: sql.ConflictAlgorithm.ignore,
    );

    for (final month in AppMonths.all) {
      await _insertMonthTx(
          txn: txn, monthNumber: month.monthNumber!, yearId: result);
    }

    return result;
  } catch (e) {
    throw Exception('Erro ao inserir ano: $e');
  }
}
