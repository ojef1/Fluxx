import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:Fluxx/services/app_period_service.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/utils/helpers.dart';
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
    final percent = calcPercent(
      income: totalIncome,
      total: state.totalSpent,
    );
    emit(state.copyWith(percentSpent: percent));
    return;
  }

  Future<void> getPriorityInvoice() async {
    _updatePriorityInvoiceStatus(GetPriorityInvoiceStatus.loading);
    try {
      int monthId = AppPeriodService().monthInFocus.id!;
      final invoices = await getInvoicesByMonth(monthId);
      final cards = await getAllCardsList();
      if (invoices.isEmpty) {
        _updatePriorityInvoiceStatus(GetPriorityInvoiceStatus.success);
        return;
      }

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
