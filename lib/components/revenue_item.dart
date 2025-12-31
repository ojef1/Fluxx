import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RevenueItem extends StatelessWidget {
  final RevenueModel item;
  final double totalPercent;
  final double value;
  const RevenueItem(
      {super.key, required this.item, required this.totalPercent, required this.value});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(
        horizontal: mediaQuery.width * .02,
        vertical: mediaQuery.height * .01,
      ),
      height: mediaQuery.height * .12,
      decoration: BoxDecoration(
          color: AppTheme.colors.itemBackgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                textAlign: TextAlign.center,
                '${item.name}',
                style: AppTheme.textStyles.subTileTextStyle,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  barRadius: const Radius.circular(50),
                  lineHeight: 15,
                  percent: totalPercent,
                  progressColor: AppTheme.colors.hintColor,
                  backgroundColor: AppTheme.colors.lightHintColor,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                textAlign: TextAlign.center,
                '${(totalPercent * 100).toStringAsFixed(0)}%',
                style: AppTheme.textStyles.subTileTextStyle,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textAlign: TextAlign.center,
                'R\$${formatPrice(value)}',
                style: AppTheme.textStyles.subTileTextStyle,
              ),
              Text(
                item.isMonthly == 1 ? 'Receita Mensal' : 'Receita Única',
                style: AppTheme.textStyles.subTileTextStyle,
              )
            ],
          ),
        ],
      ),
    );
  }
}
