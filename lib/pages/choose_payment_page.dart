import 'dart:developer';

import 'package:Fluxx/blocs/resume_bloc/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_bloc.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_state.dart';
import 'package:Fluxx/components/animated_check_button.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChoosePaymentPage extends StatefulWidget {
  const ChoosePaymentPage({
    super.key,
  });

  @override
  State<ChoosePaymentPage> createState() => _ChoosePaymentPageState();
}

class _ChoosePaymentPageState extends State<ChoosePaymentPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var actualMonth = await GetIt.I<ResumeCubit>().getActualMonth();
    // GetIt.I<RevenueCubit>().getRevenues(actualMonth);
    GetIt.I<RevenueCubit>().calculateAvailableValue(actualMonth.id!);
  }

  @override
  Widget build(BuildContext context) {
    final String billValue =
        ModalRoute.of(context)!.settings.arguments as String;
    final double billValueDouble = double.parse(billValue);
    log('valor da conta : $billValueDouble');
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width * .05,
            ),
            child: Column(
              children: [
                //AppBar
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: Constants.topMargin),
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
                        'Forma de Pagamento',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                    ],
                  ),
                ),
                BlocBuilder<RevenueCubit, RevenueState>(
                  bloc: GetIt.I(),
                  buildWhen: (previous, current) =>
                      previous.revenuesList != current.revenuesList,
                  builder: (context, state) {
                    if (state.revenuesList.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                'Você ainda não possui Rendas Cadastradas!',
                                style: AppTheme.textStyles.subTileTextStyle,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  var currentMonthId = GetIt.I<ResumeCubit>()
                                      .state
                                      .currentMonth!.id!;
                                  RevenueModel revenue =
                                      RevenueModel(monthId: currentMonthId);
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.addRevenuePage,
                                      arguments: revenue);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.colors.accentColor,
                                  minimumSize: const Size(50, 50),
                                ),
                                child: Text('Adicionar Nova Renda',
                                    style: AppTheme.textStyles.bodyTextStyle),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.revenuesList.length,
                          itemBuilder: (context, index) {
                            bool available = _verifyAvailability(billValueDouble,  state.availableRevenues[index].value ?? 0.0);
                            return PrimaryButton(
                              width: mediaQuery.width * .85,
                              text: state.revenuesList[index].name ?? '',
                              onPressed: !available
                                  ? () => _showUnavailableDialog(
                                        context,
                                        state.revenuesList[index].name ?? '',
                                      )
                                  : () => _showConfirmationDialog(
                                        context,
                                        state.revenuesList[index].name ?? '',
                                        state.revenuesList[index].id ?? '',
                                        state.revenuesList[index].value ?? 0.0,
                                      ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUnavailableDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            maxLines: 4,
            textAlign: TextAlign.center,
            'Oops!',
            style: AppTheme.textStyles.tileTextStyle,
          ),
          content: Text(
            maxLines: 4,
            textAlign: TextAlign.center,
            '" $name " não está disponível pois o valor da conta é maior que o valor disponível.',
            style: AppTheme.textStyles.subTileTextStyle,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'OK',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String name, String id, double value) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            maxLines: 4,
            textAlign: TextAlign.center,
            'Escolher $name?',
            style: AppTheme.textStyles.tileTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Não',
                style: AppTheme.textStyles.accentTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); //fecha dialog
                var revenue = RevenueModel(id: id, name: name, value: value);
                GetIt.I<RevenueCubit>().updateSelectedRevenue(revenue);
                Navigator.of(context).pop(); //volta para a página de add conta
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Sim',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }
  
  
  bool _verifyAvailability(double billValue, double revenueValue) {
    if (billValue <= revenueValue) {
      return true;
    }else{
      return false;
    }
  }
}
