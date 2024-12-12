import 'package:Fluxx/blocs/month_detail_bloc/month_detail_cubit.dart';
import 'package:Fluxx/blocs/month_detail_bloc/month_detail_state.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/stats_item.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    final state = GetIt.I<MonthsDetailCubit>().state;
    GetIt.I<MonthsDetailCubit>().getStats(state.monthInFocus?.id ?? 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.colors.backgroundColor),
          height: mediaQuery.height,
          child: BlocBuilder<MonthsDetailCubit, MonthsDetailState>(
            bloc: GetIt.I(),
            builder: (context, state) {
              if (state.getStatsResponse == GetStatsResponse.loaging) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.getStatsResponse == GetStatsResponse.error) {
                return Column(
                  children: [
                    CustomAppBar(
                      title: 'Estatísticas',
                      firstIcon: Icons.arrow_back_rounded,
                      firstIconSize: 25,
                      functionIcon: Icons.warning_rounded,
                      firstFunction: () => Navigator.pop(context),
                      secondFunction: () {},
                    ),
                    const Expanded(
                        child: Center(
                            child: Text('Erro ao carregar as Estatísticas.'))),
                  ],
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(
                    top: mediaQuery.height * .06,
                    bottom: mediaQuery.height * .02,
                    left: mediaQuery.width * .04,
                    right: mediaQuery.width * .04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(
                        title: 'Estatísticas',
                        firstIcon: Icons.arrow_back_rounded,
                        firstIconSize: 25,
                        functionIcon: Icons.info_rounded,
                        firstFunction: () => Navigator.pop(context),
                        secondFunction: () => _showDialog(context),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.stats.length,
                          itemBuilder: (context, index) {
                            return StatsItem(
                              statsItem: state.stats[index],
                              totalSpent: state.monthTotalSpent,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>  AlertDialog(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Informação sobre os Cálculos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.info_outline, color: Colors.blue),
          ],
        ),
        content: const Text(
          'Os valores de porcentagem apresentados são baseados no valor total de todos os gastos do mês.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Entendi',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
