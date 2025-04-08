import 'dart:developer';

import 'package:Fluxx/blocs/resume_bloc/resume_cubit.dart';
import 'package:Fluxx/blocs/resume_bloc/resume_state.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_bloc.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_state.dart';
import 'package:Fluxx/blocs/user_bloc/user_cubit.dart';
import 'package:Fluxx/blocs/user_bloc/user_state.dart';
import 'package:Fluxx/components/resumePage/available_revenues.dart';
import 'package:Fluxx/components/shortcut_add_bottomsheet.dart';
import 'package:Fluxx/components/shortcut_lists_bottomsheet.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  late final ScrollController _pageScrollController;
  late final String greeting;

  @override
  void initState() {
    greeting = GetIt.I<ResumeCubit>().getGreeting();
    _pageScrollController = ScrollController();
    init();
    super.initState();
  }

  Future<void> init() async {
    var actualMonth = await GetIt.I<ResumeCubit>().getActualMonth();
    // GetIt.I<RevenueCubit>().getRevenues(actualMonth);
    await GetIt.I<RevenueCubit>().calculateAvailableValue(actualMonth);
    await GetIt.I<ResumeCubit>().getTotalSpent(actualMonth);
    var totalRevenues = await GetIt.I<RevenueCubit>().calculateTotalRevenues();
    await GetIt.I<ResumeCubit>().calculatePercent(totalRevenues);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    //FIXME remover esse link mocado
    const url =
        'https://static.vecteezy.com/system/resources/thumbnails/002/387/693/small_2x/user-profile-icon-free-vector.jpg';
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.colors.appBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _pageScrollController,
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
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.profilePage),
                      child: const CircleAvatar(
                        //FIXME usar a imagem escolhida do próprio usuário
                        backgroundImage: NetworkImage(url),
                      ),
                    ),
                    SizedBox(width: mediaQuery.width * .07),
                    BlocBuilder<UserCubit, UserState>(
                      bloc: GetIt.I(),
                      builder: (context, state) => Text(
                        '$greeting ${state.user?.name ?? 'Usuário'}',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
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
                    BlocBuilder<ResumeCubit, ResumeState>(
                      bloc: GetIt.I(),
                      builder: (context, state) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Resumo de ${state.currentMonthName}',
                            style: AppTheme.textStyles.titleTextStyle,
                          ),
                          IconButton(
                            onPressed: () async {
                              var actualMonth =
                                  await GetIt.I<ResumeCubit>().getActualMonth();
                              GetIt.I<ResumeCubit>().getTotalSpent(actualMonth);

                              var totalRevenues = await GetIt.I<RevenueCubit>()
                                  .calculateTotalRevenues();
                              GetIt.I<ResumeCubit>()
                                  .calculatePercent(totalRevenues);
                            },
                            icon: const Icon(Icons.refresh_rounded),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: mediaQuery.height * .02),
                    Container(
                      padding: const EdgeInsets.all(18),
                      height: mediaQuery.height * .18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<ResumeCubit, ResumeState>(
                            bloc: GetIt.I(),
                            builder: (context, state) => Text(
                              'R\$${formatPrice(state.totalSpent)}',
                              style: AppTheme.textStyles.titleTextStyle,
                            ),
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
                                        previous.percentSpent !=
                                        current.percentSpent,
                                    builder: (context, state) => Text(
                                      '${state.percentSpent.toStringAsFixed(0)}%',
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
                                  lineHeight: 20,
                                  percent: state.percentSpent / 100,
                                  progressColor: getBarColor(state.percentSpent / 100),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //Divisor
              Container(
                margin: EdgeInsets.only(
                  top: mediaQuery.width * .05,
                  bottom: mediaQuery.width * .01,
                ),
                height: 1,
                color: Colors.white,
              ),
              //Acesso Rápido
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width * .05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acesso Rápido',
                      style: AppTheme.textStyles.titleTextStyle,
                    ),
                    SizedBox(height: mediaQuery.height * .01),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.colors.accentColor,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add_rounded),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: () => _showAddBottomSheet(context),
                                ),
                              ),
                              Text(
                                'Adicionar',
                                style: AppTheme.textStyles.accentTextStyle,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.colors.accentColor,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.menu_rounded),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: () =>
                                      _showListsBottomSheet(context),
                                ),
                              ),
                              Text(
                                'Listas',
                                style: AppTheme.textStyles.accentTextStyle,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.colors.accentColor,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.bar_chart_rounded),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: () => Navigator.pushNamed(
                                      context, AppRoutes.statsPage),
                                ),
                              ),
                              Text(
                                'Estatísticas',
                                style: AppTheme.textStyles.accentTextStyle,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //Divisor
              Container(
                margin: EdgeInsets.only(
                  top: mediaQuery.width * .05,
                  bottom: mediaQuery.width * .01,
                ),
                height: 1,
                color: Colors.white,
              ),
              //Receitas Disponíveis
              const AvailableRevenues()
            ],
          ),
        ),
      ),
    );
  }

 

  void _showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const ShortcutAddBottomsheet();
      },
    );
  }

  void _showListsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const ShortcutListsBottomsheet();
      },
    );
  }
}
