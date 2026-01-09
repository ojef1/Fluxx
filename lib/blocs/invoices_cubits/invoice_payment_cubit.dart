import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Fluxx/services/revenues_services.dart' as service;

part 'invoice_payment_state.dart';

class InvoicePaymentCubit extends Cubit<InvoicePaymentState> {
  InvoicePaymentCubit() : super(const InvoicePaymentState());

  void updateInvoiceInFocus({required InvoiceModel invoice}) {
    emit(state.copyWith(invoice: invoice));
  }

  void updatePaymentSelected(RevenueModel revenue) {
    emit(state.copyWith(paymentSelected: revenue));
  }

  Future<void> submitPaymentStatus() async {
    RevenueModel? payment = state.paymentSelected;
    InvoiceModel? invoice = state.invoice;
    if (payment?.id == null || invoice?.id == null) return;
    _updatePaymentResponseStatus(PaymentResponseStatus.loading);
    try {
      await Db.updateInvoicePaymentStatus(invoiceId: invoice!.id!, paymentId: payment!.id!);
      _updateResponseMessage('Conta paga com sucesso.');
      _updatePaymentResponseStatus(PaymentResponseStatus.success);
    } catch (e) {
      log('$e', name: 'updateBillPaymentStatus');
      _updateResponseMessage('Falha ao pagar a conta.');
      _updatePaymentResponseStatus(PaymentResponseStatus.error);
    }
  }

  Future<void> getAvailableRevenues(int monthId) async {
    _updateResponseStatus(ResponseStatus.loading);
    try {
      final revenuesList = await service.getRevenues(monthId);
      final availableRevenues =
          await service.calcAvailableValue(monthId, revenuesList);

      // exibição dos valores disponíveis
      emit(state.copyWith(availableRevenues: availableRevenues));

      _updateResponseStatus(ResponseStatus.success);
    } catch (error) {
      log('$error', name: 'getAvailableRevenues');
      _updateResponseStatus(ResponseStatus.error);
    }
  }

  void _updateResponseStatus(ResponseStatus status) {
    emit(state.copyWith(status: status));
  }

  void _updatePaymentResponseStatus(PaymentResponseStatus status) {
    emit(state.copyWith(paymentStatus: status));
  }

  Future<void> _updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }


  void resetState() {
    emit(const InvoicePaymentState());
  }
}
