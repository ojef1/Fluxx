import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/blocs/month_detail_bloc/month_detail_cubit.dart';
import 'package:Fluxx/blocs/months_list_bloc/months__list_cubit.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_bloc.dart';
import 'package:Fluxx/blocs/user_bloc/user_cubit.dart';
import 'package:get_it/get_it.dart';

void setupDependencies() {
  final getIt = GetIt.I;
  // final goperRestApiClient = GoperRestApiClientImpl();

  getIt.registerLazySingleton<MonthsListCubit>(() => MonthsListCubit());
  getIt.registerLazySingleton<MonthsDetailCubit>(() => MonthsDetailCubit());
  getIt.registerLazySingleton<BillCubit>(() => BillCubit());
  getIt.registerLazySingleton<UserCubit>(() => UserCubit());
  getIt.registerLazySingleton<RevenueCubit>(() => RevenueCubit());
}
