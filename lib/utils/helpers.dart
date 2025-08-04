import 'package:Fluxx/components/custom_flushbar.dart';
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

String? formatDate(String? dateTime) {
  if (dateTime != null) {
    DateTime date = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd/MM/yyyy', 'pt_BR');

    return formatter.format(date);
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
