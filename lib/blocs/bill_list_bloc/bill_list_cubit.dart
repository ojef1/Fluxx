import 'package:Fluxx/blocs/bill_list_bloc/bill_list_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/extensions/category_extension.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBillCubit extends Cubit<ListBillState> {
  ListBillCubit() : super(const ListBillState());

  Future<void> getStats(int monthId) async {
    updateGetStatsResponse(GetStatsResponse.loaging);
    try {
      final totalSpent = await Db.getTotalByCategory(monthId);
      List<CategoryModel> stats = totalSpent.map((item) {
        return CategoryModel(
          categoryName: CategoryExtension.fromIntToString(item['category_id']),
          price: item['total'],
        );
      }).toList();
      emit(state.copyWith(stats: stats));
      updateGetStatsResponse(GetStatsResponse.success);
    } catch (error) {
      debugPrint('$error');
      updateGetStatsResponse(GetStatsResponse.error);
    }
  }

  Future<void> getMonthTotalSpent(int monthId) async {
    // updateGetBillsResponse(GetBillsResponse.loaging);
    try {
      final totalSpent = await Db.sumPricesByMonth(monthId);
      _updateMonthTotalSpent(totalSpent);
      // updateGetBillsResponse(GetBillsResponse.success);
    } catch (error) {
      debugPrint('$error');
      // updateGetBillsResponse(GetBillsResponse.error);
    }
  }

  Future<void> getMonthTotalPayed(int monthId) async {
    // updateGetBillsResponse(GetBillsResponse.loaging);
    try {
      final totalSpent = await Db.sumPricesByMonthPayed(monthId);
      _updateMonthTotalPaid(totalSpent);
      // updateGetBillsResponse(GetBillsResponse.success);
    } catch (error) {
      debugPrint('$error');
      // updateGetBillsResponse(GetBillsResponse.error);
    }
  }

  void _updateMonthTotalSpent(double monthTotalSpent) {
    emit(state.copyWith(monthTotalSpent: monthTotalSpent));
  }

  void _updateMonthTotalPaid(double monthTotalPaid) {
    emit(state.copyWith(monthTotalPaid: monthTotalPaid));
  }

  void updateGetBillsResponse(GetBillsResponse getBillsResponse) {
    emit(state.copyWith(getBillsResponse: getBillsResponse));
  }

  void updateGetStatsResponse(GetStatsResponse getStatsResponse) {
    emit(state.copyWith(getStatsResponse: getStatsResponse));
  }

  void updateMonthInFocus(MonthModel month) {
    emit(state.copyWith(monthInFocus: month));
  }

  void updateCategoryInFocus(String category) {
    Categorys categoryInFocus;
    switch (category) {
      case 'Casa':
        categoryInFocus = Categorys.casa;
        break;
      case "Transporte":
        categoryInFocus = Categorys.transporte;
        break;
      case "Saúde":
        categoryInFocus = Categorys.saude;
        break;
      case "Lazer":
        categoryInFocus = Categorys.lazer;
        break;
      case "Alimentação":
        categoryInFocus = Categorys.alimentacao;
        break;
      default:
        categoryInFocus = Categorys.casa;
    }
    emit(state.copyWith(categoryInFocus: categoryInFocus));
  }

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  Future<void> getBillsByCategory(int monthId, int categoryId) async {
    updateGetBillsResponse(GetBillsResponse.loaging);
    try {
      final bills = await Db.getBillsByMonthAndCategory(
        Tables.bills,
        monthId,
        categoryId,
      );

      final billsList = bills
          .map((item) => BillModel(
                id: item['id'],
                monthId: item['month_id'],
                categoryId: item['category_id'],
                name: item['name'],
                price: item['price'],
                isPayed: item['isPayed'],
              ))
          .toList();
      emit(state.copyWith(bills: billsList));
      updateGetBillsResponse(GetBillsResponse.success);
    } catch (error) {
      debugPrint('$error');
      updateGetBillsResponse(GetBillsResponse.error);
      emit(state.copyWith(bills: []));
    }
  }

  Future<void> getAllBills(int monthId) async {
    updateGetBillsResponse(GetBillsResponse.loaging);
    try {
      final bills = await Db.getBillsByMonth(Tables.bills, monthId);

      final billsList = bills
          .map((item) => BillModel(
                id: item['id'],
                monthId: item['month_id'],
                name: item['name'],
                categoryId: item['category_id'],
                price: item['price'],
                isPayed: item['isPayed'],
              ))
          .toList();
      emit(state.copyWith(bills: billsList));
      updateGetBillsResponse(GetBillsResponse.success);
    } catch (error) {
      debugPrint('$error');
      updateGetBillsResponse(GetBillsResponse.error);
      emit(state.copyWith(bills: []));
    }
  }

  void clearlistOfBills() {
    emit(state.copyWith(bills: []));
  }

  void resetState() {
    emit(const ListBillState());
  }
}
