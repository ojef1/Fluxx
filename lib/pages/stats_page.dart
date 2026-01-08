import 'package:Fluxx/blocs/bills_cubit/bill_list_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_state.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/stats_categorys.dart';
import 'package:Fluxx/components/stats_revenues.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({
    super.key,
  });

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final ScrollController _pageScrollController;
  @override
  void initState() {
    _pageScrollController = ScrollController();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageScrollController.dispose();
  }

  Future<void> _init() async {

    final state = GetIt.I<ResumeCubit>().state;
    var totalRevenues = await GetIt.I<RevenueCubit>().calculateTotalRevenues();

    await GetIt.I<ResumeCubit>().getTotalSpent(state.monthInFocus!.id!);
    await GetIt.I<ResumeCubit>().calculatePercent(totalRevenues);
    await GetIt.I<RevenueCubit>()
        .calculateAvailableValue(state.monthInFocus!.id!);
    await GetIt.I<RevenueCubit>()
        .calculateRemainigRevenues(state.monthInFocus!.id!);
    await GetIt.I<BillListCubit>().getAllBills(state.monthInFocus!.id!);
    await GetIt.I<CategoryCubit>().getTotalByCategory(state.monthInFocus!.id!);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: const CustomAppBar(title: 'Estatísticas'),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _pageScrollController,
            child: Column(
              children: [
                //Resumo
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: Constants.topMargin),
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * .05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        height: mediaQuery.height * .16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.itemBackgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              'Total de Despesas X Total de Receitas',
                              style: AppTheme.textStyles.subTileTextStyle,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BlocBuilder<ResumeCubit, ResumeState>(
                                      bloc: GetIt.I(),
                                      buildWhen: (previous, current) =>
                                          previous.totalSpent !=
                                          current.totalSpent,
                                      builder: (context, state) => Text(
                                        'R\$${formatPrice(state.totalSpent)}',
                                        style:
                                            AppTheme.textStyles.subTileTextStyle,
                                      ),
                                    ),
                                    BlocBuilder<RevenueCubit, RevenueState>(
                                      bloc: GetIt.I(),
                                      buildWhen: (previous, current) =>
                                          previous.totalRevenue !=
                                          current.totalRevenue,
                                      builder: (context, state) => Text(
                                        'R\$${formatPrice(state.totalRevenue)}',
                                        style:
                                            AppTheme.textStyles.subTileTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: mediaQuery.height * .01),
                                BlocBuilder<ResumeCubit, ResumeState>(
                                  bloc: GetIt.I(),
                                  buildWhen: (previous, current) =>
                                      previous.percentSpent !=
                                      current.percentSpent,
                                  builder: (context, state) =>
                                      LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    barRadius: const Radius.circular(50),
                                    lineHeight: 15,
                                    percent: state.percentSpent / 100,
                                    progressColor: AppTheme.colors.hintColor,
                                    backgroundColor:
                                        AppTheme.colors.lightHintColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: mediaQuery.height * .01),
                      BlocBuilder<RevenueCubit, RevenueState>(
                        bloc: GetIt.I(),
                        buildWhen: (previous, current) =>
                            previous.remainingRevenue !=
                            current.remainingRevenue,
                        builder: (context, state) => Text(
                            'Receita Total Restante : R\$${formatPrice(state.remainingRevenue)}',
                            style: AppTheme.textStyles.subTileTextStyle),
                      ),
                      SizedBox(height: mediaQuery.height * .01),
                      BlocBuilder<BillListCubit, ListBillState>(
                        bloc: GetIt.I(),
                        buildWhen: (previous, current) =>
                            previous.bills != current.bills,
                        builder: (context, state) => Text(
                            'Total de Contas : ${state.bills.length}',
                            style: AppTheme.textStyles.subTileTextStyle),
                      ),
                      SizedBox(height: mediaQuery.height * .01),
                      //Divisor
                      Container(
                        margin: EdgeInsets.only(
                          top: mediaQuery.width * .05,
                          bottom: mediaQuery.width * .01,
                        ),
                        height: 1,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Despesas por Categoria',
                              style: AppTheme.textStyles.subTileTextStyle,
                            ),
                            // IconButton(
                            //     onPressed: () {},
                            //     icon: const Icon(Icons.filter_alt_rounded))
                          ],
                        ),
                      ),

                      SizedBox(height: mediaQuery.height * .01),
                      const StatsCategory(),
                      //Divisor
                      Container(
                        margin: EdgeInsets.only(
                          top: mediaQuery.width * .05,
                          bottom: mediaQuery.width * .01,
                        ),
                        height: 1,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Despesas por Receita',
                              style: AppTheme.textStyles.subTileTextStyle,
                            ),
                            // IconButton(
                            //     onPressed: () {},
                            //     icon: const Icon(Icons.filter_alt_rounded))
                          ],
                        ),
                      ),
                      const StatsRevenues(),
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
