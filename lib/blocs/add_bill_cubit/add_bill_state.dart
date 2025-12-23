part of 'add_bill_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

class AddBillState extends Equatable {
  final String name;
  final double price;
  final String date;
  final String desc;
  final CategoryModel? categorySelected;
  final RevenueModel? revenueSelected;
  final bool repeatBill;
  final int repeatCount;
  final String repeatMonthName;
  final ResponseStatus responseStatus;
  final String responseMessage;

  const AddBillState({
    this.name = '',
    this.price = 0.0,
    this.date = '',
    this.desc = '',
    this.categorySelected,
    this.revenueSelected,
    this.repeatBill = false,
    this.repeatCount = 0,
    this.repeatMonthName = '',
    this.responseStatus = ResponseStatus.initial,
    this.responseMessage = '',
  });

  AddBillState copyWith({
    String? name,
    double? price,
    String? date,
    String? desc,
    CategoryModel? categorySelected,
    RevenueModel? revenueSelected,
    bool? repeatBill,
    int? repeatCount,
    String? repeatMonthName,
    ResponseStatus? responseStatus,
    String? responseMessage,
  }) {
    return AddBillState(
      name: name ?? this.name,
      price: price ?? this.price,
      date: date ?? this.date,
      desc: desc ?? this.desc,
      categorySelected: categorySelected ?? this.categorySelected,
      revenueSelected: revenueSelected ?? this.revenueSelected,
      repeatBill: repeatBill ?? this.repeatBill,
      repeatCount: repeatCount ?? this.repeatCount,
      repeatMonthName: repeatMonthName ?? this.repeatMonthName,
      responseStatus: responseStatus ?? this.responseStatus,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        price,
        date,
        desc,
        categorySelected,
        revenueSelected,
        repeatBill,
        repeatCount,
        repeatMonthName,
        responseStatus,
        responseMessage,
      ];
}
