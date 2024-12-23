import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class AddRevenuePage extends StatefulWidget {
  const AddRevenuePage({
    super.key,
  });

  @override
  State<AddRevenuePage> createState() => _AddRevenuePageState();
}

class _AddRevenuePageState extends State<AddRevenuePage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  bool boolean = false;

  @override
  void initState() {
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

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              //AppBar
              Container(
                margin: const EdgeInsets.only(top: Constants.topMargin),
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width * .05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.colors.grayD4,
                      child: IconButton(
                          color: Colors.black,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded)),
                    ),
                    // SizedBox(width: mediaQuery.width * .1),
                    Text(
                      'Adicionar Renda',
                      style: AppTheme.textStyles.titleTextStyle,
                    ),
                     CircleAvatar(
                      backgroundColor: AppTheme.colors.grayD4,
                      child: IconButton(
                          color: Colors.black,
                          onPressed: () => _showInfoDialog(context),
                          icon: const Icon(Icons.question_mark_rounded)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
                child: Container(
                  width: mediaQuery.width,
                  height: mediaQuery.height * .8,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CustomTextField(
                            hint: 'Nome da Renda',
                            controller: nameController,
                            icon: Icons.text_fields_sharp,
                          ),
                          SizedBox(height: mediaQuery.height * .03),
                          CustomTextField(
                            hint: 'Valor total da Renda',
                            controller: priceController,
                            icon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: mediaQuery.height * .03),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaQuery.height * .05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Renda válida para todos os meses?',
                                  style: AppTheme.textStyles.accentTextStyle,
                                ),
                                Switch(
                                  value: boolean,
                                  activeColor: AppTheme.colors.accentColor,
                                  activeTrackColor: Colors.white,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor:
                                      AppTheme.colors.accentColor,
                                  onChanged: (value) {
                                    setState(() {
                                      boolean = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
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
    );
  }

 void _showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            left: 20,
            right: 50,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Tipo de renda que está sendo criada:',style: AppTheme.textStyles.subTileTextStyle,textAlign: TextAlign.center,),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Text('O toggle permite definir o tipo de renda que está sendo criada.',style: AppTheme.textStyles.accentTextStyle, maxLines: 4,textAlign: TextAlign.center,),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Text('Se ativado, ela será global e se aplicará automaticamente a todos os meses, ideal para rendas fixas como salário. ',style: AppTheme.textStyles.accentTextStyle, maxLines: 4,textAlign: TextAlign.center,),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Text('Se desativado, a renda será específica do mês atual, útil para ganhos pontuais como freelances.',style: AppTheme.textStyles.accentTextStyle, maxLines: 4,textAlign: TextAlign.center,),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                  ],
                ),
              ),
            ),
          ),
        ],
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
