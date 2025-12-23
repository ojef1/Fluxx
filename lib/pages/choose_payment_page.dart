import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_revenue_list.dart';
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
    var monthInFocus = GetIt.I<ResumeCubit>().state.monthInFocus;
    GetIt.I<RevenueCubit>()
        .calculateAvailableValue(monthInFocus!.id!);
  }

  @override
  Widget build(BuildContext context) {
    final String billValue =
        ModalRoute.of(context)!.settings.arguments as String;
    final String billValueFormatted = billValue.replaceAll(',', '.');
    final double billValueDouble = double.parse(billValueFormatted);
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: const CustomAppBar(title: 'Forma de Pagamento'),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width * .05,
            ),
            child: Column(
              children: [
                const SizedBox(height: Constants.topMargin),
                BlocBuilder<RevenueCubit, RevenueState>(
                  bloc: GetIt.I(),
                  buildWhen: (previous, current) =>
                      previous.availableRevenues != current.availableRevenues,
                  builder: (context, state) {
                    if (state.getRevenueResponse ==
                        GetRevenueResponse.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (state.availableRevenues.isEmpty) {
                        return EmptyRevenueList(
                          onPressed: () {
                           RevenueModel revenue = RevenueModel();
                            Navigator.pushNamed(
                                    context, AppRoutes.addRevenuePage,
                                    arguments: revenue)
                                .then(
                              (value) => init(),
                            );
                          },
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.availableRevenues.length,
                            itemBuilder: (context, index) {
                              bool available = _verifyAvailability(
                                  billValueDouble,
                                  state.availableRevenues[index].value ?? 0.0);
                              return Column(
                                children: [
                                  PrimaryButton(
                                    color: AppTheme.colors.itemBackgroundColor,
                                    textStyle:
                                        AppTheme.textStyles.bodyTextStyle,
                                    width: mediaQuery.width * .85,
                                    text: state.availableRevenues[index].name ??
                                        '',
                                    onPressed: !available
                                        ? () => _showUnavailableDialog(
                                              context,
                                              state.availableRevenues[index]
                                                      .name ??
                                                  '',
                                            )
                                        : () => _showConfirmationDialog(
                                              context,
                                              state.availableRevenues[index]
                                                      .name ??
                                                  '',
                                              state.availableRevenues[index]
                                                      .id ??
                                                  '',
                                              state.availableRevenues[index]
                                                      .value ??
                                                  0.0,
                                            ),
                                  ),
                                  if (state.availableRevenues.length - 1 ==
                                      index)
                                    const SizedBox(height: 24),
                                  if (state.availableRevenues.length - 1 ==
                                      index)
                                    PrimaryButton(
                                      color:
                                          AppTheme.colors.itemBackgroundColor,
                                      textStyle: AppTheme
                                          .textStyles.bodyTextStyle
                                          .copyWith(
                                              color: AppTheme.colors.hintColor),
                                      width: mediaQuery.width * .85,
                                      text: 'Adicionar mais Rendas',
                                      onPressed: () {
                                        RevenueModel revenue = RevenueModel();
                                        return Navigator.pushNamed(context,
                                                AppRoutes.addRevenuePage,
                                                arguments: revenue)
                                            .then(
                                          (value) => init(),
                                        );
                                      },
                                    ),
                                ],
                              );
                            },
                          ),
                        );
                      }
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
          backgroundColor: AppTheme.colors.appBackgroundColor,
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
                backgroundColor: AppTheme.colors.hintColor,
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
          backgroundColor: AppTheme.colors.appBackgroundColor,
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            maxLines: 4,
            textAlign: TextAlign.center,
            'Escolher $name?',
            style:
                AppTheme.textStyles.tileTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Não',
                style: AppTheme.textStyles.bodyTextStyle,
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
                backgroundColor: AppTheme.colors.hintColor,
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
    } else {
      return false;
    }
  }
}
