import 'package:Fluxx/blocs/bill_cubit/bill_state.dart';
import 'package:Fluxx/blocs/bill_list_cubit/bill_list_cubit.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class BillCubit extends Cubit<BillState> {
  BillCubit() : super(const BillState());

  void updatePaymentDate(String? date, bool isEditing) {
    //na edição, a data já vem formatada
    if (isEditing) {
      emit(state.copyWith(paymentDate: date));
    } else {
      if (date != null) {
        var formattedDate = formatDate(date);
        emit(state.copyWith(paymentDate: formattedDate));
      }
    }
  }

  Future<void> getBill(String billId, int monthId) async {
    updateGetBillResponse(GetBillResponse.loaging);

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

  //TODO remover essas funções, já existem no add_bill_cubit
  void updateAddBillsResponse(AddBillsResponse addBillsResponse) {
    emit(state.copyWith(addBillsResponse: addBillsResponse));
  }

  void updateEditBillsResponse(EditBillsResponse editBillsResponse) {
    emit(state.copyWith(editBillsResponse: editBillsResponse));
  }

  void updateRemoveBillsResponse(RemoveBillsResponse removeBillsResponse) {
    emit(state.copyWith(removeBillsResponse: removeBillsResponse));
  }

  
  //TODO remover essa função, já existe no add_bill_cubit
  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  //TODO remover essa função, já existe no add_bill_cubit
  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  String codeVoucherGenerate() {
    var code = const Uuid().v4();
    var shortCode = code.substring(0, 8);
    return shortCode;
  }


  //TODO remover essa função, já existe no add_bill_cubit
  Future<int> addNewBill(BillModel newBill) async {
    updateAddBillsResponse(AddBillsResponse.loaging);
    try {
      var result = await Db.insertBill(Tables.bills, newBill);
      if (result != -1) {
        await updateSuccessMessage('Conta adicionada com sucesso.');
        updateAddBillsResponse(AddBillsResponse.success);
        _updateMonthTotalValues(newBill.monthId!);

        await GetIt.I<ListBillCubit>().getAllBills(newBill.monthId!);
        return result;
      } else {
        await updateErrorMessage('Falha ao adicionar a conta.');
        updateAddBillsResponse(AddBillsResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateAddBillsResponse(AddBillsResponse.error);
      return -1;
    }
  }

  Future<int> removeBill(String billId, int monthId) async {
    updateRemoveBillsResponse(RemoveBillsResponse.loaging);
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

  Future<int> editBill(BillModel bill) async {
    updateEditBillsResponse(EditBillsResponse.loaging);
    try {
      var result = await Db.updateBill(Tables.bills, bill.id!, bill);
      if (result > 0) {
        updateSuccessMessage('Conta editada com sucesso.');
        debugPrint('editBill : Conta editada com sucesso.');
        updateEditBillsResponse(EditBillsResponse.success);
        _updateMonthTotalValues(bill.monthId!);
        await GetIt.I<ListBillCubit>().getAllBills(bill.monthId!);
        return result;
      } else {
        updateErrorMessage('Falha ao Editar a conta.');
        debugPrint('editBill : Falha ao Editar a conta.');
        updateEditBillsResponse(EditBillsResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateEditBillsResponse(EditBillsResponse.error);
      return 0;
    }
  }

  void resetState() {
    emit(const BillState());
  }
}
