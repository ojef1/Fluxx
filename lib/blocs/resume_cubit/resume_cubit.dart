import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'resume_state.dart';

class ResumeCubit extends Cubit<ResumeState> {
  ResumeCubit() : super(const ResumeState());

  String getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Bom dia,';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde,';
    } else {
      return 'Boa noite,';
    }
  }

  Future<MonthModel> getActualMonth() async {
    try{
      
      var result = await Db.getMonths(DateTime.now().year);
      List<MonthModel> monthsList = result
          .map<MonthModel>((monthMap) => MonthModel.fromJson(monthMap))
          .toList();
      final currentMonthNumber = DateTime.now().month;
      final actualMonth = monthsList
          .firstWhere((month) => month.monthNumber == currentMonthNumber);
      final totalSpent = await Db.sumPricesByMonth(actualMonth.id!);
      final monthModel = MonthModel(
        id: actualMonth.id,
        yearId: actualMonth.yearId,
        name: actualMonth.name,
        monthNumber: actualMonth.monthNumber,
        total: totalSpent,
      );
      emit(state.copyWith(currentMonth: monthModel));
      return monthModel;
    } catch (error) {
      log('Erro ao obter mês atual: $error');
      rethrow;
    }
  }

  void updateMonthInFocus(MonthModel month) {
    emit(state.copyWith(monthInFocus: month));
  }

  Future<void> getTotalSpent(int monthId) async {
    _updateTotalSpentStatus(TotalSpentStatus.loading);
    try {
      final total = await Db.getTotalByMonth(monthId);

      emit(state.copyWith(totalSpent: total));
      _updateTotalSpentStatus(TotalSpentStatus.success);
    } catch (error) {
      debugPrint('$error');
      _updateTotalSpentStatus(TotalSpentStatus.error);
      emit(state.copyWith(totalSpent: 0.0));
    }
  }

  void _updateTotalSpentStatus(TotalSpentStatus status) {
    emit(state.copyWith(totalSpentStatus: status));
  }

  void _updatePriorityInvoiceStatus(GetPriorityInvoiceStatus status) {
    emit(state.copyWith(priorityInvoiceStatus: status));
  }

  Future<void> calculatePercent(double totalIncome) async {
    final totalSpent = state.totalSpent;
    if (totalIncome == 0.0) {
      // Não tem receita, então não calcula porcentagem
      emit(state.copyWith(percentSpent: 0.0));
      return;
    } else {
      final percent = (totalSpent / totalIncome) * 100;
      emit(state.copyWith(percentSpent: percent));
      return;
    }
  }

  Future<void> getPriorityInvoice() async {
    _updatePriorityInvoiceStatus(GetPriorityInvoiceStatus.loading);
    try {
      int monthId = state.monthInFocus!.id!;
      final invoices = await getInvoicesByMonth(monthId);
      final cards = await getAllCardsList();
      if (invoices.isEmpty) return;

      emit(state.copyWith(cardsList: cards));
      final now = DateTime.now();

      // remove pagas e inválidas
      final validInvoices = invoices.where((invoice) {
        if (invoice.isPaid == 1) return false;
        return int.tryParse(invoice.dueDate ?? '') != null;
      }).toList();

      if (validInvoices.isEmpty) return;

      // separa vencidas e não vencidas
      final overdue = <InvoiceModel>[];
      final upcoming = <InvoiceModel>[];

      for (final invoice in validInvoices) {
        final dueDay = int.parse(invoice.dueDate!);

        final dueDate = DateTime(
          now.year,
          now.month,
          dueDay,
          23,
          59,
          59,
        );

        if (dueDate.isBefore(now)) {
          overdue.add(invoice);
        } else {
          upcoming.add(invoice);
        }
      }

      InvoiceModel priorityInvoice;

      // Se houver vencidas → pega a MAIS atrasada
      if (overdue.isNotEmpty) {
        overdue.sort((a, b) {
          final aDue = DateTime(now.year, now.month, int.parse(a.dueDate!));
          final bDue = DateTime(now.year, now.month, int.parse(b.dueDate!));

          return aDue.compareTo(bDue); // mais antiga primeiro
        });

        priorityInvoice = overdue.first;
      } else {
        // Senão → pega a que vence primeiro
        upcoming.sort((a, b) {
          final aDue = DateTime(now.year, now.month, int.parse(a.dueDate!));
          final bDue = DateTime(now.year, now.month, int.parse(b.dueDate!));

          return aDue.compareTo(bDue);
        });

        priorityInvoice = upcoming.first;
      }

      final length = await getInvoiceBillsLength(priorityInvoice.id!);
      emit(
        state.copyWith(
          priorityInvoice: priorityInvoice.copyWith(
            invoiceBillsLength: length,
          ),
        ),
      );
      _updatePriorityInvoiceStatus(GetPriorityInvoiceStatus.success);
    } catch (e) {
      log(
        'Erro ao buscar fatura prioritária: $e',
        name: 'getPriorityInvoice',
      );
      _updatePriorityInvoiceStatus(GetPriorityInvoiceStatus.error);
      return;
    }
  }

  void resetState() {
    emit(const ResumeState());
  }
}
