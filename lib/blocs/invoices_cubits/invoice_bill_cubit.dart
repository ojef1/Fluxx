import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/invoice_bill_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'invoice_bill_state.dart';

class InvoiceBillCubit extends Cubit<InvoiceBillState> {
  InvoiceBillCubit() : super(const InvoiceBillState());

  void updateIdToGet(String id){
    emit(state.copyWith(idToGet: id));
  }

  Future<void> getInvoiceBill() async {
    _updateResponse(ResponseStatus.loading);
    try {
      final bill = await Db.getInvoiceBillById(state.idToGet);
      if (bill != null) {
        final billModel = InvoiceBillModel.fromJson(bill);
        _updateResponse(ResponseStatus.success);
        emit(state.copyWith(bill: billModel));
      } else {
      _updateResponse(ResponseStatus.error);
        throw Exception('Conta não encontrada');
      }
    } catch (e) {
      _updateResponseMessage('Não possível carregar os detalhes');
      _updateResponse(ResponseStatus.error);
    }
  }

  Future<int> deleteInvoiceBill({required String id, required String invoiceId})async{
    _updateResponse(ResponseStatus.loading);
    try {
      var result = await Db.deleteInvoiceBill(billId: id, invoiceId: invoiceId);
      if (result > 0) {
        _updateResponseMessage('Compra removida com sucesso!');
        _updateResponse(ResponseStatus.success);
        return result;
      } else {
        _updateResponseMessage('Erro ao remover a Compra');
        _updateResponse(ResponseStatus.error);
        return result;
      }
    } catch (e) {
      log('$e', name: 'deleteInvoiceBill');
      _updateResponseMessage('Erro ao remover a Compra');
      _updateResponse(ResponseStatus.error);
      return 0;
    }
  }

  void _updateResponse(ResponseStatus status) {
    emit(state.copyWith(status: status));
  }

  void _updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }

  void resetState() {
    emit(const InvoiceBillState());
  }
}
