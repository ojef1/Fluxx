part of 'bill_form_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

enum BillFormMode { adding, editing }

class BillFormState extends Equatable {
  final String id; // só será preenchida no modo editing
  final String name;
  final double price;
  final String date;
  final MonthModel? selectedMonth;
  final String desc;
  final CategoryModel? categorySelected;
  final RevenueModel? revenueSelected;
  final bool repeatBill;
  final int repeatCount;
  final String repeatMonthName;
  final ResponseStatus responseStatus;
  final String responseMessage;
  final BillFormMode billFormMode;
  final List<MonthModel> monthsWithoutBalance;
  final bool reviewReached; // true após o usuário chegar na tela de revisão
  final bool startOnReview; // true quando o formulário abre direto na revisão

  const BillFormState({
    this.id = '',
    this.name = '',
    this.price = 0.0,
    this.date = '',
    this.selectedMonth,
    this.desc = '',
    this.categorySelected,
    this.revenueSelected,
    this.repeatBill = false,
    this.repeatCount = 0,
    this.repeatMonthName = '',
    this.responseStatus = ResponseStatus.initial,
    this.responseMessage = '',
    this.billFormMode = BillFormMode.adding,
    this.monthsWithoutBalance = const [],
    this.reviewReached = false,
    this.startOnReview = false,
  });

  BillFormState copyWith({
    String? id,
    String? name,
    double? price,
    String? date,
    MonthModel? selectedMonth,
    String? desc,
    CategoryModel? categorySelected,
    RevenueModel? revenueSelected,
    bool? repeatBill,
    int? repeatCount,
    String? repeatMonthName,
    ResponseStatus? responseStatus,
    String? responseMessage,
    BillFormMode? billFormMode,
    List<MonthModel>? monthsWithoutBalance,
    bool? reviewReached,
    bool? startOnReview,
  }) {
    return BillFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      date: date ?? this.date,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      desc: desc ?? this.desc,
      categorySelected: categorySelected ?? this.categorySelected,
      revenueSelected: revenueSelected ?? this.revenueSelected,
      repeatBill: repeatBill ?? this.repeatBill,
      repeatCount: repeatCount ?? this.repeatCount,
      repeatMonthName: repeatMonthName ?? this.repeatMonthName,
      responseStatus: responseStatus ?? this.responseStatus,
      responseMessage: responseMessage ?? this.responseMessage,
      billFormMode: billFormMode ?? this.billFormMode,
      monthsWithoutBalance: monthsWithoutBalance ?? this.monthsWithoutBalance,
      reviewReached: reviewReached ?? this.reviewReached,
      startOnReview: startOnReview ?? this.startOnReview,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        date,
        selectedMonth,
        desc,
        categorySelected,
        revenueSelected,
        repeatBill,
        repeatCount,
        repeatMonthName,
        responseStatus,
        responseMessage,
        billFormMode,
        monthsWithoutBalance,
        reviewReached,
        startOnReview,
      ];
}
