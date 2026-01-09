import 'dart:developer';
import 'dart:math' as math;

import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:Fluxx/services/credit_card_services.dart' as service;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'credit_card_info_state.dart';

class CreditCardInfoCubit extends Cubit<CreditCardInfoState> {
  CreditCardInfoCubit() : super(const CreditCardInfoState());

  void loadIdToGet(String id) {
    emit(state.copyWith(idToGet: id));
  }

  Future<void> init(int monthId) async {
    _updateResponseStatus(ResponseStatus.loading);
    try {
      await getCreditCardById(state.idToGet);
      final currentInvoice = await service.getInvoice(
        card: state.card!,
        referenceDate: DateTime.now(),
      );
      emit(state.copyWith(invoice: currentInvoice));
      await _calcRecommendedSpendig(monthId);
      await _calcRevenueImpairment(monthId);
      await getInvoiceBillsLength(currentInvoice?.id ?? '');

      _updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      log('$e');
      _updateResponseStatus(ResponseStatus.error);
    }
  }

  Future<void> getInvoiceBillsLength(String invoiceId) async {
    try {
      final length = await service.getInvoiceBillsLength(invoiceId);

      emit(state.copyWith(invoiceBillsLength: length));
    } catch (e) {
      log('$e');
    }
  }

  Future<void> _calcRecommendedSpendig(int monthId) async {
    final double totalSpentInMonth = await Db.sumPricesByMonth(monthId);
    final double cardLimit = state.card?.creditLimit ?? 0.0;
    //max para garantir que o recommendedSpending não seja negativo
    final double recommendedSpending =
        math.max(0.0, cardLimit - totalSpentInMonth);
    emit(state.copyWith(recommendedSpending: recommendedSpending));
  }

  Future<void> _calcRevenueImpairment(int monthId) async {
    final double totalRevenues = await service.calcTotalRevenues(monthId);
    final double totalInvoice = state.invoice?.price ?? 0.0;

    double impairmentPercent = 0.0;

    if (totalRevenues > 0) {
      impairmentPercent = ((totalInvoice / totalRevenues) * 100);
    }

    emit(state.copyWith(
      revenueImpairment: impairmentPercent,
    ));
  }

  Future<void> getCreditCardById(String id) async {
    try {
      var card = await service.getCreditCardById(id);
      if (card != null) {
        emit(state.copyWith(card: card));
        _updateResponseMessage('');
      } else {
        _updateResponseMessage('Erro ao pegar os detalhes');
        _updateResponseStatus(ResponseStatus.error);
      }
    } catch (e) {
      log('$e', name: 'deleteCreditCard');
      _updateResponseMessage('Erro ao achar o cartão');
      rethrow;
    }
  }

  void _updateResponseStatus(ResponseStatus status) {
    emit(state.copyWith(status: status));
  }

  Future<void> _updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }

  Future<int> disableCreditCard(String id) async {
    _updateResponseStatus(ResponseStatus.loading);
    try {
      var result = await Db.disableCreditCard(id);
      if (result > 0) {
        _updateResponseMessage('Cartão removido com sucesso!');
        _updateResponseStatus(ResponseStatus.success);
        return result;
      } else {
        _updateResponseMessage('Erro ao remover o cartão');
        _updateResponseStatus(ResponseStatus.error);
        return result;
      }
    } catch (e) {
      log('$e', name: 'disableCreditCard');
      _updateResponseMessage('Erro ao remover o cartão');
      _updateResponseStatus(ResponseStatus.error);
      return 0;
    }
  }

  resetState() {
    emit(const CreditCardInfoState());
  }
}
