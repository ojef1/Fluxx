import 'dart:io';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/blocs/user_cubit/user_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_state.dart';
import 'package:Fluxx/components/Invoice_due_soon_widget.dart';
import 'package:Fluxx/components/available_revenues.dart';
import 'package:Fluxx/components/quick_access_widget.dart';
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
    await GetIt.I<RevenueCubit>().getRevenues(actualMonth.id!);
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
            spacing: 20,
            children: [
              //AppBar
              Container(
                margin: const EdgeInsets.only(top: Constants.topMargin),
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width * .05,
                ),
                child: BlocBuilder<UserCubit, UserState>(
                  bloc: GetIt.I(),
                  builder: (context, state) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.profilePage,
                    ).then(
                      (value) => init(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
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
                            buildWhen: (previous, current) =>
                                previous.totalSpent != current.totalSpent,
                            builder: (context, state) => Text(
                              'R\$${formatPrice(state.totalSpent)}',
                              style: AppTheme.textStyles.titleTextStyle,
                            ),
                          ),
                          BlocBuilder<ResumeCubit, ResumeState>(
                            bloc: GetIt.I(),
                            buildWhen: (previous, current) =>
                                previous.percentSpent != current.percentSpent,
                            builder: (context, state) {
                              final percent =
                                  (state.percentSpent / 100).clamp(0.0, 1.0);
                              final extrapolated = state.percentSpent > 100.0;
                              return LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                barRadius: const Radius.circular(50),
                                lineHeight: 20,
                                percent: percent,
                                progressColor: extrapolated
                                    ? AppTheme.colors.red
                                    : AppTheme.colors.hintColor,
                                backgroundColor: AppTheme.colors.lightHintColor,
                              );
                            },
                          ),
                          BlocBuilder<ResumeCubit, ResumeState>(
                            bloc: GetIt.I(),
                            buildWhen: (previous, current) =>
                                previous.percentSpent != current.percentSpent,
                            builder: (context, state) => Text(
                              '${state.percentSpent.toStringAsFixed(0)}% da receita total usada',
                              style: AppTheme.textStyles.subTileTextStyle,
                            ),
                          ),
                          BlocBuilder<ResumeCubit, ResumeState>(
                              bloc: GetIt.I(),
                              buildWhen: (previous, current) =>
                                  previous.totalSpent != current.totalSpent,
                              builder: (context, resumeState) {
                                return BlocBuilder<RevenueCubit, RevenueState>(
                                  bloc: GetIt.I(),
                                  buildWhen: (previous, current) =>
                                      previous.totalRevenue !=
                                      current.totalRevenue,
                                  builder: (context, state) => Text(
                                      'R\$${formatPrice(resumeState.totalSpent)} de R\$${formatPrice(state.totalRevenue)}',
                                      style:
                                          AppTheme.textStyles.subTileTextStyle),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //Acesso Rápido
              const SizedBox(
                height: 80,
                child: QuickAccessWidget(),
              ),
              //Fatura mais próxima de fechar
              const InvoiceDueSoonWidget(),
              //Receitas Disponíveis
              const AvailableRevenues()
            ],
          ),
        ),
      ),
    );
  }
}
