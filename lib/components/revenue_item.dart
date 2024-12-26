import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RevenueItem extends StatelessWidget {
  final RevenueModel item;
  const RevenueItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(
        context,
        AppRoutes.addRevenuePage,
        arguments: item,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(
          horizontal: mediaQuery.width * .02,
        ),
        height: mediaQuery.height * .12,
        width: mediaQuery.width * .4,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${item.name}',
                    style: AppTheme.textStyles.subTileTextStyle,
                  ),
                ),
                
                Icon(
                  item.isPublic == 1
                      ? Icons.public_rounded
                      : Icons.access_time_rounded,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'R\$ ${item.value}',
                  style: AppTheme.textStyles.subTileTextStyle,
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
    );
  }
}
