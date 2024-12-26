import 'package:Fluxx/components/custom_flushbar.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String formatPrice(double price) {
  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');
  return currencyFormatter.format(price);
}

//qualquer número diferente de zero será interpretado como true
bool intToBool(int value) {
  return value != 0;
}

void showFlushbar(BuildContext context, String message, bool isError) {
  if (isError) {
    CustomSnackBar.show(
        context: context,
        message: message,
        icon: Icons.warning_rounded,
        color: Colors.red);
  } else {
    CustomSnackBar.show(
        context: context,
        message: message,
        icon: Icons.check,
        color: AppTheme.colors.accentColor);
  }
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
