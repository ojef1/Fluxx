class BillModel {
  String? name;
  double? price;
  String? paymentDate;
  String? description;
  String? categoryId;
  String? paymentId;
  String? id;
  int? monthId;
  int? isPayed;

  BillModel({
    this.name,
    this.price,
    this.paymentDate,
    this.description,
    this.categoryId,
    this.paymentId,
    this.id,
    this.monthId,
    this.isPayed,
  });

  BillModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    paymentDate = json['paymentDate'];
    description = json['description'];
    categoryId = json['categoryId'];
    paymentId = json['payment_id'];
    id = json['id'];
    monthId = json['monthId'];
    isPayed = json['isPayed'];
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
}
