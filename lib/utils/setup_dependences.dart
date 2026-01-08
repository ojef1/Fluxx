
import 'package:Fluxx/blocs/bills_cubit/bill_form_cubit.dart';
import 'package:Fluxx/blocs/bills_cubit/bill_cubit.dart';
import 'package:Fluxx/blocs/bills_cubit/bill_list_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_form_cubit/category_form_cubit.dart';
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_form_cubit.dart';
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_list_cubit.dart';
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_info_cubit.dart';
import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_form_cubit.dart';
import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_list_cubit.dart';
import 'package:Fluxx/blocs/invoices_cubits/invoices_list_cubit.dart';
import 'package:Fluxx/blocs/months_list_bloc/months__list_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_form_cubit/revenue_form_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_cubit.dart';
import 'package:get_it/get_it.dart';

void setupDependencies() {
  final getIt = GetIt.I;

  getIt.registerLazySingleton<MonthsListCubit>(() => MonthsListCubit());
  getIt.registerLazySingleton<InvoicesListCubit>(() => InvoicesListCubit());
  getIt.registerLazySingleton<InvoiceBillListCubit>(() => InvoiceBillListCubit());
  getIt.registerLazySingleton<CreditCardListCubit>(() => CreditCardListCubit());
  getIt.registerLazySingleton<BillListCubit>(() => BillListCubit());
  getIt.registerLazySingleton<BillFormCubit>(() => BillFormCubit());
  getIt.registerLazySingleton<InvoiceBillFormCubit>(() => InvoiceBillFormCubit());
  getIt.registerLazySingleton<CreditCardFormCubit>(() => CreditCardFormCubit());
  getIt.registerLazySingleton<CreditCardInfoCubit>(() => CreditCardInfoCubit());
  getIt.registerLazySingleton<RevenueFormCubit>(() => RevenueFormCubit());
  getIt.registerLazySingleton<CategoryFormCubit>(() => CategoryFormCubit());
  getIt.registerLazySingleton<BillCubit>(() => BillCubit());
  getIt.registerLazySingleton<UserCubit>(() => UserCubit());
  getIt.registerLazySingleton<RevenueCubit>(() => RevenueCubit());
  getIt.registerLazySingleton<ResumeCubit>(() => ResumeCubit());
  getIt.registerLazySingleton<CategoryCubit>(() => CategoryCubit());
}
