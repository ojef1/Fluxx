import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/invoice_bill_model.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'invoice_bill_list_state.dart';

class InvoiceBillListCubit extends Cubit<InvoiceListBillState> {
  InvoiceBillListCubit() : super(const InvoiceListBillState());

  void updateInvoiceInFocus({required InvoiceModel invoice}) {
    emit(state.copyWith(invoice: invoice));
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
      final bills = await Db.getInvoiceBills(state.invoice!.id!);

      final billsList =
          bills.map((item) => InvoiceBillModel.fromJson(item)).toList();
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
