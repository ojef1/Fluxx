import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_revenue_list.dart';
import 'package:Fluxx/components/revenue_item.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/services/app_period_service.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class StatsRevenues extends StatelessWidget {
  const StatsRevenues({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueCubit, RevenueState>(
      bloc: GetIt.I(),
      buildWhen: (previous, current) =>
          previous.getRevenueResponse != current.getRevenueResponse ||
          previous.availableRevenues != current.availableRevenues,
      builder: (context, state) {
        if (state.getRevenueResponse == GetRevenueResponse.loading) {
          return const SizedBox();
        } else if (state.getRevenueResponse == GetRevenueResponse.error) {
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
                    onPressed: () => GetIt.I<RevenueCubit>().getRevenues(
                        AppPeriodService().currentMonth.id!),
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
        } else if (state.getRevenueResponse == GetRevenueResponse.success) {
          if (state.availableRevenues.isEmpty) {
            return EmptyRevenueList(onPressed: () {
              RevenueModel revenue = RevenueModel();
              Navigator.pushNamed(context, AppRoutes.revenueFormPage,
                  arguments: revenue);
            });
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: ListView.builder(
                  itemCount: state.availableRevenues.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var valorDaLista = state.revenuesList[index].value!;
                    var valorDisponivel = state.availableRevenues[index].value!;
                    var valorGasto = valorDaLista - valorDisponivel;
                    double totalPercent =
                        _calcPercent(valorDaLista, valorGasto);

                    return RevenueItem(
                        item: state.revenuesList[index],
                        totalPercent: totalPercent,
                        value: valorGasto);
                  },
                ),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  double _calcPercent(double valorDaLista, double valorGasto) {
    if (valorGasto != 0.0) {
      return (valorGasto / valorDaLista).clamp(0.0, 1.0);
    } else {
      return 0.0;
    }
  }
}
