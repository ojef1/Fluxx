import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/blocs/bill_bloc/bill_state.dart';
import 'package:Fluxx/blocs/category_bloc/category_cubit.dart';
import 'package:Fluxx/blocs/category_bloc/category_state.dart';
import 'package:Fluxx/blocs/bill_list_bloc/bill_list_cubit.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_bloc.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_state.dart';
import 'package:Fluxx/components/categorie_slider.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/custom_data_picker.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/models/bill_model.dart';
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
  late int count;

  @override
  void initState() {
    count = 0;
    nameController = TextEditingController();
    descController = TextEditingController();
    priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    GetIt.I<BillCubit>().resetState();
    GetIt.I<CategoryCubit>().resetState();
    GetIt.I<RevenueCubit>().removeRevenueSelection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final BillModel? bill =
        ModalRoute.of(context)!.settings.arguments as BillModel;
    // if (count == 0) {
    //   GetIt.I<BillCubit>().updateCategoryInFocus(bill!.categoryId!);
    //   count = count = 1;
    // }

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // BlocBuilder<BillCubit, BillState>(
                //   bloc: GetIt.I(),
                //   buildWhen: (previous, current) =>
                //       previous.categoryInFocus != current.categoryInFocus,
                //   builder: (context, state) {
                //     var isLoading =
                //         state.addBillsResponse == AddBillsResponse.loaging;
                //     return CustomAppBar(
                //       title: 'Adicionar',
                //       firstIcon: Icons.arrow_back_rounded,
                //       firstIconSize: 25,
                //       functionIcon:
                //           isLoading ? Icons.hourglass_bottom : Icons.check,
                //       firstFunction: () => Navigator.pop(context),
                //       secondFunction: () => _addNewBill(bill.monthId ?? 0,
                //           state.categoryInFocus.index, bill.categoryId!),
                //     );
                //   },
                // ),
                //AppBar
                Container(
                  margin: const EdgeInsets.only(top: Constants.topMargin),
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * .05,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.colors.grayD4,
                        child: IconButton(
                            color: Colors.black,
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_rounded)),
                      ),
                      SizedBox(width: mediaQuery.width * .1),
                      Text(
                        'Adicionar Conta',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
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
                            CustomDataPicker(
                              hint: 'Data de Pagamento',
                              icon: Icons.calendar_today_rounded,
                              onDateChanged: (p0) =>
                                  GetIt.I<BillCubit>().updatePaymentDate(p0),
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
                                    color: AppTheme.colors.accentColor,
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
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
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
                                    color: AppTheme.colors.accentColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(3),
                                width: mediaQuery.width * .85,
                                child: ListTile(
                                  onTap: priceController.text.isEmpty
                                      ? () => showFlushbar(context,
                                          'preencha o campo do valor primeiro.', true)
                                      : () => Navigator.pushNamed(
                                            context,
                                            AppRoutes.choosePaymentPage,
                                            arguments: priceController.text
                                          ),
                                  title: Text(
                                    state.selectedRevenue != null
                                        ? 'Pagar com : ${state.selectedRevenue!.name!}'
                                        : 'Pagar com',
                                    style: AppTheme.textStyles.bodyTextStyle,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.colors.accentColor,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.all(3),
                              width: mediaQuery.width * .85,
                              child: ElevatedButton(
                                onPressed: () {
                                  var categoryId = GetIt.I<CategoryCubit>()
                                          .state
                                          .selectedCategory
                                          ?.id ??
                                      '';
                                  var revenueId = GetIt.I<RevenueCubit>()
                                          .state
                                          .selectedRevenue
                                          ?.id;
                                  _validation(
                                      monthId: bill!.monthId!,
                                      categoryId: categoryId,
                                      revenueId: revenueId,
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.colors.accentColor,
                                  minimumSize: const Size(50, 50),
                                ),
                                child: Text('Adicionar',
                                    style: AppTheme.textStyles.bodyTextStyle),
                              ),
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

  void _validation({
    required int monthId,
    required String categoryId,
    required String? revenueId,
  }) {
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
    _addNewBill(monthId, categoryId,revenueId);
  }

  Future<void> _addNewBill(
    int monthId,
    String categoryId,
    String? revenueId,
  ) async {
    final String price = priceController.text.replaceAll(',', '.');

    var newBill = BillModel(
      name: nameController.text,
      price: double.parse(price),
      paymentDate: GetIt.I<BillCubit>().state.paymentDate,
      description: descController.text,
      id: codeGenerate(),
      monthId: monthId,
      categoryId: categoryId,
      paymentId: revenueId,
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
}
