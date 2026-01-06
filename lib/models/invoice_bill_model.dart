class InvoiceBillModel {
  String? id;
  String? creditCardId;
  String? invoiceId;
  String? categoryId;
  String? name;
  String? description;
  double? price;
  String? date;

  InvoiceBillModel({
    this.id,
    this.creditCardId,
    this.invoiceId,
    this.categoryId,
    this.name,
    this.description,
    this.price,
    this.date,
  });

  InvoiceBillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creditCardId = json['credit_card_id'];
    invoiceId = json['invoice_id'];
    categoryId = json['category_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['credit_card_id'] = creditCardId;
    data['invoice_id'] = invoiceId;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['date'] = date;
    return data;
  }

  //continuar fluxo de vida da conta da fatura
  //criar tela da lista de faturas
  //criar tela da lista de contas da fatura

  @override
  String toString(){
    return '';
  }
}
