import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/components/auto_marquee_text.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsCategoryItem extends StatelessWidget {
  final CategoryModel statsItem;
  const StatsCategoryItem({
    super.key,
    required this.statsItem,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      padding: EdgeInsets.symmetric(
        vertical: mediaQuery.height * .02,
        horizontal: mediaQuery.width * .04,
      ),
      width: mediaQuery.width * .65,
      height: 20,
      decoration: BoxDecoration(
        color: AppTheme.colors.itemBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 20,
        children: [
          BlocBuilder<ResumeCubit, ResumeState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) =>
                previous.totalSpent != current.totalSpent,
            builder: (context, state) {
              var totalSpent = state.totalSpent;
              double percentage =
                  (totalSpent > 0) ? statsItem.price! / totalSpent : 0;
              return SizedBox(
                width: 100,
                height: 100,
                child: FittedBox(
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 13.0,
                    animation: true,
                    reverse: true,
                    percent: percentage.clamp(0.0, 1),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppTheme.colors.hintColor,
                    backgroundColor: AppTheme.colors.lightHintColor,
                    center: Text(
                      '${(percentage * 100).toStringAsFixed(0)}%',
                      style: AppTheme.textStyles.subTileTextStyle.copyWith(fontSize: AppTheme.fontSizes.large),
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 20,
                  child: AutoMarqueeText(
                    text: statsItem.categoryName ?? '',
                    style: AppTheme.textStyles.subTileTextStyle,
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
          ),
        ],
      ),
    );
  }
}
