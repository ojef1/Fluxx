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
    double percent = 0.4;
    Color percentColor = percent <= 0.4
        ? Colors.green
        : percent <= 0.7
            ? Colors.amber
            : Colors.red;
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    '${item.name}',
                    style: AppTheme.textStyles.subTileTextStyle,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'R\$ ${item.value}',
                    style: AppTheme.textStyles.subTileTextStyle,
                  ),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    barRadius: const Radius.circular(50),
                    lineHeight: 15,
                    //FIXME colocar o valor de acordo com o calculo = renda total - total gasto
                    percent: percent,
                    //FIXME colocar as cores de acordo com a porcentagem
                    //TODO definir limiares de porcetagem para mudar de cor
                    progressColor: percentColor,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: mediaQuery.width * .01,
                    top: mediaQuery.width * .01,
                  ),
                  height: 1,
                  color: AppTheme.colors.accentColor,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.isPublic == 1 ? 'Público' : 'Privado',
                        style: AppTheme.textStyles.subTileTextStyle,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
