import 'package:equatable/equatable.dart';

class ResumeState extends Equatable {
  final String currentMonthName;
  final int currentMonthId;
  const ResumeState({
    this.currentMonthName = '',
    this.currentMonthId = 0,
  });

  ResumeState copyWith({
    String? currentMonthName,
    int? currentMonthId,
  }) {
    return ResumeState(
      currentMonthName: currentMonthName ?? this.currentMonthName,
      currentMonthId: currentMonthId ?? this.currentMonthId,
    );
  }

  @override
  List<Object?> get props => [currentMonthName,currentMonthId];
}
