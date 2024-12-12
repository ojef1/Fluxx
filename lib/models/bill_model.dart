class BillModel {
  String? id;
  int? monthId;
  int? categoryId;
  String? name;
  double? price;
  int? isPayed;

  BillModel(
      {this.id,
      this.name,
      this.monthId,
      this.categoryId,
      this.price,
      this.isPayed});

  BillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    monthId = json['monthId'];
    categoryId = json['categoryId'];
    price = json['price'];
    isPayed = json['isPayed'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['month_id'] = monthId;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['price'] = price;
    data['isPayed'] = isPayed;
    return data;
  }
}
