import 'package:Fluxx/blocs/months_list_bloc/months_list_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/year_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthsListCubit extends Cubit<MonthsListState> {
  MonthsListCubit() : super(const MonthsListState());

  void init() async {
    await getYears();
    final currentYear = DateTime.now().year;
    changeYear(currentYear);
  }

  void changeYear(int year) {
    emit(state.copyWith(
      yearInFocus: year,
      getMonthsResponse: GetMonthsResponse.loading,
    ));

    getMonths(year);
  }

  void updateMonthTotal(double monthTotal) {
    emit(state.copyWith(monthTotal: monthTotal));
  }


  void updateGetMonthsResponse(GetMonthsResponse getMonthsResponse) {
    emit(state.copyWith(getMonthsResponse: getMonthsResponse));
  }

  Future<void> getYears() async {
    final years = await Db.getYears();
    final yearList =
        years.map<YearModel>((yearMap) => YearModel.fromJson(yearMap)).toList();
    emit(state.copyWith(years: yearList));
  }

  Future<void> getMonths(int year) async {
    updateGetMonthsResponse(GetMonthsResponse.loading);
    final months = await Db.getMonths(year);

    if (months.isEmpty) {
      updateGetMonthsResponse(GetMonthsResponse.error);
      return;
    }
    emit(state.copyWith(months: months));
    updateGetMonthsResponse(GetMonthsResponse.success);
  }

  void resetState() {
    emit(const MonthsListState());
  }
}
