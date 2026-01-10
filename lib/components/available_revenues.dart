import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/blocs/revenue_form_cubit/revenue_form_cubit.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_revenue_list.dart';
import 'package:Fluxx/components/revenue_item.dart';
import 'package:Fluxx/services/app_period_service.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AvailableRevenues extends StatefulWidget {
  const AvailableRevenues({super.key});

  @override
  State<AvailableRevenues> createState() => _AvailableRevenuesState();
}

class _AvailableRevenuesState extends State<AvailableRevenues> {
  @override
  void initState() {
    var currentMonth = AppPeriodService().currentMonth;
    GetIt.I<RevenueCubit>().getRevenues(currentMonth.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return _ListenerWrapper(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * .05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receitas Disponíveis',
                    style: AppTheme.textStyles.titleTextStyle,
                  ),
                ],
              ),
            ),
            SizedBox(height: mediaQuery.height * .02),
            BlocBuilder<RevenueCubit, RevenueState>(
              bloc: GetIt.I(),
              buildWhen: (previous, current) =>
                  previous.getRevenueResponse != current.getRevenueResponse,
              builder: (context, state) {
                switch (state.getRevenueResponse) {
                  case GetRevenueResponse.initial:
                  case GetRevenueResponse.loading:
                    return const SizedBox();
                  case GetRevenueResponse.error:
                    return Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Erro ao carregar as receitas!',
                              style: AppTheme.textStyles.subTileTextStyle,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () =>
                                  GetIt.I<RevenueCubit>().getRevenues(
                                AppPeriodService().currentMonth.id!,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.colors.hintColor,
                                minimumSize: const Size(50, 50),
                              ),
                              child: Text('Tentar novamente',
                                  style: AppTheme.textStyles.bodyTextStyle),
                            ),
                          ],
                        ),
                      ),
                    );
                  case GetRevenueResponse.success:
                    if (state.availableRevenues.isEmpty) {
                      return EmptyRevenueList(
                        onPressed: () => goToRevenueForm(context: context),
                      );
                    } else {
                      return const _AvailableRevenuesContent();
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailableRevenuesContent extends StatelessWidget {
  const _AvailableRevenuesContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueCubit, RevenueState>(
        bloc: GetIt.I(),
        buildWhen: (previous, current) =>
            previous.availableRevenues != current.availableRevenues,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: ListView.builder(
                itemCount: state.availableRevenues.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var valorDaLista = state.revenuesList[index].value!;
                  var valorDisponivel = state.availableRevenues[index].value!;
                  double totalPercent =
                      _calcPercent(valorDaLista, valorDisponivel);
                  if (totalPercent == 0.0) {
                    return const SizedBox();
                  } else {
                    return RevenueItem(
                      item: state.availableRevenues[index],
                      totalPercent: totalPercent,
                      value: state.availableRevenues[index].value ?? 0.0,
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  double _calcPercent(double valorDaLista, double valorDisponivel) {
    if (valorDaLista != 0.0) {
      return (valorDisponivel / valorDaLista).clamp(0.0, 1.0);
    } else {
      return 0.0;
    }
  }
}

class _ListenerWrapper extends StatelessWidget {
  final Widget child;
  const _ListenerWrapper({required this.child});

  void _getRevenues() {
    var currentMonth = AppPeriodService().currentMonth;
    GetIt.I<RevenueCubit>().getRevenues(currentMonth.id!);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<RevenueFormCubit, RevenueFormState>(
        bloc: GetIt.I(),
        listenWhen: (previous, current) => previous.responseStatus != current.responseStatus,
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            _getRevenues();
          }
        },
      ),
    ], child: child);
  }
}
