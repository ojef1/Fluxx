import 'package:Fluxx/blocs/credit_card_cubits/credit_card_info_cubit.dart';
import 'package:Fluxx/components/bottom_sheets/credit_card_info_bottomsheet.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CreditCardStatsPage extends StatefulWidget {
  const CreditCardStatsPage({super.key});

  @override
  State<CreditCardStatsPage> createState() => _CreditCardStatsPageState();
}

class _CreditCardStatsPageState extends State<CreditCardStatsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) Navigator.pop(context);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width * .05,
                  vertical: mediaQuery.height * .03),
              child: BlocBuilder<CreditCardInfoCubit, CreditCardInfoState>(
                bloc: GetIt.I(),
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  switch (state.status) {
                    case ResponseStatus.initial:
                    case ResponseStatus.loading:
                      return const CustomLoading();
                    case ResponseStatus.error:
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Center(
                            child: Text('Erro ao carregar as estísticas.')),
                      );
                    case ResponseStatus.success:
                      return const _StatsPageContent();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsPageContent extends StatefulWidget {
  const _StatsPageContent();

  @override
  State<_StatsPageContent> createState() => _StatsPageContentState();
}

class _StatsPageContentState extends State<_StatsPageContent> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    double boxHeight = mediaQuery.height * .15;
    return Column(
      spacing: 18,
      children: [
        BlocBuilder<CreditCardInfoCubit, CreditCardInfoState>(
          bloc: GetIt.I(),
          buildWhen: (previous, current) =>
              previous.recommendedSpending != current.recommendedSpending,
          builder: (context, state) {
            return GestureDetector(
              onTap: () => _showInfo(InfoCardType.recommendedSpending),
              child: Container(
                padding: const EdgeInsets.all(18),
                height: boxHeight,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gasto máximo recomendado',
                          style: AppTheme.textStyles.bodyTextStyle,
                        ),
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppTheme.colors.white,
                        ),
                      ],
                    ),
                    Text(
                      'R\$${formatPrice(state.recommendedSpending)}',
                      style: AppTheme.textStyles.titleTextStyle,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        BlocBuilder<CreditCardInfoCubit, CreditCardInfoState>(
          bloc: GetIt.I(),
          buildWhen: (previous, current) => previous.invoice != current.invoice,
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(18),
              height: boxHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppTheme.colors.itemBackgroundColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    barRadius: const Radius.circular(50),
                    lineHeight: 15,
                    percent: calcPercentSpent(
                      totalLimit: state.card?.creditLimit ?? 0.0,
                      totalSpent: state.invoice?.price ?? 0.0,
                    ),
                    progressColor: AppTheme.colors.hintColor,
                    backgroundColor: AppTheme.colors.lightHintColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$${formatPrice(
                          state.invoice?.price ?? 0.0,
                        )}',
                        style: AppTheme.textStyles.bodyTextStyle,
                      ),
                      Text(
                        'R\$${formatPrice(
                          calcRemainingLimit(
                            totalLimit: state.card?.creditLimit ?? 0.0,
                            totalSpent: state.invoice?.price ?? 0.0,
                          ),
                        )}',
                        style: AppTheme.textStyles.bodyTextStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Utilizado',
                        style: AppTheme.textStyles.secondaryTextStyle,
                      ),
                      Text(
                        'Disponível',
                        style: AppTheme.textStyles.secondaryTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        BlocBuilder<CreditCardInfoCubit, CreditCardInfoState>(
          bloc: GetIt.I(),
          buildWhen: (previous, current) => previous.invoice != current.invoice,
          builder: (context, state) {
            var formatted = DateTime.parse(state.invoice?.endDate ?? '');
            return GestureDetector(
              onTap: () => goToInvoiceBillPage(context: context, invoice: state.invoice!),
              child: Container(
                padding: const EdgeInsets.all(18),
                height: boxHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppTheme.colors.itemBackgroundColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fatura de ${getMonthName(formatted)}',
                          style: AppTheme.textStyles.bodyTextStyle,
                        ),
                        Text(
                          getInvoiceStatus(
                            endDate: state.invoice?.endDate ?? '',
                            dueDay: int.parse(state.invoice?.dueDate ?? '0'),
                            isPaid: state.invoice?.isPaid == 1,
                          ),
                          style: AppTheme.textStyles.secondaryTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'R\$${formatPrice(
                            state.invoice?.price ?? 0.0,
                          )}',
                          style: AppTheme.textStyles.titleTextStyle,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppTheme.colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${state.invoiceBillsLength} compras nessa fatura',
                          style: AppTheme.textStyles.secondaryTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
        BlocBuilder<CreditCardInfoCubit, CreditCardInfoState>(
          bloc: GetIt.I(),
          buildWhen: (previous, current) =>
              previous.revenueImpairment != current.revenueImpairment,
          builder: (context, state) {
            return GestureDetector(
              onTap: () => _showInfo(InfoCardType.revenueImpairment),
              child: Container(
                padding: const EdgeInsets.all(18),
                height: boxHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.colors.itemBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comprometimento da receita',
                          style: AppTheme.textStyles.bodyTextStyle,
                        ),
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppTheme.colors.white,
                        ),
                      ],
                    ),
                    Text(
                      '${state.revenueImpairment.toStringAsFixed(0)}%',
                      style: AppTheme.textStyles.titleTextStyle,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showInfo(InfoCardType type) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CreditCardInfoBottomsheet(
        type: type,
      ),
    );
  }
}
