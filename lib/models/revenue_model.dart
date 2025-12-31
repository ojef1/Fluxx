import 'package:equatable/equatable.dart';

class RevenueModel extends Equatable {
  String? id;
  String? name;
  double? value;
  int? startMonthId;
  int? endMonthId;
  int? isMonthly;

  RevenueModel({
    this.id,
    this.name,
    this.value,
    this.startMonthId,
    this.endMonthId,
    this.isMonthly,
  });

  RevenueModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        value = (json['value'] as num?)?.toDouble(),
        startMonthId = json['start_month_id'] as int?,
        endMonthId = json['end_month_id'] as int?,
        isMonthly = json['is_monthly'] as int?;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'start_month_id': startMonthId,
      'end_month_id': endMonthId,
      'is_monthly': isMonthly,
    };
  }

  @override
  String toString() {
    return 'RevenueModel{id: $id, name: $name, value: $value, '
        'startMonthId: $startMonthId, endMonthId: $endMonthId, '
        'isMonthly: $isMonthly';
  }

  @override
  List<Object?> get props =>
      [id, name, value, startMonthId, endMonthId, isMonthly];
}
