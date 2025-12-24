import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'bill_form_state.dart';

class BillFormCubit extends Cubit<BillFormState> {
  BillFormCubit() : super(const BillFormState());

  //variável necessária para pegar os dados que não são alterados na edição
  //como monthId, isPayed e etc.
  BillModel? _loadedBillToEdit;

  updateName(String name) {
    emit(state.copyWith(name: name));
  }

  updatePrice(double price) {
    emit(state.copyWith(price: price));
  }

  updateDate(String date) {
    emit(state.copyWith(date: date));
  }

  updateDesc(String desc) {
    emit(state.copyWith(desc: desc));
  }

  updateRevenue(RevenueModel revenueSelected) {
    emit(state.copyWith(revenueSelected: revenueSelected));
  }

  updateCategory(CategoryModel categorySelected) {
    emit(state.copyWith(categorySelected: categorySelected));
  }

  updateRepeatBill(bool repeatBill) {
    emit(state.copyWith(repeatBill: repeatBill));
  }

  updateRepeatCount(int repeatCount) {
    emit(state.copyWith(repeatCount: repeatCount));
  }

  updateRepeatMonthName(String repeatMonthName) {
    emit(state.copyWith(repeatMonthName: repeatMonthName));
  }

  resetState() {
    emit(const BillFormState());
  }

  Future<void> submitBill(int currentMonthId) async {
    switch (state.billFormMode) {
      case BillFormMode.adding:
        await _addNewBill(currentMonthId);
      case BillFormMode.editing:
        await _editBill();
    }
  }

  Future<void> _addNewBill(int currentMonthId) async {
    updateResponseStatus(ResponseStatus.loading);

    try {
      if (state.repeatBill) {
        await _addMultipleBills(currentMonthId);
      } else {
        await _addSingleBill(currentMonthId);
      }

      updateResponseMessage('Conta adicionada com sucesso.');
      updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      debugPrint('$e');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  Future<void> _addMultipleBills(int currentMonthId) async {
    final repeatTimes = state.repeatCount;

    for (int i = 0; i <= repeatTimes; i++) {
      final monthId = currentMonthId + i;
      await _addSingleBill(monthId);
    }
  }

  Future<void> _addSingleBill(int currentMonthId) async {
    var newBill = BillModel(
      id: codeGenerate(),
      name: state.name,
      price: state.price,
      paymentDate: state.date,
      description: state.desc,
      monthId: currentMonthId,
      categoryId: state.categorySelected!.id,
      paymentId: state.revenueSelected!.id,
      isPayed: 0,
    );
    final result = await Db.insertBill(Tables.bills, newBill);

    if (result == -1) {
      throw Exception('Erro ao inserir conta');
    }
  }

  Future<void> _editBill() async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      var newBill = BillModel(
        id: state.id,
        name: state.name,
        price: state.price,
        paymentDate: state.date,
        description: state.desc,
        monthId: _loadedBillToEdit?.monthId,
        categoryId: state.categorySelected!.id,
        paymentId: state.revenueSelected!.id,
        isPayed: _loadedBillToEdit?.isPayed,
      );

      final result = await Db.updateBill(Tables.bills, state.id, newBill);

      if (result == -1) {
        log('deu erro ', name : 'editBill');
        updateResponseMessage('Erro ao atualizar conta');
        updateResponseStatus(ResponseStatus.error);
      }
      updateResponseMessage('Conta editada com sucesso.');
      updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      debugPrint('$e');
      log('deu erro $e ');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  bool revenueExistsInMonth(RevenueModel revenue, int targetMonthId) {
    final endMonth =
        revenue.endMonthId ?? 12; // se não tem fim, considera dezembro
    return targetMonthId >= revenue.startMonthId! && targetMonthId <= endMonth;
  }

  void updateResponseStatus(ResponseStatus responseStatus) {
    emit(state.copyWith(responseStatus: responseStatus));
  }

  Future<void> updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }

  void updateFormMode(BillFormMode billFormMode) {
    emit(state.copyWith(billFormMode: billFormMode));
  }

  void loadBillToEdit(BillModel bill) {
    var category =
        CategoryModel(id: bill.categoryId, categoryName: bill.categoryName);
    var revenue =
        RevenueModel(id: bill.paymentId, name: bill.paymentName, value: 0.0);
    emit(state.copyWith(
      id: bill.id,
      name: bill.name,
      price: bill.price,
      date: bill.paymentDate,
      desc: bill.description,
      categorySelected: category,
      revenueSelected: revenue,
    ));

    _loadedBillToEdit = bill;
  }
}
