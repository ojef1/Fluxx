import 'package:Fluxx/blocs/bill_list_bloc/bill_list_cubit.dart';
import 'package:Fluxx/blocs/bill_list_bloc/bill_list_state.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/stats_item.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final ScrollController _pageScrollController;
  @override
  void initState() {
    _pageScrollController = ScrollController();
    // final state = GetIt.I<MonthsDetailCubit>().state;
    // GetIt.I<MonthsDetailCubit>().getStats(state.monthInFocus?.id ?? 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
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
                      CircleAvatar(
                        backgroundColor: AppTheme.colors.grayD4,
                        child: IconButton(
                            color: Colors.black,
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_rounded)),
                      ),
                      SizedBox(width: mediaQuery.width * .2),
                      Text(
                        'Estatísticas',
                        style: AppTheme.textStyles.titleTextStyle,
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
                      Container(
                        padding: const EdgeInsets.all(18),
                        height: mediaQuery.height * .16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
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
                                    Text(
                                      //FIXME colocar o valor de gasto total
                                      'R\$ 00,00',
                                      style:
                                          AppTheme.textStyles.subTileTextStyle,
                                    ),
                                    Text(
                                      //FIXME colocar o valor total disponível
                                      'R\$ 00,00',
                                      style:
                                          AppTheme.textStyles.subTileTextStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(height: mediaQuery.height * .01),
                                LinearPercentIndicator(
                                  padding: EdgeInsets.zero,
                                  barRadius: const Radius.circular(50),
                                  lineHeight: 15,
                                  //FIXME colocar o valor de acordo com o calculo = renda total - total gasto
                                  percent: 0.7,
                                  //FIXME colocar as cores de acordo com a porcentagem
                                  //TODO definir limiares de porcetagem para mudar de cor
                                  progressColor: Colors.amber,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: mediaQuery.height * .01),
                      Text('Receita Total Restante : \${R\$ 00,00}',
                          style: AppTheme.textStyles.subTileTextStyle),
                      SizedBox(height: mediaQuery.height * .01),
                      Text('Total de Contas : 535',
                          style: AppTheme.textStyles.subTileTextStyle),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Despesas por Categoria',
                            style: AppTheme.textStyles.subTileTextStyle,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_alt_rounded))
                        ],
                      ),

                      SizedBox(height: mediaQuery.height * .01),
                      SizedBox(
                        height: mediaQuery.height * .22,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                // itemCount: state.stats.length,
                                itemCount: 8,
                                itemBuilder: (context, index) {
                                  return StatsItem(
                                    // statsItem: state.stats[index],
                                    // totalSpent: state.monthTotalSpent,
                                    statsItem: CategoryModel(
                                        categoryName: 'casa', price: 20.00),
                                    totalSpent: 20.00,
                                  );
                                },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Receitas Disponíveis',
                            style: AppTheme.textStyles.subTileTextStyle,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_alt_rounded))
                        ],
                      ),
                      SizedBox(
                        height: mediaQuery.height * .3,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              6, //FIXME colocar o valor de acordo com a quantidade de receitas
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisExtent: mediaQuery.width * .5,
                          ),
                          itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.all(12),
                            margin: EdgeInsets.symmetric(
                              horizontal: mediaQuery.width * .02,
                            ),
                            height: mediaQuery.height * .12,
                            width: mediaQuery.width * .4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      //FIXME colocar o valor de gasto total
                                      'Salário',
                                      style:
                                          AppTheme.textStyles.subTileTextStyle,
                                    ),
                                    //FIXME colocar o icone de acordo com o tipo de receita (fixa ou específica)
                                    const Icon(Icons.access_time_rounded)
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      //FIXME colocar o valor total disponível
                                      'R\$ 00,00',
                                      style:
                                          AppTheme.textStyles.subTileTextStyle,
                                    ),
                                    SizedBox(height: mediaQuery.height * .01),
                                    LinearPercentIndicator(
                                      padding: EdgeInsets.zero,
                                      barRadius: const Radius.circular(50),
                                      lineHeight: 15,
                                      //FIXME colocar o valor de acordo com o calculo = renda total - total gasto
                                      percent: 0.7,
                                      //FIXME colocar as cores de acordo com a porcentagem
                                      //TODO definir limiares de porcetagem para mudar de cor
                                      progressColor: Colors.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(gradient: AppTheme.colors.backgroundColor),
        //   height: mediaQuery.height,
        //   child: BlocBuilder<MonthsDetailCubit, MonthsDetailState>(
        //     bloc: GetIt.I(),
        //     builder: (context, state) {
        //       if (state.getStatsResponse == GetStatsResponse.loaging) {
        //         return const Center(child: CircularProgressIndicator());
        //       } else if (state.getStatsResponse == GetStatsResponse.error) {
        //         return Column(
        //           children: [
        //             CustomAppBar(
        //               title: 'Estatísticas',
        //               firstIcon: Icons.arrow_back_rounded,
        //               firstIconSize: 25,
        //               functionIcon: Icons.warning_rounded,
        //               firstFunction: () => Navigator.pop(context),
        //               secondFunction: () {},
        //             ),
        //             const Expanded(
        //                 child: Center(
        //                     child: Text('Erro ao carregar as Estatísticas.'))),
        //           ],
        //         );
        //       } else {
        //         return Container(
        //           margin: EdgeInsets.only(
        //             top: mediaQuery.height * .06,
        //             bottom: mediaQuery.height * .02,
        //             left: mediaQuery.width * .04,
        //             right: mediaQuery.width * .04,
        //           ),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               CustomAppBar(
        //                 title: 'Estatísticas',
        //                 firstIcon: Icons.arrow_back_rounded,
        //                 firstIconSize: 25,
        //                 functionIcon: Icons.info_rounded,
        //                 firstFunction: () => Navigator.pop(context),
        //                 secondFunction: () => _showDialog(context),
        //               ),
        //               Expanded(
        //                 child: ListView.builder(
        //                   itemCount: state.stats.length,
        //                   itemBuilder: (context, index) {
        //                     return StatsItem(
        //                       statsItem: state.stats[index],
        //                       totalSpent: state.monthTotalSpent,
        //                     );
        //                   },
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       }
        //     },
        //   ),
        // ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
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
