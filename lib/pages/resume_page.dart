import 'dart:io';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_state.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/blocs/user_cubit/user_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_state.dart';
import 'package:Fluxx/components/available_revenues.dart';
import 'package:Fluxx/components/shortcut_add_bottomsheet.dart';
import 'package:Fluxx/components/shortcut_lists_bottomsheet.dart';
import 'package:Fluxx/models/month_model.dart';
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
  late MonthModel actualMonth;

  bool _wasPaused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (isCurrent && _wasPaused) {
      init();
      _wasPaused = false;
    } else if (!isCurrent) {
      _wasPaused = true;
    }
  }

  @override
  void initState() {
    greeting = GetIt.I<ResumeCubit>().getGreeting();
    GetIt.I<UserCubit>().getUserInfos();
    _pageScrollController = ScrollController();
    init();
    super.initState();
  }

  Future<void> init() async {
    actualMonth = await GetIt.I<ResumeCubit>().getActualMonth();

    GetIt.I<ResumeCubit>().updateMonthInFocus(actualMonth);
    await GetIt.I<RevenueCubit>()
        .calculateAvailableValue(actualMonth.id!);
    await GetIt.I<ResumeCubit>().getTotalSpent(actualMonth.id!);
    var totalRevenues = await GetIt.I<RevenueCubit>().calculateTotalRevenues();
    await GetIt.I<ResumeCubit>().calculatePercent(totalRevenues);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
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
                child: BlocBuilder<UserCubit, UserState>(
                  bloc: GetIt.I(),
                  builder: (context, state) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.profilePage)
                                .then((value) => init()),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppTheme.colors.grayD4,
                              shape: BoxShape.circle),
                          child: ClipOval(
                            child:
                                state.user?.picture == Constants.defaultPicture
                                    ? Image.asset(
                                        Constants.defaultPicture,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          Constants.defaultPicture,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.file(
                                        File(state.user?.picture ?? ''),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          Constants.defaultPicture,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      SizedBox(width: mediaQuery.width * .07),
                      Expanded(
                        child: Text(
                          '$greeting ${state.user?.name ?? 'Usuário'}',
                          style: AppTheme.textStyles.titleTextStyle,
                        ),
                      ),
                    ],
                  ),
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
                      builder: (context, state) => Text(
                        'Resumo de ${state.currentMonth?.name ?? ''}',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                    ),
                    SizedBox(height: mediaQuery.height * .02),
                    Container(
                      padding: const EdgeInsets.all(18),
                      height: mediaQuery.height * .18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppTheme.colors.itemBackgroundColor,
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
                                        style: AppTheme
                                            .textStyles.subTileTextStyle),
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
                  ],
                ),
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
                    SizedBox(height: mediaQuery.height * .025),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _showAddBottomSheet(context),
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 5),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppTheme.colors.itemBackgroundColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_rounded,
                                    color: AppTheme.colors.hintColor,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Adicionar',
                                    style: AppTheme.textStyles.subTileTextStyle
                                        .copyWith(fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showListsBottomSheet(context),
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 5),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppTheme.colors.itemBackgroundColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.menu_rounded,
                                    color: AppTheme.colors.hintColor,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Listas',
                                    style: AppTheme.textStyles.subTileTextStyle
                                        .copyWith(fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.statsPage)
                                .then((value) => init()),
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 5),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppTheme.colors.itemBackgroundColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bar_chart_rounded,
                                    color: AppTheme.colors.hintColor,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Estatísticas',
                                    style: AppTheme.textStyles.subTileTextStyle
                                        .copyWith(fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
