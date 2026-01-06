import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'credit_card_list_state.dart';

class CreditCardListCubit extends Cubit<CreditCardListState> {
  CreditCardListCubit() : super(const CreditCardListState());

  Future<void> getCardsList() async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      var result = await Db.getCreditCards();
      final cardsList =
          result.map((item) => CreditCardModel.fromJson(item)).toList();
      log('lista de cartões : $cardsList');
      emit(state.copyWith(cardList: cardsList));
      updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      log('Erro ao buscar os cartões : $e', name: 'getCardsList');
      updateResponseMessage('Erro ao buscar os cartões');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  updateResponseStatus(ResponseStatus status) {
    emit(state.copyWith(status: status));
  }

  updateResponseMessage(String responseMessage) {
    emit(state.copyWith(responseMessage: responseMessage));
  }
}
