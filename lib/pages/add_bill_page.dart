import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/blocs/bill_bloc/bill_state.dart';
import 'package:Fluxx/blocs/month_detail_bloc/month_detail_cubit.dart';
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
  late TextEditingController priceController;
  late int count;

  @override
  void initState() {
    count = 0;
    nameController = TextEditingController();
    priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    GetIt.I<BillCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    // final BillModel? bill =
    //     ModalRoute.of(context)!.settings.arguments as BillModel;
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
                // CategorieSlider(
                //   initialPage: bill.categoryId ?? 0,
                //   filters: Constants.categories,
                //   function: (index) =>
                //       GetIt.I<BillCubit>().updateCategoryInFocus(index),
                // ),
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
                            const CustomDataPicker(
                              hint: 'Data de Pagamento',
                              icon: Icons.calendar_today_rounded,
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            CustomTextField(
                              hint: 'Descrição',
                              height: mediaQuery.height * .2,
                              controller: priceController,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            Container(
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
                                  'Categoria',
                                  style: AppTheme.textStyles.bodyTextStyle,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
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
                              child: ListTile(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.choosePaymentPage,
                                ),
                                title: Text(
                                  'Forma de Pagamento',
                                  style: AppTheme.textStyles.bodyTextStyle,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
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
                                onPressed: () {},
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

  Future<void> _addNewBill(
    int monthId,
    int categoryId,
    int initialCategoryId,
  ) async {
    if (nameController.text.isEmpty) {}
    if (priceController.text.isEmpty) {}
    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
      final String price = priceController.text.replaceAll(',', '.');

      var newBill = BillModel(
        id: GetIt.I<BillCubit>().codeVoucherGenerate(),
        name: nameController.text,
        monthId: monthId,
        categoryId: categoryId,
        price: double.parse(price),
        isPayed: 0,
      );
      var result = await GetIt.I<BillCubit>().addNewBill(newBill);
      var state = GetIt.I<BillCubit>().state;
      if (result != -1) {
        Navigator.pop(context);
        GetIt.I<MonthsDetailCubit>()
            .getBillsByCategory(monthId, initialCategoryId);
        showFlushbar(context, state.successMessage, false);
      } else {
        showFlushbar(context, state.errorMessage, true);
      }
    }
  }
}
