import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'revenue_form_state.dart';

class RevenueFormCubit extends Cubit<RevenueFormState> {
  RevenueFormCubit() : super(const RevenueFormState());

  //variável necessária para pegar os dados que não são alterados na edição
  //como Id, recurrence e etc.
  RevenueModel? _loadedRevenueToEdit;

  bool get canDesactive =>
      _loadedRevenueToEdit?.isActive == 1 &&
      _loadedRevenueToEdit?.isPublic == 1 &&
      state.revenueFormMode == RevenueFormMode.editing;

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updatePrice(double price) {
    emit(state.copyWith(price: price));
  }

  void updateRevenueFormMode(RevenueFormMode revenueFormMode) {
    emit(state.copyWith(revenueFormMode: revenueFormMode));
  }

  void updateRecurrenceMode(RecurrenceMode recurrenceMode) {
    emit(state.copyWith(recurrenceMode: recurrenceMode));
  }

  void updateResponseStatus(ResponseStatus responseStatus) {
    emit(state.copyWith(responseStatus: responseStatus));
  }

  Future<void> updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }

  Future<void> submitRevenue(int currentMonthId) async {
    switch (state.revenueFormMode) {
      case RevenueFormMode.adding:
        await _addNewRevenue(currentMonthId);
      case RevenueFormMode.editing:
        await _editRevenue();
    }
  }

  Future<void> _addNewRevenue(int currentMonthId) async {
    updateResponseStatus(ResponseStatus.loading);
    bool isMonthly = state.recurrenceMode == RecurrenceMode.monthly;
    try {
      RevenueModel newRevenue = RevenueModel(
        id: codeGenerate(),
        name: state.name,
        value: state.price,
        startMonthId: currentMonthId,
        endMonthId: isMonthly ? null : currentMonthId,
        isPublic: isMonthly ? 1 : 0, // 1 para true e 0 para false
      );

      var result = await Db.insertRevenue(newRevenue);
      if (result != -1) {
        await updateResponseMessage('receita adicionada com sucesso.');
        updateResponseStatus(ResponseStatus.success);
        return;
      } else {
        await updateResponseMessage('Falha ao adicionar a receita.');
        updateResponseStatus(ResponseStatus.error);
        return;
      }
    } catch (error) {
      log('$error', name: 'RevenueFormCubit._addNewRevenue');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  Future<void> _editRevenue() async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      var updatedRevenue = RevenueModel(
        id: state.id,
        name: state.name,
        value: state.price,
        startMonthId: _loadedRevenueToEdit?.startMonthId,
        endMonthId: _loadedRevenueToEdit?.endMonthId,
        isPublic:
            _loadedRevenueToEdit?.isPublic ?? 0, // 1 para true e 0 para false
      );

      var result = await Db.updateRevenue(updatedRevenue);
      if (result > 0) {
        await updateResponseMessage('receita editada com sucesso.');
        updateResponseStatus(ResponseStatus.success);
        return;
      } else {
        await updateResponseMessage('Falha ao editar a receita.');
        updateResponseStatus(ResponseStatus.error);
        return;
      }
    } catch (error) {
      log('$error', name: 'RevenueFormCubit._editRevenue');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  Future<void> desactiveRevenue(int currentMonthId) async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      var result = await Db.deactivateRevenue(state.id, currentMonthId);
      if (result > 0) {
        await updateResponseMessage('Receita desativada com sucesso.');
        updateResponseStatus(ResponseStatus.success);
        return;
      } else {
        await updateResponseMessage('Falha ao desativar a receita.');
        updateResponseStatus(ResponseStatus.error);
        return;
      }
    } catch (error) {
      log('$error', name: 'RevenueFormCubit.desactiveRevenue');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  void loadRevenueToEdit(RevenueModel revenue) {
    _loadedRevenueToEdit = revenue;
    emit(state.copyWith(
      id: revenue.id,
      name: revenue.name,
      price: revenue.value,
    ));
  }

  resetState() {
    emit(const RevenueFormState());
  }
}
