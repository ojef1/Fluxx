
import 'package:Fluxx/blocs/add_bill_cubit/add_bill_cubit.dart';
import 'package:Fluxx/blocs/bill_cubit/bill_cubit.dart';
import 'package:Fluxx/blocs/bill_list_cubit/bill_list_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/months_list_bloc/months__list_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_cubit.dart';
import 'package:get_it/get_it.dart';

void setupDependencies() {
  final getIt = GetIt.I;

  getIt.registerLazySingleton<MonthsListCubit>(() => MonthsListCubit());
  getIt.registerLazySingleton<ListBillCubit>(() => ListBillCubit());
  getIt.registerLazySingleton<AddBillCubit>(() => AddBillCubit());
  getIt.registerLazySingleton<BillCubit>(() => BillCubit());
  getIt.registerLazySingleton<UserCubit>(() => UserCubit());
  getIt.registerLazySingleton<RevenueCubit>(() => RevenueCubit());
  getIt.registerLazySingleton<ResumeCubit>(() => ResumeCubit());
  getIt.registerLazySingleton<CategoryCubit>(() => CategoryCubit());
}
