
import 'package:Fluxx/blocs/bill_list_cubit/bill_list_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBillCubit extends Cubit<ListBillState> {
  ListBillCubit() : super(const ListBillState());

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

  

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  // Future<void> getBillsByCategory(int monthId, int categoryId) async {
  //   updateGetBillsResponse(GetBillsResponse.loaging);
  //   try {
  //     final bills = await Db.getBillsByMonthAndCategory(
  //       Tables.bills,
  //       monthId,
  //       categoryId,
  //     );

  //     final billsList = bills
  //         .map((item) => BillModel(
  //               id: item['id'],
  //               monthId: item['month_id'],
  //               categoryId: item['category_id'],
  //               name: item['name'],
  //               price: item['price'],
  //               isPayed: item['isPayed'],
  //             ))
  //         .toList();
  //     emit(state.copyWith(bills: billsList));
  //     updateGetBillsResponse(GetBillsResponse.success);
  //   } catch (error) {
  //     debugPrint('$error');
  //     updateGetBillsResponse(GetBillsResponse.error);
  //     emit(state.copyWith(bills: []));
  //   }
  // }

  

  Future<void> getAllBills(int monthId) async {
    updateGetBillsResponse(GetBillsResponse.loaging);
    try {
      final bills = await Db.getBillsByMonth(monthId);

      final billsList = bills.map((item) => BillModel.fromJson(item)).toList();
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
