class RevenueModel {
  String? id;
  String? name;
  double? value;
  int? startMonthId;
  int? endMonthId;
  int isActive;
  int? isPublic;

  RevenueModel({
    this.id,
    this.name,
    this.value,
    this.startMonthId,
    this.endMonthId,
    this.isPublic,
    this.isActive = 1, // por padrão ativa
  });

  RevenueModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        value = (json['value'] as num?)?.toDouble(),
        startMonthId = json['start_month_id'] as int?,
        endMonthId = json['end_month_id'] as int?,
        isPublic = json['isPublic'] as int?,
        isActive = (json['is_active'] as int?) ?? 1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'start_month_id': startMonthId,
      'end_month_id': endMonthId,
      'isPublic': isPublic,
      'is_active': isActive,
    };
  }

  @override
  String toString() {
    return 'RevenueModel{id: $id, name: $name, value: $value, '
        'startMonthId: $startMonthId, endMonthId: $endMonthId, '
        'isPublic: $isPublic, isActive: $isActive}';
  }
}
