import 'package:Fluxx/models/chart_category_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsItem extends StatelessWidget {
  final StatsCategoryModel statsItem;
  final double totalSpent;
  const StatsItem(
      {super.key, required this.statsItem, required this.totalSpent});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    double percentage = (totalSpent > 0) ? statsItem.price! / totalSpent : 0;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: mediaQuery.height * .03,
        horizontal: mediaQuery.width * .05,
      ),
      padding: EdgeInsets.only(
        top: mediaQuery.height * .01,
        bottom: mediaQuery.height * .03,
        left: mediaQuery.width * .05,
        right: mediaQuery.width * .08,
      ),
      // width: mediaQuery.width * .5,
      height: mediaQuery.height * .15,
      decoration: BoxDecoration(
        gradient: AppTheme.colors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Constants.categoriesIcons[statsItem.categoryName],
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 100,
                  height: 100,
                  child: FittedBox(
                    child: CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: percentage.clamp(0.0, 1),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.purple,
                      backgroundColor: Colors.white,
                      center: Text(
                        '${(percentage * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text(
                        statsItem.categoryName ?? '',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                    ),
                    Text(
                      'R\$ ${formatPrice(statsItem.price ?? 0)}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.textStyles.titleTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
