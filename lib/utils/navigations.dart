import 'package:Fluxx/blocs/bill_form_cubit/bill_form_cubit.dart';
import 'package:Fluxx/blocs/category_form_cubit/category_form_cubit.dart';
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_form_cubit.dart';
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_info_cubit.dart';
import 'package:Fluxx/blocs/revenue_form_cubit/revenue_form_cubit.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/credit_card_model.dart';
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
    AppRoutes.billFormPage,
  );
}

void goToRevenueForm({required BuildContext context, RevenueModel? revenue}) {
  if (revenue != null) {
    //se existe dados da receita significa que será editado
    //portanto o modo do formulário será para edição
    GetIt.I<RevenueFormCubit>().updateRevenueFormMode(RevenueFormMode.editing);
    GetIt.I<RevenueFormCubit>().loadRevenueToEdit(revenue);
  } else {
    GetIt.I<RevenueFormCubit>().updateRevenueFormMode(RevenueFormMode.adding);
  }
  Navigator.pushNamed(
    context,
    AppRoutes.revenueFormPage,
  );
}

void goToCategoryForm({required BuildContext context, CategoryModel? category}) {
  if (category != null) {
    //se existe dados da categoria significa que será editado
    //portanto o modo do formulário será para edição
    GetIt.I<CategoryFormCubit>().updateCategoryFormMode(CategoryFormMode.editing);
    GetIt.I<CategoryFormCubit>().loadCategoryToEdit(category);
  } else {
    GetIt.I<CategoryFormCubit>().updateCategoryFormMode(CategoryFormMode.adding);
  }
  Navigator.pushNamed(
    context,
    AppRoutes.categoryFormPage,
  );
} 

void goToCreditCardForm({required BuildContext context, CreditCardModel? creditCard}) {
  if (creditCard != null) {
    //se existe dados do cartão significa que será editado
    //portanto o modo do formulário será para edição
    GetIt.I<CreditCardFormCubit>().updateFormMode(CreditCardFormMode.editing);
    GetIt.I<CreditCardFormCubit>().loadCreditCardToEdit(creditCard);
  } else {
    GetIt.I<CreditCardFormCubit>().updateFormMode(CreditCardFormMode.adding);
  }
  Navigator.pushNamed(
    context,
    AppRoutes.creditCardFormPage,
  );
} 

void goToCreditCardInfo({required BuildContext context, required String id}) {
  GetIt.I<CreditCardInfoCubit>().loadIdToGet(id);
  Navigator.pushNamed(
    context,
    AppRoutes.creditCardInfoPage,
  );
}

void goToHomePage({required BuildContext context}){
  Navigator.pushNamed(context, AppRoutes.homePage);
}
