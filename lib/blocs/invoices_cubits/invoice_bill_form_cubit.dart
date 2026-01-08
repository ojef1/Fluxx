import 'dart:developer';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/models/invoice_bill_model.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/services/bill_services.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'invoice_bill_form_state.dart';

class InvoiceBillFormCubit extends Cubit<InvoiceBillFormState> {
  InvoiceBillFormCubit() : super(const InvoiceBillFormState());

  //variável necessária para pegar os dados que não são alterados na edição
  //como monthId, id e etc.
  InvoiceBillModel? _loadedBillToEdit;

  Future<void> updateSelectedMonth(DateTime date) async {
    try {
      MonthModel? selectedMonth = await getMonthIdFromDate(date);
      emit(state.copyWith(selectedMonth: selectedMonth));
    } catch (e) {
      log('Não possível atualizar o mês selecionado');
    }
  }

  Future<void> getCards() async {
    // _updateResponseStatus(ResponseStatus.loading);
    try {
      List<CreditCardModel> cards = await getCardsList();
      List<CreditCardModel> cardsWithAvailableLimit = [];
      if (cards.isNotEmpty) {
        for (var card in cards) {
          double availableLimit =
              await getCreditCardAvailableLimite(card: card);
          CreditCardModel newCard = CreditCardModel(
            id: card.id,
            bankId: card.bankId,
            networkId: card.networkId,
            name: card.name,
            closingDay: card.closingDay,
            dueDay: card.dueDay,
            lastFourDigits: card.lastFourDigits,
            creditLimit: availableLimit,
          );

          cardsWithAvailableLimit.add(newCard);
        }
      }
      emit(state.copyWith(cardsList: cardsWithAvailableLimit));
      // _updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      log('Erro ao buscar os cartões : $e', name: 'getCardsList');
      // _updateResponseStatus(ResponseStatus.error);
    }
  }

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

  updateCategory(CategoryModel categorySelected) {
    emit(state.copyWith(categorySelected: categorySelected));
  }

  updateCard(CreditCardModel cardSelected) {
    emit(state.copyWith(cardSelected: cardSelected));
  }

  updateRepeatCount(int repeatCount) {
    //O mínimo de parcelas tem que ser 2, caso contrário é a vista
    if (repeatCount < 2) return;
    emit(state.copyWith(repeatCount: repeatCount));
  }

  updateRepeatBill(bool repeatBill) {
    emit(state.copyWith(repeatBill: repeatBill));
  }

  void _updateResponseStatus(ResponseStatus responseStatus) {
    emit(state.copyWith(responseStatus: responseStatus));
  }

  Future<void> _updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }

  void updateFormMode(InvoiceBillFormMode billFormMode) {
    emit(state.copyWith(billFormMode: billFormMode));
  }

  Future<void> submitBill() async {
    switch (state.billFormMode) {
      case InvoiceBillFormMode.adding:
        await _addNewInvoiceBill();
      case InvoiceBillFormMode.editing:
        await _editInvoiceBill();
    }
  }

  Future<void> _addNewInvoiceBill() async {
    _updateResponseStatus(ResponseStatus.loading);
    try {
      if (state.repeatBill) {
        await _addMultipleBills();
      } else {
        await _addSingleBill();
      }

      _updateResponseMessage('Compra adicionada com sucesso');
      _updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      log('$e');
      _updateResponseMessage('Não foi possível adcionar a compra');
      _updateResponseStatus(ResponseStatus.error);
    }
  }

  Future<void> _addMultipleBills() async {}
  Future<void> _addSingleBill() async {
    try {
      final DateTime date = DateTime.parse(state.date);
      final invoice =
          await getInvoice(card: state.cardSelected!, referenceDate: date);
      if (invoice == null) {
        throw Exception('Não foi possível obter a fatura do cartão');
      }
      String newId = codeGenerate();
      InvoiceBillModel newInvoiceBill = InvoiceBillModel(
        id: newId,
        creditCardId: state.cardSelected!.id!,
        categoryId: state.categorySelected!.id,
        date: state.date,
        invoiceId: invoice.id!,
        name: state.name,
        price: state.price,
        installmentNumber: 1,
        installmentTotal: 1,
        installmentGroupId: newId,
      );

      final result = await Db.insertInvoiceBill(newInvoiceBill);
      if (result == -1) {
        throw Exception('Erro ao inserir conta');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _editInvoiceBill() async {}

  void loadBillToEdit(InvoiceBillModel bill) {
    var category =
        CategoryModel(id: bill.categoryId, categoryName: bill.categoryName);

    emit(state.copyWith(
      id: bill.id,
      name: bill.name,
      price: bill.price,
      date: bill.date,
      desc: bill.description,
      categorySelected: category,
    ));

    _loadedBillToEdit = bill;
  }

  resetState() {
    emit(const InvoiceBillFormState());
  }
}
