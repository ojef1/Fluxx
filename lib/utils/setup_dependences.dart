import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/blocs/category_bloc/category_cubit.dart';
import 'package:Fluxx/blocs/bill_list_bloc/bill_list_cubit.dart';
import 'package:Fluxx/blocs/months_list_bloc/months__list_cubit.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_bloc.dart';
import 'package:Fluxx/blocs/resume_bloc/resume_cubit.dart';
import 'package:Fluxx/blocs/user_bloc/user_cubit.dart';
import 'package:get_it/get_it.dart';

void setupDependencies() {
  final getIt = GetIt.I;
  // final goperRestApiClient = GoperRestApiClientImpl();

  getIt.registerLazySingleton<MonthsListCubit>(() => MonthsListCubit());
  getIt.registerLazySingleton<ListBillCubit>(() => ListBillCubit());
  getIt.registerLazySingleton<BillCubit>(() => BillCubit());
  getIt.registerLazySingleton<UserCubit>(() => UserCubit());
  getIt.registerLazySingleton<RevenueCubit>(() => RevenueCubit());
  getIt.registerLazySingleton<ResumeCubit>(() => ResumeCubit());
  getIt.registerLazySingleton<CategoryCubit>(() => CategoryCubit());
}
