import 'dart:developer';

import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/blocs/bill_bloc/bill_state.dart';
import 'package:Fluxx/blocs/month_detail_bloc/month_detail_cubit.dart';
import 'package:Fluxx/components/categorie_slider.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/toggle_status.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EditBillPage extends StatefulWidget {
  const EditBillPage({
    super.key,
  });

  @override
  State<EditBillPage> createState() => _EditBillPageState();
}

class _EditBillPageState extends State<EditBillPage> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final BillModel bill =
        ModalRoute.of(context)!.settings.arguments as BillModel;
    nameController.text = bill.name ?? '';
    priceController.text = bill.price.toString();
    if (count == 0) {
      GetIt.I<BillCubit>().updateEditCategoryInFocus(bill.categoryId!);
      GetIt.I<BillCubit>().updateBillStatus(bill.isPayed!);
      count = count = 1;
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.colors.backgroundColor),
        height: mediaQuery.height,
        padding: EdgeInsets.only(
          top: mediaQuery.height * .06,
          bottom: mediaQuery.height * .02,
          left: mediaQuery.width * .04,
          right: mediaQuery.width * .04,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<BillCubit, BillState>(
                      bloc: GetIt.I(),
                      buildWhen: (previous, current) =>
                          previous.editCategoryInFocus !=
                          current.editCategoryInFocus,
                      builder: (context, state) {
                        var isLoading =
                            state.addBillsResponse == AddBillsResponse.loaging;
                        return CustomAppBar(
                          title: 'Editar',
                          firstIcon: Icons.arrow_back_rounded,
                          firstIconSize: 25,
                          functionIcon:
                              isLoading ? Icons.hourglass_bottom : Icons.check,
                          firstFunction: () => Navigator.pop(context),
                          secondFunction: () => _editBill(
                            bill.id ?? '',
                            bill.monthId!,
                            state.editCategoryInFocus.index,
                            bill.categoryId!,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    CategorieSlider(
                      initialPage: bill.categoryId ?? 0,
                      filters: Constants.categories,
                      function: (index) =>
                          GetIt.I<BillCubit>().updateEditCategoryInFocus(index),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).viewInsets.top),
                      child: Container(
                        width: mediaQuery.width,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'nome',
                                  style: AppTheme.textStyles.subTileTextStyle,
                                ),
                                CustomTextField(
                                  hint: '',
                                  controller: nameController,
                                  icon: Icons.text_fields_sharp,
                                ),
                                SizedBox(height: mediaQuery.height * .03),
                                Text(
                                  'valor',
                                  style: AppTheme.textStyles.subTileTextStyle,
                                ),
                                CustomTextField(
                                  hint: '',
                                  controller: priceController,
                                  icon: Icons.attach_money_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: mediaQuery.height * .05),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                    child: Text(
                                  'pago',
                                  style: AppTheme.textStyles.bodyTextStyle,
                                  textAlign: TextAlign.center,
                                )),
                                ToggleStatus(
                                  initialValue: bill.isPayed!,
                                  isPayed: (value) => GetIt.I<BillCubit>()
                                      .updateBillStatus(value),
                                ),
                                Expanded(
                                    child: Text(
                                  'pendente',
                                  style: AppTheme.textStyles.bodyTextStyle,
                                  textAlign: TextAlign.end,
                                )),
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
            BlocBuilder<BillCubit, BillState>(
              bloc: GetIt.I(),
              builder: (context, state) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _removeBill(bill),
                    child:
                        state.removeBillsResponse == RemoveBillsResponse.loaging
                            ? const CircularProgressIndicator()
                            : const Row(
                                children: [
                                  Text(
                                    'Excluir',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.black,
                                    size: 25,
                                  )
                                ],
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeBill(BillModel bill) async {
    var result = await GetIt.I<BillCubit>().removeBill(bill.id!, bill.monthId!);
    var state = GetIt.I<BillCubit>().state;
    if (result > 0) {
      Navigator.pop(context);
      GetIt.I<MonthsDetailCubit>()
          .getBillsByCategory(bill.monthId!, bill.categoryId!);
      showFlushbar(context, state.successMessage, false);
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }

  Future<void> _editBill(
    String id,
    int monthId,
    int categoryId,
    int initialCategoryId,
  ) async {
    if (nameController.text.isEmpty) {}
    if (priceController.text.isEmpty) {}
    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
      final String price = priceController.text.replaceAll(',', '.');
      var state = GetIt.I<BillCubit>().state;

      var newBill = BillModel(
        id: id,
        name: nameController.text,
        monthId: monthId,
        categoryId: categoryId,
        price: double.parse(price),
        isPayed: state.billIsPayed,
      );
      log(newBill.toJson().toString());
      var result = await GetIt.I<BillCubit>().editBill(newBill);
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
