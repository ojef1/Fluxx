
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/invoice_bill_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'invoice_bill_list_state.dart';

class InvoiceBillListCubit extends Cubit<InvoiceListBillState> {
  InvoiceBillListCubit() : super(const InvoiceListBillState());

  void updateIdToGet({required String invoiceId}){
    emit(state.copyWith(idToGet: invoiceId));
  }

  void _updateResponseStatus(ResponseStatus status) {
    emit(state.copyWith(status: status));
  }  

  Future<void> _updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }  

  Future<void> getInvoiceBills() async {
    _updateResponseStatus(ResponseStatus.loading);
    try {
      final bills = await Db.getInvoiceBills(state.idToGet);

      final billsList = bills.map((item) => InvoiceBillModel.fromJson(item)).toList();
      emit(state.copyWith(bills: billsList));
      _updateResponseStatus(ResponseStatus.success);
    } catch (error) {
      debugPrint('$error');
      emit(state.copyWith(bills: []));
      _updateResponseStatus(ResponseStatus.error);
      _updateResponseMessage('$error');
    }
  }

  void resetState() {
    emit(const InvoiceListBillState());
  }
}
