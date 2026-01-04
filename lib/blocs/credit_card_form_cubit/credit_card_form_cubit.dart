import 'dart:developer';

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'credit_card_form_state.dart';

class CreditCardFormCubit extends Cubit<CreditCardFormState> {
  CreditCardFormCubit() : super(const CreditCardFormState());

  //variável necessária para pegar os dados que não são alterados na edição
  CreditCardModel? _loadedCreditCardToEdit;

  updateName(String name) {
    emit(state.copyWith(name: name));
  }

  updateCreditLimit(double creditLimit) {
    emit(state.copyWith(creditLimit: creditLimit));
  }

  updateBankId(int bankId) {
    emit(state.copyWith(bankId: bankId));
  }

  updateNetworkId(int networkId) {
    emit(state.copyWith(networkId: networkId));
  }

  updateLastFourDigits(String lastFourDigits) {
    emit(state.copyWith(lastFourDigits: lastFourDigits));
  }

  updateClosingDay(DateTime closingDay) {
    emit(state.copyWith(closingDay: closingDay));
  }

  updateDueDay(DateTime dueDay) {
    emit(state.copyWith(dueDay: dueDay));
  }

  void updateResponseStatus(ResponseStatus responseStatus) {
    emit(state.copyWith(responseStatus: responseStatus));
  }

  Future<void> updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }

  void updateFormMode(CreditCardFormMode creditCardFormMode) {
    emit(state.copyWith(creditCardFormMode: creditCardFormMode));
  }

  Future<void> submitCard() async {
    switch (state.creditCardFormMode) {
      case CreditCardFormMode.adding:
        await _addNewCard();
      case CreditCardFormMode.editing:
        await _editCard();
    }
  }

  Future<void> _addNewCard() async{
    updateResponseStatus(ResponseStatus.loading);
    try{
    CreditCardModel newCard = CreditCardModel(
      id: codeGenerate(),
      name: state.name,
      creditLimit: state.creditLimit,
      closingDay: state.closingDay!.day,
      dueDay: state.dueDay!.day,
      bankId: state.bankId,
      networkId: state.networkId,
      lastFourDigits: state.lastFourDigits,
    );

      await Db.insertCreditCard(newCard);
      log('cartão inserido : $newCard');
      await updateResponseMessage('Cartão adicionado com sucesso!');
      updateResponseStatus(ResponseStatus.success);
    }catch (e) {
      log(e.toString());
      await updateResponseMessage(
          'Erro ao adicionar o Cartão: ${e.toString()}');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  Future<void> _editCard()async{    
    updateResponseStatus(ResponseStatus.loading);
    try{
      CreditCardModel editedCard = CreditCardModel(
      id: _loadedCreditCardToEdit!.id,
      name: state.name,
      creditLimit: state.creditLimit,
      closingDay: state.closingDay!.day,
      dueDay: state.dueDay!.day,
      bankId: state.bankId,
      networkId: state.networkId,
      lastFourDigits: state.lastFourDigits,
    );
     await Db.updateCreditCard(editedCard);
      await updateResponseMessage('Cartão editada com sucesso!');
      updateResponseStatus(ResponseStatus.success);
    }catch(e){
      log(e.toString());
      await updateResponseMessage(
          'Erro ao adicionar o Cartão: ${e.toString()}');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  void loadedCreditCardToEdit(CreditCardModel creditCard) {
    _loadedCreditCardToEdit = creditCard;
    var currentDate = DateTime.now();
    var closingDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      creditCard.closingDay!,
    );
    var dueDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      creditCard.dueDay!,
    );
    emit(state.copyWith(
      name: creditCard.name,
      creditLimit: creditCard.creditLimit,
      bankId: creditCard.bankId,
      networkId: creditCard.networkId,
      lastFourDigits: creditCard.lastFourDigits,
      closingDay: closingDateTime,
      dueDay: dueDateTime,
      creditCardFormMode: CreditCardFormMode.editing,
    ));
  }

  resetState() {
    emit(const CreditCardFormState());
  }
}
