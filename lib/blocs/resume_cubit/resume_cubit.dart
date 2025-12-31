import 'package:Fluxx/blocs/resume_cubit/resume_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/month_model.dart';
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

  Future<MonthModel> getActualMonth() async {
    var result = await Db.getMonths(DateTime.now().year);
    List<MonthModel> monthsList = result
        .map<MonthModel>((monthMap) => MonthModel.fromJson(monthMap))
        .toList();
    final currentMonthNumber = DateTime.now().month;
    final actualMonth = monthsList
        .firstWhere((month) => month.monthNumber == currentMonthNumber);
    final totalSpent = await Db.sumPricesByMonth(actualMonth.id!);
    final monthModel = MonthModel(
      id: actualMonth.id,
      yearId: actualMonth.yearId,
      name: actualMonth.name,
      monthNumber: actualMonth.monthNumber,
      total: totalSpent,
    );
    emit(state.copyWith(currentMonth: monthModel));
    return monthModel;
  }

  void updateMonthInFocus(MonthModel month) {
    emit(state.copyWith(monthInFocus: month));
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

  Future<void> calculatePercent(double totalIncome) async {
    final totalSpent = state.totalSpent;
    if (totalIncome == 0.0) {
      // Não tem receita, então não calcula porcentagem
      emit(state.copyWith(percentSpent: 0.0));
      return;
    } else {
      final percent = (totalSpent / totalIncome) * 100;
      emit(state.copyWith(percentSpent: percent));
      return;
    }
  }

  void resetState() {
    emit(const ResumeState());
  }
}
