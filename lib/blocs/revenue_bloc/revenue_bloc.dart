import 'package:Fluxx/blocs/revenue_bloc/revenue_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
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
        _getPublicRevenue(),
        _getExclusiveRevenue(monthId),
      ]);

      final combinedRevenuesList = [
        ...results[0],
        ...results[1],
      ];

      emit(state.copyWith(revenuesList: combinedRevenuesList));
      updateGetRevenueResponse(GetRevenueResponse.success);
    } catch (error) {
      debugPrint('$error');
      updateGetRevenueResponse(GetRevenueResponse.error);
      emit(state.copyWith(revenuesList: state.revenuesList));
    }
  }

  Future<List<RevenueModel>> _getPublicRevenue() async {
    try {
      final revenue = await Db.getPublicRevenues();

      final publicRevenuesList = revenue
          .map((item) => RevenueModel(
                id: item['id'],
                name: item['name'],
                monthId: item['month_id'],
                value: item['value'],
                isPublic: item['isPublic'],
              ))
          .toList();
      return publicRevenuesList;
    } catch (error) {
      debugPrint('$error');

      return [];
    }
  }

  Future<List<RevenueModel>> _getExclusiveRevenue(int monthId) async {
    try {
      final revenue = await Db.getExclusiveRevenues(monthId);

      final exclusiveRevenuesList = revenue
          .map((item) => RevenueModel(
                id: item['id'],
                name: item['name'],
                monthId: item['month_id'],
                value: item['value'],
                isPublic: item['isPublic'],
              ))
          .toList();
      return exclusiveRevenuesList;
    } catch (error) {
      debugPrint('$error');
      return [];
    }
  }

  Future<int> removeRevenue(String revenueId) async {
    updateRemoveRevenueResponse(RemoveRevenueResponse.loading);
    try {
      var result = await Db.deleteRevenue(revenueId);
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
      var result = await Db.updateRevenue(revenue.id!, revenue);
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

  void removeRevenueSelection(){
    RevenueModel unselected = RevenueModel(
      id: '',
      name: '',
      monthId: null,
      value: 0.0,
      isPublic: null,
    );
    emit(state.copyWith(selectedRevenue: unselected));
  }

  Future<void> calculateAvailableValue(int monthId) async {
    try {
      // 1. Obter todas as contas do mês
      final bills = await Db.getBillsByMonth(Tables.bills, monthId);

      final billsList = bills
          .map((item) => BillModel(
                name: item['name'],
                price: item['price'],
                paymentDate: item['payment_date'],
                description: item['description'],
                paymentId: item['payment_id'],
                id: item['id'],
                monthId: item['month_id'],
                categoryId: item['category_id'],
                isPayed: item['isPayed'],
              ))
          .toList();

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
          value: valorDisponivel,
        );
      }).toList(); // usar essa informação para bloquear opções de pagamentos

      // exibição dos valores disponíveis
      debugPrint('Valores Disponíveis: $valoresDisponiveis');

      emit(state.copyWith(availableRevenues: valoresDisponiveis));
    } catch (error) {
      debugPrint('$error');
    }
  }

  void resetState() {
    emit(const RevenueState());
  }
}
