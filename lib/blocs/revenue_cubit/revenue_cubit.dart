import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/bill_model.dart';
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
      final results = await Future.wait([
        _getMonthlyRevenue(monthId),
        _getSingleRevenue(monthId),
      ]);

      final combinedRevenuesList = [
        ...results[0],
        ...results[1],
      ];

      emit(state.copyWith(revenuesList: combinedRevenuesList));
      calculateTotalRevenues();
      updateGetRevenueResponse(GetRevenueResponse.success);
    } catch (error) {
      debugPrint('$error');
      updateGetRevenueResponse(GetRevenueResponse.error);
      emit(state.copyWith(revenuesList: state.revenuesList));
    }
  }

  Future<List<RevenueModel>> _getMonthlyRevenue(int monthId) async {
    try {
      final revenue = await Db.getMonthlyRevenues(monthId);

      final monthlyRevenuesList =
          revenue.map((item) => RevenueModel.fromJson(item)).toList();
      return monthlyRevenuesList;
    } catch (error) {
      debugPrint('$error');

      return [];
    }
  }

  Future<List<RevenueModel>> _getSingleRevenue(int monthId) async {
    try {
      final revenue = await Db.getSingleRevenues(monthId);

      final singleRevenuesList =
          revenue.map((item) => RevenueModel.fromJson(item)).toList();
      return singleRevenuesList;
    } catch (error) {
      debugPrint('$error');
      return [];
    }
  }

  Future<void> calculateAvailableValue(int monthId) async {
    try {
      // 1. Obter todas as contas do mês
      final bills = await Db.getBillsByMonth(monthId);

      final billsList = bills.map((item) => BillModel.fromJson(item)).toList();

      // 2. Obter todas as receitas do mês
      await getRevenues(monthId);
      final revenuesList = state.revenuesList;

      // 3. Calcular o valor usado de cada receita
      Map<String, double> valorUsadoPorReceita = {};
      for (var bill in billsList) {
        if (bill.paymentId != null) {
          valorUsadoPorReceita[bill.paymentId!] =
              (valorUsadoPorReceita[bill.paymentId!] ?? 0) + bill.price!;
        }
      }

      // 4. Calcular o valor disponível de cada receita
      List<RevenueModel> valoresDisponiveis = revenuesList.map((revenue) {
        double valorUsado = valorUsadoPorReceita[revenue.id] ?? 0;
        double valorDisponivel = revenue.value! - valorUsado;

        return RevenueModel(
          id: revenue.id,
          name: revenue.name,
          isMonthly: revenue.isMonthly,
          startMonthId: revenue.startMonthId,
          endMonthId: revenue.endMonthId,
          value: valorDisponivel,
        );
      }).toList(); // usar essa informação para bloquear opções de pagamentos

      // exibição dos valores disponíveis
      emit(state.copyWith(availableRevenues: valoresDisponiveis));
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
