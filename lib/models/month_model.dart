class MonthModel {
  int? id;
  String? name;
  double? total;
  String? categoryMostUsed; 
  String? revenueMostUsed; 

  MonthModel({
    this.id,
    this.name,
    this.total,
    this.categoryMostUsed,
    this.revenueMostUsed,
  });

  MonthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    total = json['total'];
    categoryMostUsed = json['categoryMostUsed'];
    revenueMostUsed = json['revenueMostUsed'];
  }

  @override
  String toString() {
    return 'MonthModel{id: $id, name: $name, total: $total, categoryMostUsed: $categoryMostUsed, revenueMostUsed: $revenueMostUsed}';
  }
}
