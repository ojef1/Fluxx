import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/models/year_model.dart';
import 'package:equatable/equatable.dart';

enum GetMonthsResponse{initial, loading, success, error}

class MonthsListState extends Equatable {
  final double monthTotal;
  final List<MonthModel> months;
  final List<YearModel>years;
  final int? yearInFocus;
  final GetMonthsResponse getMonthsResponse;

  const MonthsListState({
    this.monthTotal = 0.0,
    this.months = const <MonthModel>[],
    this.years = const <YearModel>[],
    this.yearInFocus,
    this.getMonthsResponse = GetMonthsResponse.initial,
  });

  MonthsListState copyWith({
    double? monthTotal,
    List<MonthModel>? months,
    List<YearModel>? years,
    int? yearInFocus,
    GetMonthsResponse? getMonthsResponse,
  }) {
    return MonthsListState(
      monthTotal: monthTotal ?? this.monthTotal,
      months: months ?? this.months,
      years: years ?? this.years,
      yearInFocus: yearInFocus ?? this.yearInFocus,
      getMonthsResponse: getMonthsResponse ?? this.getMonthsResponse,
    );
  }

  @override
  List<Object?> get props => [
        monthTotal,
        months,
        years,
        yearInFocus,
        getMonthsResponse,
      ];
}
