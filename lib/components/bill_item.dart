import 'package:Fluxx/blocs/bill_cubit/bill_cubit.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BillItem extends StatelessWidget {
  final BillModel bill;
  const BillItem({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.detailBillPage,
        );
        GetIt.I<BillCubit>().getBill(bill.id!, bill.monthId!);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: mediaQuery.width * .05,
          vertical: mediaQuery.width * .01,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.colors.itemBackgroundColor,
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
                    style: AppTheme.textStyles.titleTextStyle,
                  ),
                ),
                Icon(
                  bill.isPayed == 1 ? Icons.check_circle : Icons.cancel,
                  color: bill.isPayed == 1 ? Colors.green : Colors.red,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.category,
                      color: Colors.white ,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Categoria: ',
                      style: AppTheme.textStyles.bodyTextStyle,
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    '${bill.categoryName} ',
                    style: AppTheme.textStyles.bodyTextStyle,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on_outlined,
                      color: Colors.white ,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Receita Usada: ',
                      style: AppTheme.textStyles.bodyTextStyle,
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    '${bill.paymentName} ',
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
                    formatDate(bill.paymentDate) ?? '',
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
