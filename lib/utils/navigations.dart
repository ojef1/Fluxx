import 'package:Fluxx/blocs/bill_form_cubit/bill_form_cubit.dart';
import 'package:Fluxx/blocs/revenue_form_cubit/revenue_form_cubit.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

void goToBillForm({required BuildContext context, BillModel? bill}) {
  if (bill != null) {
    //se existe dados da conta significa que será editado
    //portanto o modo do formulário será para edição
    GetIt.I<BillFormCubit>().updateFormMode(BillFormMode.editing);
    GetIt.I<BillFormCubit>().loadBillToEdit(bill);
  } else {
    GetIt.I<BillFormCubit>().updateFormMode(BillFormMode.adding);
  }
  Navigator.pushNamed(
    context,
    AppRoutes.addBillPage,
  );
}

void goToRevenueForm({required BuildContext context, RevenueModel? revenue}) {
  if (revenue != null) {
    //se existe dados da renda significa que será editado
    //portanto o modo do formulário será para edição
    GetIt.I<RevenueFormCubit>().updateRevenueFormMode(RevenueFormMode.editing);
    GetIt.I<RevenueFormCubit>().loadRevenueToEdit(revenue);
  } else {
    GetIt.I<RevenueFormCubit>().updateRevenueFormMode(RevenueFormMode.adding);
  }
  Navigator.pushNamed(
    context,
    AppRoutes.addRevenuePage,
  );
}
