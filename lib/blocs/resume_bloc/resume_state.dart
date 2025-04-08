import 'package:equatable/equatable.dart';

enum TotalSpentStatus { initial, loading, success, error }

class ResumeState extends Equatable {
  final String currentMonthName;
  final int currentMonthId;
  final TotalSpentStatus totalSpentStatus;
  final double totalSpent;
  final double percentSpent;
  const ResumeState({
    this.currentMonthName = '',
    this.currentMonthId = 0,
    this.totalSpentStatus = TotalSpentStatus.initial,
    this.totalSpent = 0.0,
    this.percentSpent = 0,
  });

  ResumeState copyWith({
    String? currentMonthName,
    int? currentMonthId,
    TotalSpentStatus? totalSpentStatus,
    double? totalSpent,
    double? percentSpent,
  }) {
    return ResumeState(
      currentMonthName: currentMonthName ?? this.currentMonthName,
      currentMonthId: currentMonthId ?? this.currentMonthId,
      totalSpentStatus: totalSpentStatus ?? this.totalSpentStatus,
      totalSpent: totalSpent ?? this.totalSpent,
      percentSpent: percentSpent ?? this.percentSpent,
    );
  }

  @override
  List<Object?> get props => [
        currentMonthName,
        currentMonthId,
        totalSpentStatus,
        totalSpent,
        percentSpent,

      ];
}
