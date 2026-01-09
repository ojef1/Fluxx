import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/services/revenues_services.dart' as service;
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueCubit extends Cubit<RevenueState> {
  RevenueCubit() : super(const RevenueState());

  void updateGetRevenueResponse(GetRevenueResponse getRevenueResponse) {
    emit(state.copyWith(getRevenueResponse: getRevenueResponse));
  }

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  Future<void> getRevenues(int monthId) async {
    updateGetRevenueResponse(GetRevenueResponse.loading);
    try {
      final revenuesList = await service.getRevenues(monthId);
      emit(state.copyWith(revenuesList: revenuesList));
      await _calculateAvailableValue(monthId, revenuesList);
      calculateTotalRevenues();
      updateGetRevenueResponse(GetRevenueResponse.success);
    } catch (error) {
      debugPrint('$error');
      updateGetRevenueResponse(GetRevenueResponse.error);
      emit(state.copyWith(revenuesList: state.revenuesList));
    }
  }


  Future<void> _calculateAvailableValue(int monthId, List<RevenueModel> revenues) async {
    try {
      final List<RevenueModel> availableRevenues = await service.calcAvailableValue(monthId,revenues);

      emit(state.copyWith(availableRevenues: availableRevenues));
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future<double> calculateTotalRevenues() async {
    List<RevenueModel> revenuesList = state.revenuesList;
    double total = 0;
    for (var revenue in revenuesList) {
      total += revenue.value!;
    }
    emit(state.copyWith(totalRevenue: total));
    return total;
  }

  Future<void> calculateRemainigRevenues(int monthId) async {
    double total = state.totalRevenue;
    double remaining = 0;

    double totalLinkedSpent = await Db.getBoundBillsTotalByMonth(monthId);
    remaining = total - totalLinkedSpent;
    emit(state.copyWith(remainingRevenue: remaining));
  }

  void resetState() {
    emit(const RevenueState());
  }
}
