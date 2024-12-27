import 'package:Fluxx/blocs/revenue_bloc/revenue_state.dart';
import 'package:Fluxx/data/database.dart';
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

  void resetState() {
    emit(const RevenueState());
  }
}
