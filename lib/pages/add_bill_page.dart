import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/blocs/bill_bloc/bill_state.dart';
import 'package:Fluxx/blocs/month_detail_bloc/month_detail_cubit.dart';
import 'package:Fluxx/components/categorie_slider.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
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
    final BillModel bill =
        ModalRoute.of(context)!.settings.arguments as BillModel;
    if (count == 0) {
      GetIt.I<BillCubit>().updateCategoryInFocus(bill.categoryId!);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<BillCubit, BillState>(
                bloc: GetIt.I(),
                buildWhen: (previous, current) =>
                    previous.categoryInFocus != current.categoryInFocus,
                builder: (context, state) {
                  var isLoading =
                      state.addBillsResponse == AddBillsResponse.loaging;
                  return CustomAppBar(
                    title: 'Adicionar',
                    firstIcon: Icons.arrow_back_rounded,
                    firstIconSize: 25,
                    functionIcon:
                        isLoading ? Icons.hourglass_bottom : Icons.check,
                    firstFunction: () => Navigator.pop(context),
                    secondFunction: () => _addNewBill(bill.monthId ?? 0,
                        state.categoryInFocus.index, bill.categoryId!),
                  );
                },
              ),
              const SizedBox(height: 50),
              CategorieSlider(
                initialPage: bill.categoryId ?? 0,
                filters: Constants.categories,
                function: (index) =>
                    GetIt.I<BillCubit>().updateCategoryInFocus(index),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
                child: Container(
                  width: mediaQuery.width,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'nome',
                            style: AppTheme.textStyles.subTileTextStyle,
                          ),
                          CustomTextField(
                            controller: nameController,
                            icon: Icons.text_fields_sharp,
                          ),
                          SizedBox(height: mediaQuery.height * .03),
                          Text(
                            'valor',
                            style: AppTheme.textStyles.subTileTextStyle,
                          ),
                          CustomTextField(
                            controller: priceController,
                            icon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: mediaQuery.height * .05),
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
