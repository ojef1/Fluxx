
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_info_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/pages/credit_card_info/credit_card_detail_page.dart';
import 'package:Fluxx/pages/credit_card_info/credit_card_stats_page.dart';
import 'package:Fluxx/services/app_period_service.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class CreditCardInfoPage extends StatefulWidget {
  const CreditCardInfoPage({super.key});

  @override
  State<CreditCardInfoPage> createState() => _CreditCardInfoPageState();
}

class _CreditCardInfoPageState extends State<CreditCardInfoPage> {
  late final MonthModel _currentMonth;

  @override
  void initState() {
    _currentMonth = AppPeriodService().monthInFocus;

    GetIt.I<CreditCardInfoCubit>().init(_currentMonth.id!);
    super.initState();
  }

   @override
  void dispose() {
    GetIt.I<CreditCardInfoCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppTheme.colors.appBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: const CustomAppBar(title: 'Informarções do Cartão'),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: Constants.topMargin),
                TabBar(
                  tabs: const [
                    Tab(text: 'Estatísticas do mês'),
                    Tab(text: 'Detalhes gerais'),
                  ],
                  labelColor: AppTheme.colors.white,
                  unselectedLabelColor: AppTheme.colors.white,
                  indicatorColor: AppTheme.colors.hintColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: AppTheme.textStyles.subTileTextStyle,
                  unselectedLabelStyle: AppTheme.textStyles.descTextStyle,
                  dividerColor: AppTheme.colors.appBackgroundColor,
                  overlayColor:
                      WidgetStatePropertyAll(AppTheme.colors.hintColor),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      CreditCardStatsPage(),
                      CreditCardDetailPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
