import 'package:Fluxx/blocs/resume_bloc/resume_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResumeCubit extends Cubit<ResumeState> {
  ResumeCubit() : super(const ResumeState());

  String getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Bom dia,';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde,';
    } else {
      return 'Boa noite,';
    }
  }

  Future<int> getActualMonth() async {
    var result = await Db.getData(Tables.months);
    final currentMonth = DateTime.now().month;
    final actualMonth =
        result.firstWhere((month) => month['id'] == currentMonth);
    emit(state.copyWith(currentMonthId: actualMonth['id']));
    emit(state.copyWith(currentMonthName: actualMonth['name']));
    return actualMonth['id'];
  }

  Future<void> getTotalSpent(int monthId) async {
    updateTotalSpentStatus(TotalSpentStatus.loading);
    try {
      final total = await Db.getTotalByMonth(monthId);

      emit(state.copyWith(totalSpent: total));
      updateTotalSpentStatus(TotalSpentStatus.success);
    } catch (error) {
      debugPrint('$error');
      updateTotalSpentStatus(TotalSpentStatus.error);
      emit(state.copyWith(totalSpent: 0.0));
    }
    
  }

  updateTotalSpentStatus(TotalSpentStatus status) {
    emit(state.copyWith(totalSpentStatus: status));
  }


  Future<void> calculatePercent(double totalIncome)async{
    final _totalSpent = state.totalSpent;
    final _totalIncome = totalIncome;
    final _percent = (_totalSpent / _totalIncome) * 100;
    debugPrint('teste> porcentagem: $_percent');
    emit(state.copyWith(percentSpent: _percent));
  }

  void resetState() {
    emit(const ResumeState());
  }
}
