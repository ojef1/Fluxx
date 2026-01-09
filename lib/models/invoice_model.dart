import 'package:equatable/equatable.dart';

class InvoiceModel extends Equatable {
  String? id;
  String? creditCardId;
  String? categoryId;
  String? paymentId;
  int? monthId;
  String? dueDate;
  String? startDate;
  String? endDate;
  double? price;
  int? isPaid;

  //extra
  int? invoiceBillsLength;

  InvoiceModel(
      {this.id,
      this.creditCardId,
      this.categoryId,
      this.paymentId,
      this.monthId,
      this.dueDate,
      this.startDate,
      this.endDate,
      this.price,
      this.isPaid,
      this.invoiceBillsLength});

  InvoiceModel copyWith({
    int? invoiceBillsLength,
  }) {
    return InvoiceModel(
      id: id,
      creditCardId: creditCardId,
      categoryId: categoryId,
      paymentId: paymentId,
      monthId: monthId,
      dueDate: dueDate,
      startDate: startDate,
      endDate: endDate,
      price: price,
      isPaid: isPaid,
      invoiceBillsLength: invoiceBillsLength ?? this.invoiceBillsLength,
    );
  }

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creditCardId = json['credit_card_id'];
    categoryId = json['category_id'];
    paymentId = json['payment_id'];
    monthId = json['month_id'];
    dueDate = json['due_date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    price = json['price'];
    isPaid = json['is_paid'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['credit_card_id'] = creditCardId;
    data['category_id'] = categoryId;
    data['payment_id'] = paymentId;
    data['month_id'] = monthId;
    data['due_date'] = dueDate;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['price'] = price;
    data['is_paid'] = isPaid;
    return data;
  }

  @override
  String toString() {
    return 'InvoiceModel{id: $id, creditCardId: $creditCardId, categoryId: $categoryId, paymentId: $paymentId, monthId: $monthId, dueDate : $dueDate, startDate: $startDate, endDate: $endDate, price: $price, isPaid: $isPaid, invoiceBillsLength: $invoiceBillsLength}';
  }

  @override
  List<Object?> get props => [
    id,
        creditCardId,
        categoryId,
        paymentId,
        monthId,
        dueDate,
        startDate,
        endDate,
        price,
        isPaid,
        invoiceBillsLength,
      ];
}
