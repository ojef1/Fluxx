import 'package:Fluxx/components/custom_flushbar.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

 Color getBarColor(double percent) {
    if (percent < 0.5) return Colors.green;
    if (percent < 0.8) return Colors.orange;
    if (percent > 0.8) return Colors.red;

    return Colors.red;
  }

String formatPrice(double price) {
  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');
  return currencyFormatter.format(price);
}

//qualquer número diferente de zero será interpretado como true
bool intToBool(int value) {
  return value != 0;
}

Future<void> showFlushbar(BuildContext context, String message, bool isError) async {
  if (isError) {
    await CustomSnackBar.show(
        context: context,
        message: message,
        icon: Icons.warning_rounded,
        color: Colors.red);
  } else {
    await CustomSnackBar.show(
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
