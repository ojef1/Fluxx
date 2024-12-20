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
          color: AppTheme.colors.appBackgroundColor,
          boxShadow: const [
            BoxShadow(color: Colors.black, blurRadius: 2, offset: Offset(3, 3))
          ],
          border: const Border(
            left: BorderSide(
              color: Colors.red, // trocar pela cor de acordo com o gasto no mês
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
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
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
                        style: AppTheme.textStyles.accentTextStyle),
                    Expanded(
                      child: Text(
                          textAlign: TextAlign.end,
                          'R\$ ${formatPrice(
                            month.total ?? 0,
                          )}',
                          style: AppTheme.textStyles.accentTextStyle),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categoria com maior despesa:  ',
                        style: AppTheme.textStyles.accentTextStyle),
                    Expanded(
                      child: Text(
                          textAlign: TextAlign.end,
                          'R\$ ${formatPrice(
                            month.total ?? 0,
                          )}',
                          style: AppTheme.textStyles.accentTextStyle),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Receita mais usada:  ',
                        style: AppTheme.textStyles.accentTextStyle),
                    Expanded(
                      child: Text(
                          textAlign: TextAlign.end,
                          'R\$ ${formatPrice(
                            month.total ?? 0,
                          )}',
                          style: AppTheme.textStyles.accentTextStyle),
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
