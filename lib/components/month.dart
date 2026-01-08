
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Month extends StatelessWidget {
  final MonthModel month;
  const Month({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        GetIt.I<ResumeCubit>().updateMonthInFocus(month);
        Navigator.pushNamed(context, AppRoutes.monthBillsPage);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: mediaQuery.height * .01,
          horizontal: mediaQuery.width * .05,
        ),
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.height * .01,
          horizontal: mediaQuery.width * .05,
        ),
        width: mediaQuery.width * .7,
        height: mediaQuery.height * .2,
        decoration: BoxDecoration(
          color: AppTheme.colors.itemBackgroundColor,
          boxShadow: const [
            BoxShadow(color: Colors.black, blurRadius: 1, offset: Offset(3, 3))
          ],
          border: Border(
            left: BorderSide(
              color: AppTheme.colors.hintColor,
              width: 10,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(month.name ?? '',
                    style: AppTheme.textStyles.titleTextStyle),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.colors.hintColor,
                  size: 17,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total gasto:  ',
                        style: AppTheme.textStyles.descTextStyle.copyWith(color: AppTheme.colors.hintTextColor)),
                    Expanded(
                      child: Text(
                          textAlign: TextAlign.end,
                          'R\$ ${formatPrice(
                            month.total ?? 0,
                          )}',
                          style: AppTheme.textStyles.descTextStyle.copyWith(color: AppTheme.colors.hintTextColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categoria de maior despesa:  ',
                        style: AppTheme.textStyles.descTextStyle.copyWith(color: AppTheme.colors.hintTextColor)),
                    Expanded(
                      child: Text(
                          textAlign: TextAlign.end,
                          month.categoryMostUsed ?? 'N.A',
                          style: AppTheme.textStyles.descTextStyle.copyWith(color: AppTheme.colors.hintTextColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Receita mais usada:  ',
                        style: AppTheme.textStyles.descTextStyle.copyWith(color: AppTheme.colors.hintTextColor)),
                    Expanded(
                      child: Text(
                          textAlign: TextAlign.end,
                          month.revenueMostUsed ?? 'N.A',
                          style: AppTheme.textStyles.descTextStyle.copyWith(color: AppTheme.colors.hintTextColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
