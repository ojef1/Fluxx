import 'package:Fluxx/components/status.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';

class BillItem extends StatelessWidget {
  final BillModel bill;
  const BillItem({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.editBillPage,
        arguments: bill,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: mediaQuery.width * .05,
          vertical: mediaQuery.width * .01,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.colors.accentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: mediaQuery.height * .2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bill.name ?? '',
                    style: AppTheme.textStyles.bodyTextStyle,
                  ),
                ),
                Icon(
                  bill.isPayed == 1
                      ? Icons.check_circle_outline_rounded
                      : Icons.cancel_outlined,
                  color: bill.isPayed == 1 ? Colors.green : Colors.red,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categoria: ',
                  style: AppTheme.textStyles.bodyTextStyle,
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    '{categoria da conta} ',
                    style: AppTheme.textStyles.bodyTextStyle,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Renda Usada: ',
                  style: AppTheme.textStyles.bodyTextStyle,
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    '{renda usada} ',
                    style: AppTheme.textStyles.bodyTextStyle,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: mediaQuery.width * .02,
                bottom: mediaQuery.width * .02,
              ),
              height: 1,
              color: AppTheme.colors.grayD4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '{data da conta}',
                    style: AppTheme.textStyles.bodyTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    formatPrice(bill.price ?? 0.0),
                    style: AppTheme.textStyles.bodyTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
