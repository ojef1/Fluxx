import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class MonthStatistic extends StatelessWidget {
  final String title;
  final String statistic;
  const MonthStatistic(
      {super.key, required this.title, required this.statistic});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: mediaQuery.width * .03),
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.height * .02,
      ),
      height: mediaQuery.height * .06,
      decoration: BoxDecoration(
        gradient: AppTheme.colors.primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: AppTheme.textStyles.titleTextStyle,
          ),
          Expanded(
            child: Text(
              statistic,
              textAlign: TextAlign.center,
              style: AppTheme.textStyles.titleTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
