class MonthModel {
  int? id;
  String? name;
  double? total;

  MonthModel({
    this.id,
    this.name,
    this.total,
  });

  MonthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    total = json['total'];
  }
}
