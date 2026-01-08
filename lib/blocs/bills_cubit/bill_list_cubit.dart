
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bill_list_state.dart';

class BillListCubit extends Cubit<ListBillState> {
  BillListCubit() : super(const ListBillState());


  void _updateResponseStatus(ResponseStatus status) {
    emit(state.copyWith(status: status));
  }  

  Future<void> _updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }  

  Future<void> getAllBills(int monthId) async {
    _updateResponseStatus(ResponseStatus.loading);
    try {
      final bills = await Db.getBillsByMonth(monthId);

      final billsList = bills.map((item) => BillModel.fromJson(item)).toList();
      emit(state.copyWith(bills: billsList));
      _updateResponseStatus(ResponseStatus.success);
    } catch (error) {
      debugPrint('$error');
      _updateResponseStatus(ResponseStatus.error);
      emit(state.copyWith(bills: []));
    }
  }

  void resetState() {
    emit(const ListBillState());
  }
}
