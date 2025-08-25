class MonthModel {
  int? id;
  int? yearId;
  String? name;
  double? total;
  String? categoryMostUsed; 
  String? revenueMostUsed; 

  MonthModel({
    this.id,
    this.yearId,
    this.name,
    this.total,
    this.categoryMostUsed,
    this.revenueMostUsed,
  });

  MonthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yearId = json['year_id'] ?? json['yearId'];
    name = json['name'];
    total = json['total'];
    categoryMostUsed = json['categoryMostUsed'];
    revenueMostUsed = json['revenueMostUsed'];
  }

  @override
  String toString() {
    return 'MonthModel{id: $id, yearId: $yearId, name: $name, total: $total, categoryMostUsed: $categoryMostUsed, revenueMostUsed: $revenueMostUsed}';
  }
}
