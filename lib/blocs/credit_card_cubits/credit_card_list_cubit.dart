import 'dart:developer';

import 'package:Fluxx/models/credit_card_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Fluxx/services/credit_card_services.dart' as service;

part 'credit_card_list_state.dart';

class CreditCardListCubit extends Cubit<CreditCardListState> {
  CreditCardListCubit() : super(const CreditCardListState());

  Future<void> getCardsList() async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      final cardsList = await service.getCardsList();
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
