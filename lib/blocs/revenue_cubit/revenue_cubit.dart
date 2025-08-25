import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueCubit extends Cubit<RevenueState> {
  RevenueCubit() : super(const RevenueState());

  void updateAddRevenueResponse(AddRevenueResponse addRevenueResponse) {
    emit(state.copyWith(addRevenueResponse: addRevenueResponse));
  }

  void updateEditRevenueResponse(EditRevenueResponse editRevenueResponse) {
    emit(state.copyWith(editRevenueResponse: editRevenueResponse));
  }

  void updateRemoveRevenueResponse(
      RemoveRevenueResponse removeRevenueResponse) {
    emit(state.copyWith(removeRevenueResponse: removeRevenueResponse));
  }

  void updateGetRevenueResponse(GetRevenueResponse getRevenueResponse) {
    emit(state.copyWith(getRevenueResponse: getRevenueResponse));
  }

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  Future<int> addNewRevenue(RevenueModel newRevenue) async {
    updateAddRevenueResponse(AddRevenueResponse.loading);
    try {
      var result = await Db.insertRevenue(newRevenue);
      if (result != -1) {
        await updateSuccessMessage('renda adicionada com sucesso.');
        updateAddRevenueResponse(AddRevenueResponse.success);
        return result;
      } else {
        await updateErrorMessage('Falha ao adicionar a renda.');
        updateAddRevenueResponse(AddRevenueResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateAddRevenueResponse(AddRevenueResponse.error);
      return -1;
    }
  }

  Future<void> getRevenues(int monthId) async {
    updateGetRevenueResponse(GetRevenueResponse.loading);
    try {
      final results = await Future.wait([
        _getPublicRevenue(monthId),
        _getExclusiveRevenue(monthId),
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

  Future<List<RevenueModel>> _getPublicRevenue(int monthId) async {
    try {
      final revenue = await Db.getPublicRevenues(monthId);

      final publicRevenuesList =
          revenue.map((item) => RevenueModel.fromJson(item)).toList();
      return publicRevenuesList;
    } catch (error) {
      debugPrint('$error');

      return [];
    }
  }

  Future<List<RevenueModel>> _getExclusiveRevenue(int monthId) async {
    try {
      final revenue = await Db.getExclusiveRevenues(monthId);

      final exclusiveRevenuesList =
          revenue.map((item) => RevenueModel.fromJson(item)).toList();
      return exclusiveRevenuesList;
    } catch (error) {
      debugPrint('$error');
      return [];
    }
  }

  Future<int> removeRevenue(String revenueId,int currentMonthId) async {
    updateRemoveRevenueResponse(RemoveRevenueResponse.loading);
    try {
      var result = await Db.deactivateRevenue(revenueId, currentMonthId);
      //função delete retorna quantas linhas foram removidas
      if (result > 0) {
        updateSuccessMessage('renda removida com sucesso.');
        updateRemoveRevenueResponse(RemoveRevenueResponse.success);
        return result;
      } else {
        updateErrorMessage('Falha ao remover a renda.');
        updateRemoveRevenueResponse(RemoveRevenueResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateRemoveRevenueResponse(RemoveRevenueResponse.error);
      return 0;
    }
  }

  Future<int> editRevenue(RevenueModel revenue) async {
    updateEditRevenueResponse(EditRevenueResponse.loading);
    try {
      var result = await Db.updateRevenue(revenue);
      if (result > 0) {
        updateSuccessMessage('Conta editada com sucesso.');
        updateEditRevenueResponse(EditRevenueResponse.success);
        return result;
      } else {
        updateErrorMessage('Falha ao Editar a conta.');
        updateEditRevenueResponse(EditRevenueResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateEditRevenueResponse(EditRevenueResponse.error);
      return 0;
    }
  }

  void updateSelectedRevenue(RevenueModel revenue) {
    emit(state.copyWith(selectedRevenue: revenue));
  }

  void removeRevenueSelection() {
    RevenueModel unselected = RevenueModel(
      id: '',
      name: '',
      startMonthId: null,
      endMonthId: null,
      value: 0.0,
      isPublic: null,
    );
    emit(state.copyWith(selectedRevenue: unselected));
  }

  Future<void> calculateAvailableValue(int monthId) async {
    try {
      // 1. Obter todas as contas do mês
      final bills = await Db.getBillsByMonth(monthId);

      final billsList = bills.map((item) => BillModel.fromJson(item)).toList();

      // 2. Obter todas as rendas do mês
      await getRevenues(monthId);
      final revenuesList = state.revenuesList;

      // 3. Calcular o valor usado de cada renda
      Map<String, double> valorUsadoPorRenda = {};
      for (var bill in billsList) {
        if (bill.paymentId != null) {
          valorUsadoPorRenda[bill.paymentId!] =
              (valorUsadoPorRenda[bill.paymentId!] ?? 0) + bill.price!;
        }
      }

      // 4. Calcular o valor disponível de cada renda
      List<RevenueModel> valoresDisponiveis = revenuesList.map((revenue) {
        double valorUsado = valorUsadoPorRenda[revenue.id] ?? 0;
        double valorDisponivel = revenue.value! - valorUsado;

        return RevenueModel(
          id: revenue.id,
          name: revenue.name,
          isPublic: revenue.isPublic,
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
