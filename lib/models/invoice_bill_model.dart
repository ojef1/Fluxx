class InvoiceBillModel {
  String? id;
  String? creditCardId;
  String? invoiceId;
  String? categoryId;
  int? installmentNumber;
  int? installmentTotal;
  String? installmentGroupId;
  String? name;
  String? description;
  double? price;
  String? date;

  //extra
  String? categoryName;

  InvoiceBillModel({
    this.id,
    this.creditCardId,
    this.invoiceId,
    this.categoryId,
    this.installmentNumber,
    this.installmentTotal,
    this.installmentGroupId,
    this.name,
    this.description,
    this.price,
    this.date,
    this.categoryName,
  });

  InvoiceBillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creditCardId = json['credit_card_id'];
    invoiceId = json['invoice_id'];
    categoryId = json['category_id'];
    installmentNumber = json['installment_number'];
    installmentTotal = json['installment_total'];
    installmentGroupId = json['installment_group_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    date = json['date'];
    categoryName = json['category_name'] ?? 'Sem categoria';
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['credit_card_id'] = creditCardId;
    data['invoice_id'] = invoiceId;
    data['category_id'] = categoryId;
    data['installment_number'] = installmentNumber;
    data['installment_total'] = installmentTotal;
    data['installment_group_id'] = installmentGroupId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['date'] = date;
    return data;
  }

  @override
  String toString(){
    return '';
  }
}
