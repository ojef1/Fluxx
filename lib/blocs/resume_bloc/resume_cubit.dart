import 'package:Fluxx/blocs/resume_bloc/resume_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/data/tables.dart';
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

  Future<void> getActualMonth()async{
    var result = await Db.getData(Tables.months);
    final currentMonth = DateTime.now().month;
    final actualMonth = result.firstWhere((month) => month['id'] == currentMonth);
    emit(state.copyWith(currentMonthId: actualMonth['id']));
    emit(state.copyWith(currentMonthName: actualMonth['name']));

  }


  void resetState() {
    emit(const ResumeState());
  }
}
