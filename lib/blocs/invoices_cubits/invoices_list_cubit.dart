import 'dart:developer';

import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Fluxx/services/credit_card_services.dart' as service;

part 'invoices_list_state.dart';

class InvoicesListCubit extends Cubit<InvoicesListState> {
  InvoicesListCubit() : super(const InvoicesListState());

  void _updateResponseStatus(ResponseStatus status) {
    emit(state.copyWith(status: status));
  }

  Future<void> _updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }

  Future<void> getInvoices(int monthId) async {
    _updateResponseStatus(ResponseStatus.loading);
    try {
      final cards = await service.getCardsList();
      final invoices = await service.getInvoicesByMonth(monthId);
      emit(state.copyWith(invoicesList: invoices, cardsList: cards));
      _updateResponseMessage('');
      _updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      log('Erro ao pegar as faturas', name: 'getInvoices');
      _updateResponseMessage('Erro ao pegar as faturas');
      _updateResponseStatus(ResponseStatus.error);
    }
  }


  void resetState() {
    emit(const InvoicesListState());
  }
}
