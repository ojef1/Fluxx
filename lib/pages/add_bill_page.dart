import 'package:Fluxx/blocs/bill_cubit/bill_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/custom_data_picker.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({
    super.key,
  });

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController priceController;
  String? previousPrice = "";

  late final BillModel? billModel;

  bool isEditing = false;

  @override
  void initState() {
    nameController = TextEditingController();
    descController = TextEditingController();
    priceController = TextEditingController();

    priceController.addListener(
      () {
        var revenueState = GetIt.I<RevenueCubit>().state;

        // Verifica se o valor foi alterado (comparando com o anterior)
        if (previousPrice != priceController.text) {
          // Se houver alteração e a condição for atendida
          if (revenueState.selectedRevenue!.id!.isNotEmpty) {
            GetIt.I<RevenueCubit>().resetState();
            showFlushbar(context, 'A renda foi removida!', true);
          }
          // Atualizando o valor anterior
          previousPrice = priceController.text;
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    billModel = ModalRoute.of(context)!.settings.arguments as BillModel?;
    _hasData(billModel);
  }

  void _hasData(BillModel? billModel) {
    if (billModel?.id != null) {
      setState(() {
        nameController.text = billModel?.name ?? '';
        descController.text = billModel?.description ?? '';
        priceController.text = (billModel?.price ?? 0).toString();
        GetIt.I<BillCubit>().updatePaymentDate(billModel?.paymentDate, true);
        var category = CategoryModel(
            id: billModel?.categoryId, categoryName: billModel?.categoryName);
        GetIt.I<CategoryCubit>().updateSelectedCategory(category);
        var revenue = RevenueModel(
            id: billModel?.paymentId,
            name: billModel?.paymentName,
            value: 0.0); //value não faz diferença na edição
        GetIt.I<RevenueCubit>().updateSelectedRevenue(revenue);
        isEditing = true;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    if (!isEditing) {
      GetIt.I<BillCubit>().resetState();
    }
    GetIt.I<CategoryCubit>().resetState();
    GetIt.I<RevenueCubit>().removeRevenueSelection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final BillModel bill =
        ModalRoute.of(context)!.settings.arguments as BillModel;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar:
            CustomAppBar(title: isEditing ? 'Editar Conta' : 'Adicionar Conta'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: Constants.topMargin),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewInsets.top),
                  child: Container(
                    width: mediaQuery.width,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextField(
                              hint: 'Nome da Conta',
                              controller: nameController,
                              icon: Icons.text_fields_sharp,
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            CustomTextField(
                              hint: 'Valor da Conta',
                              controller: priceController,
                              icon: Icons.attach_money_rounded,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            PaymentDataPicker(
                              hint: 'Data de Pagamento',
                              icon: Icons.calendar_today_rounded,
                              onDateChanged: (p0) => GetIt.I<BillCubit>()
                                  .updatePaymentDate(p0, false),
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            CustomTextField(
                              hint: 'Descrição',
                              height: mediaQuery.height * .2,
                              controller: descController,
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            BlocBuilder<CategoryCubit, CategoryState>(
                              bloc: GetIt.I(),
                              buildWhen: (previous, current) =>
                                  previous.selectedCategory !=
                                  current.selectedCategory,
                              builder: (context, state) => Container(
                                decoration: BoxDecoration(
                                    color: AppTheme.colors.itemBackgroundColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(3),
                                width: mediaQuery.width * .85,
                                child: ListTile(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.chooseCategoryPage,
                                  ),
                                  title: Text(
                                    state.selectedCategory != null
                                        ? 'Categoria : ${state.selectedCategory!.categoryName!}'
                                        : 'Categoria',
                                    style: AppTheme.textStyles.bodyTextStyle,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppTheme.colors.hintColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            BlocBuilder<RevenueCubit, RevenueState>(
                              bloc: GetIt.I(),
                              buildWhen: (previous, current) =>
                                  previous.selectedRevenue !=
                                  current.selectedRevenue,
                              builder: (context, state) => Container(
                                decoration: BoxDecoration(
                                    color: AppTheme.colors.itemBackgroundColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(3),
                                width: mediaQuery.width * .85,
                                child: ListTile(
                                  onTap: () {
                                    if (priceController.text.isEmpty) {
                                      showFlushbar(
                                          context,
                                          'Preencha o campo do valor primeiro.',
                                          true);
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.choosePaymentPage,
                                        arguments: priceController.text,
                                      );
                                    }
                                  },
                                  title: Text(
                                    state.selectedRevenue != null
                                        ? 'Pagar com : ${state.selectedRevenue!.name!}'
                                        : 'Pagar com',
                                    style: AppTheme.textStyles.bodyTextStyle,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppTheme.colors.hintColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            PrimaryButton(
                              text: isEditing ? 'Editar' : 'Adicionar',
                              onPressed: () => _validation(bill: bill),
                              width: mediaQuery.width * .85,
                              color: AppTheme.colors.itemBackgroundColor,
                              textStyle: AppTheme.textStyles.bodyTextStyle,
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validation({required BillModel bill}) {
    if (nameController.text.isEmpty) {
      showFlushbar(context, 'preencha o campo do nome', true);
      return;
    }
    if (priceController.text.isEmpty) {
      showFlushbar(context, 'preencha o campo do valor', true);
      return;
    }
    if (GetIt.I<BillCubit>().state.paymentDate == '') {
      showFlushbar(context, 'Escolha a data de pagamento', true);
      return;
    }
    if (GetIt.I<CategoryCubit>().state.selectedCategory == null) {
      showFlushbar(context, 'Escolha a categoria da conta', true);
      return;
    }

    if (isEditing) {
      _editBill(bill);
    } else {
      _addNewBill(bill.monthId!);
    }
  }

  Future<void> _addNewBill(
    int monthId,
  ) async {
    final String price = priceController.text.replaceAll(',', '.');
    var categoryState = GetIt.I<CategoryCubit>().state;
    var revenueState = GetIt.I<RevenueCubit>().state;

    var newBill = BillModel(
      name: nameController.text,
      price: double.parse(price),
      paymentDate: GetIt.I<BillCubit>().state.paymentDate,
      description: descController.text,
      id: codeGenerate(),
      monthId: monthId,
      categoryId: categoryState.selectedCategory!.id!,
      paymentId: revenueState.selectedRevenue?.id,
      isPayed: 0,
    );
    var result = await GetIt.I<BillCubit>().addNewBill(newBill);
    var state = GetIt.I<BillCubit>().state;
    if (result != -1) {
      Navigator.pop(context);
      // GetIt.I<MonthsDetailCubit>()
      //     .getBillsByCategory(monthId, initialCategoryId);
      showFlushbar(context, state.successMessage, false);
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }

  Future<void> _editBill(BillModel bill) async {
    if (nameController.text.isEmpty) {}
    if (priceController.text.isEmpty) {}
    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
      final String price = priceController.text.replaceAll(',', '.');
      var billState = GetIt.I<BillCubit>().state;
      var categoryState = GetIt.I<CategoryCubit>().state;
      var revenueState = GetIt.I<RevenueCubit>().state;

      var newBill = BillModel(
        id: bill.id,
        monthId: bill.monthId,
        name: nameController.text,
        description: descController.text,
        price: double.parse(price),
        categoryId: categoryState.selectedCategory!.id!,
        paymentDate: billState.paymentDate,
        paymentId: revenueState.selectedRevenue!.id,
        isPayed: bill.isPayed,
      );
      var result = await GetIt.I<BillCubit>().editBill(newBill);
      if (result != -1) {
        Navigator.pop(
          context,
        );
        GetIt.I<BillCubit>().getBill(newBill.id!, newBill.monthId!);
        showFlushbar(context, GetIt.I<BillCubit>().state.successMessage, false);
      } else {
        showFlushbar(context, GetIt.I<BillCubit>().state.errorMessage, true);
      }
    }
  }
}
