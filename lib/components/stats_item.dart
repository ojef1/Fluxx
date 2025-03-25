import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsItem extends StatelessWidget {
  final CategoryModel statsItem;
  final double totalSpent;
  const StatsItem(
      {super.key, required this.statsItem, required this.totalSpent});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    double percentage = (totalSpent > 0) ? statsItem.price! / totalSpent : 0;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: mediaQuery.height * .01,
        horizontal: mediaQuery.width * .02,
      ),
      width: mediaQuery.width * .28,
      height: mediaQuery.height * .2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            statsItem.categoryName ?? '',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.textStyles.subTileTextStyle,
          ),
          SizedBox(
            width:  80,
            height:        80,
            child: FittedBox(
              child: CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 13.0,
                animation: true,
                percent: percentage.clamp(0.0, 1),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.purple,
                backgroundColor: Colors.black,
                center: Text(
                  '${(percentage * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Text(
            'R\$ ${formatPrice(statsItem.price ?? 0)}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.textStyles.subTileTextStyle,
          ),
        ],
      ),
    );
  }
}
