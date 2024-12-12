import 'package:Fluxx/blocs/month_detail_bloc/month_detail_cubit.dart';
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
        GetIt.I<MonthsDetailCubit>().updateMonthInFocus(month);
        Navigator.pushReplacementNamed(context, AppRoutes.detailPage);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: mediaQuery.height * .03,
          horizontal: mediaQuery.width * .1,
        ),
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.height * .03,
          horizontal: mediaQuery.width * .08,
        ),
        width: mediaQuery.width * .7,
        height: mediaQuery.height * .15,
        decoration: BoxDecoration(
          gradient: AppTheme.colors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.today,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: mediaQuery.width * .02,
                    ),
                    Text(month.name ?? '', style: AppTheme.textStyles.titleTextStyle),
                  ],
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
            Text('R\$ ${formatPrice(month.total ?? 0)}', style: AppTheme.textStyles.titleTextStyle)
          ],
        ),
      ),
    );
  }
}
