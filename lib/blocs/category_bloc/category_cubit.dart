import 'package:Fluxx/blocs/bill_bloc/bill_state.dart';
import 'package:Fluxx/blocs/category_bloc/category_state.dart';
import 'package:Fluxx/blocs/bill_list_bloc/bill_list_cubit.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/extensions/category_extension.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  Future<void> getCategorys() async {
    updateGetCategorysResponse(GetCategoriesResponse.loaging);
    try {
      final result = await Db.getCategories();
      final categorys = result
          .map((item) => CategoryModel(
                id: item['id'],
                categoryName: item['name'],
              ))
          .toList();
      emit(state.copyWith(categories: categorys));
      updateGetCategorysResponse(GetCategoriesResponse.success);
    } catch (e) {
      updateErrorMessage(e.toString());
      updateGetCategorysResponse(GetCategoriesResponse.error);
    }
  }

  // void updateBillStatus(int status) {
  //   emit(state.copyWith(billIsPayed: status));
  // }

  // void updatePaymentDate(String? date) {
  //   if (date != null) {
  //     var formattedDate = formatDate(date);
  //     emit(state.copyWith(paymentDate: formattedDate));
  //   }
  // }

  // void _updateMonthTotalValues(int monthId) {
  //   GetIt.I<MonthsDetailCubit>().getMonthTotalSpent(monthId);
  //   GetIt.I<MonthsDetailCubit>().getMonthTotalPayed(monthId);
  // }

  void updateAddCategorysResponse(AddCategoriesResponse addCategorysResponse) {
    emit(state.copyWith(addCategoriesResponse: addCategorysResponse));
  }

  void updateGetCategorysResponse(GetCategoriesResponse getCategorysResponse) {
    emit(state.copyWith(getCategoriesResponse: getCategorysResponse));
  }

  // void updateEditBillsResponse(EditBillsResponse editBillsResponse) {
  //   emit(state.copyWith(editBillsResponse: editBillsResponse));
  // }

  // void updateRemoveBillsResponse(RemoveBillsResponse removeBillsResponse) {
  //   emit(state.copyWith(removeBillsResponse: removeBillsResponse));
  // }

  void updateSelectedCategory(CategoryModel category) {
    emit(state.copyWith(selectedCategory: category));
  }

  // void updateEditCategoryInFocus(int category) {
  //   Categorys editCategoryInFocus = CategoryExtension.toEnum(category);
  //   emit(state.copyWith(editCategoryInFocus: editCategoryInFocus));
  //   print(state.billIsPayed);
  // }

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  Future<int> addCategory(CategoryModel category) async {
    updateAddCategorysResponse(AddCategoriesResponse.loaging);
    try {
      var result = await Db.insertCategory(category);
      if (result != -1) {
        await updateSuccessMessage('Categoria adicionada com sucesso.');
        updateAddCategorysResponse(AddCategoriesResponse.success);
        return result;
      } else {
        await updateErrorMessage('Falha ao adicionar a categoria.');
        updateAddCategorysResponse(AddCategoriesResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateAddCategorysResponse(AddCategoriesResponse.error);
      return -1;
    }
  }

  void resetState(){
    emit(const CategoryState());
  }

  // Future<int> removeBill(String billId, int monthId) async {
  //   updateRemoveBillsResponse(RemoveBillsResponse.loaging);
  //   try {
  //     var result = await Db.deleteBill(Tables.bills, billId);
  //     //função delete retorna quantas linhas foram removidas
  //     if (result > 0) {
  //       updateSuccessMessage('Conta removida com sucesso.');
  //       updateRemoveBillsResponse(RemoveBillsResponse.success);
  //       _updateMonthTotalValues(monthId);
  //       return result;
  //     } else {
  //       updateErrorMessage('Falha ao remover a conta.');
  //       updateRemoveBillsResponse(RemoveBillsResponse.error);
  //       return result;
  //     }
  //   } catch (error) {
  //     debugPrint('$error');
  //     updateRemoveBillsResponse(RemoveBillsResponse.error);
  //     return 0;
  //   }
  // }

  // Future<int> editBill(BillModel bill) async {
  //   updateEditBillsResponse(EditBillsResponse.loaging);
  //   try {
  //     var result = await Db.updateBill(Tables.bills, bill.id!, bill);
  //     if (result > 0) {
  //       updateSuccessMessage('Conta editada com sucesso.');
  //       updateEditBillsResponse(EditBillsResponse.success);
  //       _updateMonthTotalValues(bill.monthId!);
  //       return result;
  //     } else {
  //       updateErrorMessage('Falha ao Editar a conta.');
  //       updateEditBillsResponse(EditBillsResponse.error);
  //       return result;
  //     }
  //   } catch (error) {
  //     debugPrint('$error');
  //     updateEditBillsResponse(EditBillsResponse.error);
  //     return 0;
  //   }
  // }

  // void resetState() {
  //   emit(const BillState());
  // }
}
