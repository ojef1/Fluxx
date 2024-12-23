import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({
    super.key,
  });

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    GetIt.I<BillCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        'Adicionar Categoria',
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
                    height: mediaQuery.height * .8,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextField(
                          hint: 'Nome da Categoria',
                          controller: nameController,
                          icon: Icons.text_fields_sharp,
                        ),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _addNewBill(
  //   int monthId,
  //   int categoryId,
  //   int initialCategoryId,
  // ) async {
  //   if (nameController.text.isEmpty) {}
  //   if (priceController.text.isEmpty) {}
  //   if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
  //     final String price = priceController.text.replaceAll(',', '.');

  //     var newBill = BillModel(
  //       id: GetIt.I<BillCubit>().codeVoucherGenerate(),
  //       name: nameController.text,
  //       monthId: monthId,
  //       categoryId: categoryId,
  //       price: double.parse(price),
  //       isPayed: 0,
  //     );
  //     var result = await GetIt.I<BillCubit>().addNewBill(newBill);
  //     var state = GetIt.I<BillCubit>().state;
  //     if (result != -1) {
  //       Navigator.pop(context);
  //       GetIt.I<MonthsDetailCubit>()
  //           .getBillsByCategory(monthId, initialCategoryId);
  //       showFlushbar(context, state.successMessage, false);
  //     } else {
  //       showFlushbar(context, state.errorMessage, true);
  //     }
  //   }
  // }
}
