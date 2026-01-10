import 'package:Fluxx/blocs/bills_cubit/bill_form_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/services/app_period_service.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MonthResumeData extends StatefulWidget {
  const MonthResumeData({super.key});

  @override
  State<MonthResumeData> createState() => _MonthResumeDataState();
}

class _MonthResumeDataState extends State<MonthResumeData> {
  late MonthModel currentMonth;

  @override
  void initState() {
    currentMonth = AppPeriodService().currentMonth;
    GetIt.I<ResumeCubit>().getTotalSpent(currentMonth.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return _ListenerWrapper(
      child: GestureDetector(
        onTap: () => goToBillStatsPage(context: context),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: Constants.topMargin),
          padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.width * .05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumo de ${currentMonth.name ?? ''}',
                style: AppTheme.textStyles.titleTextStyle,
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
                      builder: (context, state) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R\$${formatPrice(state.totalSpent)}',
                            style: AppTheme.textStyles.titleTextStyle,
                          ),
                          Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppTheme.colors.white,
                    size: 15,
                  ),
                        ],
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
                        '≈ ${state.percentSpent.toStringAsFixed(0)}% da receita total usada',
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
                                previous.totalRevenue != current.totalRevenue,
                            builder: (context, state) => Text(
                                'R\$${formatPrice(resumeState.totalSpent)} de R\$${formatPrice(state.totalRevenue)}',
                                style: AppTheme.textStyles.subTileTextStyle),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListenerWrapper extends StatelessWidget {
  final Widget child;
  const _ListenerWrapper({required this.child});

  void _recalcData() async {
    var currentMonth = AppPeriodService().currentMonth;
    await GetIt.I<ResumeCubit>().getTotalSpent(currentMonth.id!);
    var totalRevenues = await GetIt.I<RevenueCubit>().calculateTotalRevenues();
    await GetIt.I<ResumeCubit>().calculatePercent(totalRevenues);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<BillFormCubit, BillFormState>(
        bloc: GetIt.I(),
        listenWhen: (previous, current) =>
            previous.responseStatus != current.responseStatus,
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            _recalcData();
          }
        },
      ),
      BlocListener<RevenueCubit, RevenueState>(
        bloc: GetIt.I(),
        listenWhen: (previous, current) =>
            previous.totalRevenue != current.totalRevenue,
        listener: (context, state) {
          GetIt.I<ResumeCubit>().calculatePercent(state.totalRevenue);
        },
      ),
    ], child: child);
  }
}
