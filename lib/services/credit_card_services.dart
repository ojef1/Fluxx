import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/bank_model.dart';
import 'package:Fluxx/models/card_network_model.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/utils/constants.dart';

BankModel getBank(int bankId) {
  return Banks.all.firstWhere((bank) => bank.id == bankId);
}

CardNetworkModel getCardNetwork(int cardNetworkId) {
  return CardNetwork.all.firstWhere((bank) => bank.id == cardNetworkId);
}

({DateTime start, DateTime end, DateTime referenceMonth})
    calculateInvoicePeriod({
  required DateTime date,
  required int closingDay,
}) {
  late DateTime end;

  if (date.day <= closingDay) {
    // fecha no mês atual
    end = DateTime(date.year, date.month, closingDay);
  } else {
    // fecha no próximo mês
    final nextMonth = DateTime(date.year, date.month + 1);
    end = DateTime(nextMonth.year, nextMonth.month, closingDay);
  }

  // início = dia seguinte ao fechamento anterior
  final prevClosing = DateTime(end.year, end.month - 1, closingDay);
  final start = prevClosing.add(const Duration(days: 1));

  return (
    start: start,
    end: end,
    referenceMonth: DateTime(end.year, end.month)
  );
}

double calcRemainingLimit(
    {required double totalLimit, required double totalSpent}) {
  return totalLimit - totalSpent;
}

Future<double> getCreditCardAvailableLimite(
    {required CreditCardModel card}) async {
  try {
    return await Db.getCreditCardAvailableLimite(card: card);
  } catch (e) {
    log('$e', name: 'getCreditCardAvailableLimite');
    return 0.0;
  }
}

double calcPercentSpent(
    {required double totalLimit, required double totalSpent}) {
  if (totalLimit <= 0) return 0.0;
  final percent = (totalSpent / totalLimit) * 100;
  // Garante que fique entre 0% e 100%
  return percent.clamp(0.0, 100.0);
}

String getInvoiceStatus({
  required String endDate,
  required int dueDay,
  required bool isPaid,
}) {
  if (isPaid) {
    return 'Fatura paga';
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final closingRaw = DateTime.parse(endDate);
  final closingDate = DateTime(
    closingRaw.year,
    closingRaw.month,
    closingRaw.day,
  );

  // Calcula vencimento corretamente
  DateTime dueDate;
  if (dueDay > closingDate.day) {
    // vence no mesmo mês
    dueDate = DateTime(
      closingDate.year,
      closingDate.month,
      dueDay,
    );
  } else {
    // vence no mês seguinte
    dueDate = DateTime(
      closingDate.year,
      closingDate.month + 1,
      dueDay,
    );
  }

  // Ajuste para meses sem esse dia (ex: 31/02)
  if (dueDate.day != dueDay) {
    dueDate = DateTime(
      dueDate.year,
      dueDate.month + 1,
      0, // último dia do mês anterior
    );
  }

  // 🔍 Status
  if (today.isBefore(closingDate)) {
    final days = closingDate.difference(today).inDays;
    return days == 0
        ? 'Fecha hoje'
        : 'Fecha em $days dia${days > 1 ? 's' : ''}';
  }

  if (!today.isAfter(dueDate)) {
    final days = dueDate.difference(today).inDays;
    return days == 0
        ? 'Vence hoje'
        : 'Vence em $days dia${days > 1 ? 's' : ''}';
  }

  final overdueDays = today.difference(dueDate).inDays;
  return 'Vencida há $overdueDays dia${overdueDays > 1 ? 's' : ''}';
}

Future<double> calcTotalRevenues(int monthId) async {
  try {
    final results = await Future.wait([
      _getMonthlyRevenue(monthId),
      _getSingleRevenue(monthId),
    ]);

    final combinedRevenuesList = [
      ...results[0],
      ...results[1],
    ];

    double total = 0;
    for (var revenue in combinedRevenuesList) {
      total += revenue.value!;
    }
    return total;
  } catch (error) {
    log('$error');
    return 0.0;
  }
}

Future<List<RevenueModel>> _getMonthlyRevenue(int monthId) async {
  try {
    final revenue = await Db.getMonthlyRevenues(monthId);

    final monthlyRevenuesList =
        revenue.map((item) => RevenueModel.fromJson(item)).toList();
    return monthlyRevenuesList;
  } catch (error) {
    log('$error');

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
    log('$error');
    return [];
  }
}

Future<InvoiceModel?> getInvoice({
  required CreditCardModel card,
  required DateTime referenceDate,
}) async {
  try {
    final invoice = await Db.getCreditCardInvoice(
      creditCard: card,
      referenceDate: referenceDate,
    );
    return invoice;
  } catch (e) {
    log('$e', name: 'getInvoice');
  }
  return null;
}

Future<List<InvoiceModel>> getInvoicesByMonth(int monthId) async {
  try {
    final result = await Db.getInvoicesByMonth(monthId);
    final invoices = result.map((item) => InvoiceModel.fromJson(item)).toList();
    return invoices;
  } catch (e) {
    log('$e', name: 'getInvoice');
  }
  return [];
}

Future<CreditCardModel?> getCreditCardById(String cardId) async {
  try {
    var result = await Db.getCreditCardById(cardId);
    if (result != null) {
      final card = CreditCardModel.fromJson(result);
      return card;
    } else {
      return null;
    }
  } catch (e) {
    log('$e', name: 'deleteCreditCard');
    return null;
  }
}

Future<List<CreditCardModel>> getCardsList() async {
  try {
    var result = await Db.getCreditCards();
    final cardsList =
        result.map((item) => CreditCardModel.fromJson(item)).toList();
    log('lista de cartões : $cardsList');
    return cardsList;
  } catch (e) {
    log('Erro ao buscar os cartões : $e', name: 'getCardsList');
    rethrow;
  }
}

CreditCardModel getCardFromInvoice({
  required List<CreditCardModel> cards,
  required InvoiceModel invoice,
}) {
  return cards.firstWhere((card) => card.id == invoice.creditCardId);
}
