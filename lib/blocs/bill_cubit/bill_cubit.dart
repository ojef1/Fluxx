import 'dart:developer';

import 'package:Fluxx/blocs/bill_cubit/bill_state.dart';
import 'package:Fluxx/blocs/bill_list_cubit/bill_list_cubit.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class BillCubit extends Cubit<BillState> {
  BillCubit() : super(const BillState());

  void updateBillPaymentStatus(int isPayed) {
    //0 false -- 1 true
    final detailBill = state.detailBill;
    if (detailBill == null) return;

    BillModel newBill = BillModel(
      id: detailBill.id,
      name: detailBill.name,
      price: detailBill.price,
      paymentDate: detailBill.paymentDate,
      description: detailBill.description,
      monthId: detailBill.monthId,
      categoryId: detailBill.categoryId,
      paymentId: detailBill.paymentId,
      categoryName: detailBill.categoryName,
      paymentName: detailBill.paymentName,
      isPayed: isPayed,
    );

    emit(state.copyWith(detailBill: newBill));
  }

  Future<void> submitPaymentStatus(int isPayed) async {
    updateEditBillsResponse(EditBillsResponse.loading);
    try {
      //esse função só deve ser chamada em cenários em que o id existe
      await Db.updatePaymentStatus(state.detailBill!.id!, isPayed);
      updateSuccessMessage('Conta editada com sucesso.');
      updateEditBillsResponse(EditBillsResponse.success);
    } catch (e) {
      updateErrorMessage('Falha ao Editar a conta.');
      log('$e', name: 'updateBillPaymentStatus');
      updateEditBillsResponse(EditBillsResponse.error);
    }
  }

  Future<void> getBill(String billId, int monthId) async {
    updateGetBillResponse(GetBillResponse.loading);

    try {
      final bill = await Db.getBillById(billId, monthId);
      if (bill != null) {
        final billModel = BillModel.fromJson(bill);
        updateGetBillResponse(GetBillResponse.success);
        emit(state.copyWith(detailBill: billModel));
      } else {
        updateGetBillResponse(GetBillResponse.error);
        throw Exception('Conta não encontrada');
      }
    } catch (error) {
      debugPrint('$error');
      updateGetBillResponse(GetBillResponse.error);
      rethrow;
    }
  }

  void _updateMonthTotalValues(int monthId) {
    GetIt.I<ListBillCubit>().getMonthTotalSpent(monthId);
    GetIt.I<ListBillCubit>().getMonthTotalPayed(monthId);
  }

  void updateGetBillResponse(GetBillResponse getBillResponse) {
    emit(state.copyWith(getBillResponse: getBillResponse));
  }


  void updateEditBillsResponse(EditBillsResponse editBillsResponse) {
    emit(state.copyWith(editBillsResponse: editBillsResponse));
  }

  void updateRemoveBillsResponse(RemoveBillsResponse removeBillsResponse) {
    emit(state.copyWith(removeBillsResponse: removeBillsResponse));
  }

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  Future<int> removeBill(String billId, int monthId) async {
    updateRemoveBillsResponse(RemoveBillsResponse.loading);
    try {
      var result = await Db.deleteBill(Tables.bills, billId);
      //função delete retorna quantas linhas foram removidas
      if (result > 0) {
        updateSuccessMessage('Conta removida com sucesso.');
        updateRemoveBillsResponse(RemoveBillsResponse.success);
        _updateMonthTotalValues(monthId);
        await GetIt.I<ListBillCubit>().getAllBills(monthId);
        return result;
      } else {
        updateErrorMessage('Falha ao remover a conta.');
        updateRemoveBillsResponse(RemoveBillsResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateRemoveBillsResponse(RemoveBillsResponse.error);
      return 0;
    }
  }

  void resetState() {
    emit(const BillState());
  }
}
