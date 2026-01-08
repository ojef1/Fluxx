part of 'invoice_bill_form_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

enum InvoiceBillFormMode { adding, editing }

class InvoiceBillFormState extends Equatable {
  final String name;
  final double price;
  final String date;
  final MonthModel? selectedMonth;
  final String desc;
  final CategoryModel? categorySelected;
  final CreditCardModel? cardSelected;
  final bool repeatBill;
  final int repeatCount;
  final ResponseStatus responseStatus;
  final String responseMessage;
  final InvoiceBillFormMode billFormMode;
  final List<CreditCardModel> cardsList;

  const InvoiceBillFormState({
    this.name = '',
    this.price = 0.0,
    this.date = '',
    this.selectedMonth,
    this.desc = '',
    this.categorySelected,
    this.cardSelected,
    this.repeatBill = false,
    this.repeatCount = 2,
    this.responseStatus = ResponseStatus.initial,
    this.responseMessage = '',
    this.billFormMode = InvoiceBillFormMode.adding,
    this.cardsList = const [],
  });

  InvoiceBillFormState copyWith({
    String? id,
    String? name,
    double? price,
    String? date,
    MonthModel? selectedMonth,
    String? desc,
    CategoryModel? categorySelected,
    CreditCardModel? cardSelected,
    bool? repeatBill,
    int? repeatCount,
    String? repeatMonthName,
    ResponseStatus? responseStatus,
    String? responseMessage,
    InvoiceBillFormMode? billFormMode,
    List<MonthModel>? monthsWithoutBalance,
    List<CreditCardModel>? cardsList,
  }) {
    return InvoiceBillFormState(
      name: name ?? this.name,
      price: price ?? this.price,
      date: date ?? this.date,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      desc: desc ?? this.desc,
      categorySelected: categorySelected ?? this.categorySelected,
      cardSelected: cardSelected ?? this.cardSelected,
      repeatBill: repeatBill ?? this.repeatBill,
      repeatCount: repeatCount ?? this.repeatCount,
      responseStatus: responseStatus ?? this.responseStatus,
      responseMessage: responseMessage ?? this.responseMessage,
      billFormMode: billFormMode ?? this.billFormMode,
      cardsList: cardsList ?? this.cardsList,
    );
  }

  @override
  List<Object?> get props => [
        name,
        price,
        date,
        selectedMonth,
        desc,
        categorySelected,
        cardSelected,
        repeatBill,
        repeatCount,
        responseStatus,
        responseMessage,
        billFormMode,
        cardsList,
      ];
}
