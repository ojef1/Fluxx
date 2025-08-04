import 'package:Fluxx/models/month_model.dart';
import 'package:equatable/equatable.dart';

enum TotalSpentStatus { initial, loading, success, error }

class ResumeState extends Equatable {
  final MonthModel? currentMonth;
  final MonthModel? monthInFocus;
  final TotalSpentStatus totalSpentStatus;
  final double totalSpent;
  final double percentSpent;
  const ResumeState({
    this.currentMonth,
    this.monthInFocus,
    this.totalSpentStatus = TotalSpentStatus.initial,
    this.totalSpent = 0.0,
    this.percentSpent = 0,
  });

  ResumeState copyWith({
    MonthModel? currentMonth,
    MonthModel? monthInFocus,
    TotalSpentStatus? totalSpentStatus,
    double? totalSpent,
    double? percentSpent,
  }) {
    return ResumeState(
      currentMonth: currentMonth ?? this.currentMonth,
      monthInFocus: monthInFocus ?? this.monthInFocus,
      totalSpentStatus: totalSpentStatus ?? this.totalSpentStatus,
      totalSpent: totalSpent ?? this.totalSpent,
      percentSpent: percentSpent ?? this.percentSpent,
    );
  }

  @override
  List<Object?> get props => [
        currentMonth,
        monthInFocus,
        totalSpentStatus,
        totalSpent,
        percentSpent,
      ];
}
