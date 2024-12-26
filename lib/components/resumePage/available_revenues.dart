import 'package:Fluxx/blocs/revenue_bloc/revenue_bloc.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_state.dart';
import 'package:Fluxx/components/revenue_item.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class AvailableRevenues extends StatefulWidget {
  const AvailableRevenues({super.key});

  @override
  State<AvailableRevenues> createState() => _AvailableRevenuesState();
}

class _AvailableRevenuesState extends State<AvailableRevenues> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width * .05,
            ),
            child: Text(
              'Receitas Disponíveis',
              style: AppTheme.textStyles.titleTextStyle,
            ),
          ),
          SizedBox(height: mediaQuery.height * .02),
          BlocBuilder<RevenueCubit, RevenueState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) =>
                previous.getRevenueResponse != current.getRevenueResponse,
            builder: (context, state) {
              if (state.getRevenueResponse == GetRevenueResponse.loading) {
                return SizedBox(
                  height: mediaQuery.height * .3,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisExtent: mediaQuery.width * .5,
                    ),
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width * .02,
                        ),
                        height: mediaQuery.height * .12,
                        width: mediaQuery.width * .4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 16,
                                  width: mediaQuery.width * .2,
                                  color: Colors.grey[300],
                                ),
                                const Icon(Icons.access_time_rounded),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: mediaQuery.height * .01),
                                Container(
                                  height: 16,
                                  width: mediaQuery.width * .3,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: mediaQuery.height * .01),
                                Container(
                                  height: 15,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
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
                          onPressed: () =>
                              GetIt.I<RevenueCubit>().getPublicRevenue(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colors.accentColor,
                            minimumSize: const Size(50, 50),
                          ),
                          child: Text('Tentar novamente',
                              style: AppTheme.textStyles.bodyTextStyle),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state.getRevenueResponse ==
                  GetRevenueResponse.success) {
                return SizedBox(
                  height: mediaQuery.height * .3,
                  child: Center(
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.revenuesList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisExtent: mediaQuery.width * .5,
                      ),
                      itemBuilder: (context, index) => RevenueItem(
                        item: state.revenuesList[index],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
