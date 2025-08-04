import 'package:Fluxx/models/month_model.dart';
import 'package:equatable/equatable.dart';

enum GetMonthsResponse{initial, loading, success, error}

class MonthsListState extends Equatable {
  final double monthTotal;
  final List<MonthModel> months;
  final GetMonthsResponse getMonthsResponse;

  const MonthsListState({
    this.monthTotal = 0.0,
    this.months = const <MonthModel>[],
    this.getMonthsResponse = GetMonthsResponse.initial,
  });

  MonthsListState copyWith({
    double? monthTotal,
    List<MonthModel>? months,
    GetMonthsResponse? getMonthsResponse,
  }) {
    return MonthsListState(
      monthTotal: monthTotal ?? this.monthTotal,
      months: months ?? this.months,
      getMonthsResponse: getMonthsResponse ?? this.getMonthsResponse,
    );
  }

  @override
  List<Object?> get props => [
        monthTotal,
        months,
        getMonthsResponse,
      ];
}
