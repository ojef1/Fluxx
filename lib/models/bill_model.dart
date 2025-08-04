class BillModel {
  String? id;
  int? monthId;
  String? name;
  String? description;
  double? price;
  String? categoryId;
  String? paymentDate;
  String? paymentId;
  int? isPayed;

  //extras
  String? categoryName;
  String? paymentName;

  BillModel({
    this.id,
    this.monthId,
    this.price,
    this.name,
    this.description,
    this.categoryId,
    this.paymentDate,
    this.paymentId,
    this.isPayed,
    this.categoryName,
    this.paymentName,
  });

  BillModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    paymentDate = json['paymentDate'];
    description = json['description'];
    categoryId = json['category_id'];
    paymentId = json['payment_id'];
    id = json['id'];
    monthId = json['month_id'];
    isPayed = json['isPayed'];
    categoryName = json['category_name'] ?? 'Sem categoria';
    paymentName = json['payment_name'] ?? 'Não especificado';
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['paymentDate'] = paymentDate;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['payment_id'] = paymentId;
    data['id'] = id;
    data['month_id'] = monthId;
    data['isPayed'] = isPayed;
    return data;
  }

  @override
  String toString() {
    return 'BillModel{id: $id, name: $name, price: $price, paymentDate: $paymentDate, description: $description, categoryId: $categoryId, paymentId: $paymentId, isPayed: $isPayed, categoryName: $categoryName, payment Name: $paymentName}';
  }
}
