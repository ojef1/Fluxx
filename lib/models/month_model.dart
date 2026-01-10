class MonthModel {
  int? id;
  int? yearId;
  String? name;
  double? total;
  int? monthNumber;
  String? categoryMostUsed;
  String? revenueMostUsed;

  MonthModel({
    this.id,
    this.yearId,
    this.name,
    this.total,
    this.monthNumber,
    this.categoryMostUsed,
    this.revenueMostUsed,
  });

  MonthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yearId = json['year_id'] ?? json['yearId'];
    name = json['name'];
    total = (json['total_spent'] as num?)?.toDouble();
    monthNumber = json['month_number'];
    categoryMostUsed = json['most_used_category'] as String?;
    revenueMostUsed = json['most_used_revenue'] as String?;
  }

  @override
  String toString() {
    return 'MonthModel{id: $id, yearId: $yearId, name: $name, total: $total, categoryMostUsed: $categoryMostUsed, revenueMostUsed: $revenueMostUsed, monthNumber: $monthNumber}';
  }
}
