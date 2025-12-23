
import 'package:Fluxx/components/custom_flushbar.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';

String formatPrice(double price) {
  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');
  return currencyFormatter.format(price);
}

//qualquer número diferente de zero será interpretado como true
bool intToBool(int value) {
  return value != 0;
}

Future<void> showFlushbar(
    BuildContext context, String message, bool isError) async {
  await CustomFlushbar.show(
    context: context,
    message: message,
    isError: isError,
  );
}

List<DateTime> getNextMonthsUntilDecember(MonthModel focusedMonth) {
  final List<DateTime> months = [];

  final startMonth = focusedMonth.id! + 1;
  final year = DateTime.now().year;

  if (startMonth > 12) return months;

  for (int m = startMonth; m <= 12; m++) {
    months.add(DateTime(year, m));
  }

  return months;
}

String? formatDate(String? dateTime) {
  if (dateTime != null) {
    try {
      DateTime date = DateTime.parse(dateTime);
      final DateFormat formatter = DateFormat('dd/MM/yyyy', 'pt_BR');

      return formatter.format(date);
    } catch (e) {
      return dateTime;
    }
  }
  return null;
}

String codeGenerate() {
  var code = const Uuid().v4();
  var shortCode = code.substring(0, 8);
  return shortCode;
}

Future<String> getVersion() async {
  final yamlFile = await rootBundle.loadString('pubspec.yaml');
  final yaml = loadYaml(yamlFile);
  final version = yaml['version'] as String;
  return version; // Retorna a versão completa, incluindo o número de build
}
