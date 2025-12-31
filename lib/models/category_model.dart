import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  String? id;
  String? categoryName;
  double? price;
  int? startMonthId;
  int? endMonthId;
  int? isMonthly;

  CategoryModel({
    this.id,
    this.categoryName,
    this.price,
    this.startMonthId,
    this.endMonthId,
    this.isMonthly,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['name'];
    price = json['price'];
    startMonthId = json['start_month_id'] as int?;
    endMonthId = json['end_month_id'] as int?;
    isMonthly = json['is_monthly'] as int?;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = categoryName;
    data['start_month_id'] = startMonthId;
    data['end_month_id'] = endMonthId;
    data['is_monthly'] = isMonthly;
    return data;
  }

  @override
  String toString() {
    return 'categoryName: $categoryName, id: $id, price: $price, '
        'startMonthId: $startMonthId, endMonthId: $endMonthId, '
        'isMonthly: $isMonthly';
  }

  @override
  List<Object?> get props =>
      [id, categoryName, price, startMonthId, endMonthId, isMonthly];
}
