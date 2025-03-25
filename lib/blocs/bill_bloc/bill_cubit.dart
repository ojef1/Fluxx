import 'package:Fluxx/blocs/bill_bloc/bill_state.dart';
import 'package:Fluxx/blocs/bill_list_bloc/bill_list_cubit.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/extensions/category_extension.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class BillCubit extends Cubit<BillState> {
  BillCubit() : super(const BillState());

  void updateBillStatus(int status) {
    emit(state.copyWith(billIsPayed: status));
  }

  void updatePaymentDate(String? date) {
    if (date != null) {
      var formattedDate = formatDate(date);
      emit(state.copyWith(paymentDate: formattedDate));
    }
  }

  void _updateMonthTotalValues(int monthId) {
    GetIt.I<ListBillCubit>().getMonthTotalSpent(monthId);
    GetIt.I<ListBillCubit>().getMonthTotalPayed(monthId);
  }

  void updateAddBillsResponse(AddBillsResponse addBillsResponse) {
    emit(state.copyWith(addBillsResponse: addBillsResponse));
  }

  void updateEditBillsResponse(EditBillsResponse editBillsResponse) {
    emit(state.copyWith(editBillsResponse: editBillsResponse));
  }

  void updateRemoveBillsResponse(RemoveBillsResponse removeBillsResponse) {
    emit(state.copyWith(removeBillsResponse: removeBillsResponse));
  }

  void updateCategoryInFocus(int category) {
    Categorys categoryInFocus = CategoryExtension.toEnum(category);
    emit(state.copyWith(categoryInFocus: categoryInFocus));
  }

  void updateEditCategoryInFocus(int category) {
    Categorys editCategoryInFocus = CategoryExtension.toEnum(category);
    emit(state.copyWith(editCategoryInFocus: editCategoryInFocus));
    print(state.billIsPayed);
  }

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  String codeVoucherGenerate() {
    var code = const Uuid().v4();
    var shortCode = code.substring(0, 8);
    return shortCode;
  }

  Future<int> addNewBill(BillModel newBill) async {
    updateAddBillsResponse(AddBillsResponse.loaging);
    try {
      var result = await Db.insertBill(Tables.bills, newBill);
      if (result != -1) {
        await updateSuccessMessage('Conta adicionada com sucesso.');
        updateAddBillsResponse(AddBillsResponse.success);
        _updateMonthTotalValues(newBill.monthId!);
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
        updateEditBillsResponse(EditBillsResponse.success);
        _updateMonthTotalValues(bill.monthId!);
        return result;
      } else {
        updateErrorMessage('Falha ao Editar a conta.');
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
