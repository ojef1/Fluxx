import 'package:Fluxx/blocs/months_list_bloc/months_list_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthsListCubit extends Cubit<MonthsListState> {
  MonthsListCubit() : super(const MonthsListState());

  void updateMonthTotal(double monthTotal) {
    emit(state.copyWith(monthTotal: monthTotal));
  }

  void updateGetMonthsResponse(GetMonthsResponse getMonthsResponse) {
    emit(state.copyWith(getMonthsResponse: getMonthsResponse));
  }

  Future<void> getMonths() async {
    updateGetMonthsResponse(GetMonthsResponse.loaging);
    final months = await Db.getData(Tables.months);

    if (months.isEmpty) {
      updateGetMonthsResponse(GetMonthsResponse.error);
      return;
    }
    final monthsList = await Future.wait(
      months.map((item) async {
        final totalSpent = await Db.sumPricesByMonth(item['id']);

        return MonthModel(
          id: item['id'],
          name: item['name'],
          total: totalSpent, 
        );
      }).toList(),
    );
    emit(state.copyWith(months: monthsList));
    updateGetMonthsResponse(GetMonthsResponse.success);
  }
}
