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
          horizontal: mediaQuery.width * .01,
          vertical: mediaQuery.width * .01,
        ),
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.height * .01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        height: mediaQuery.height * .09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.attach_money_rounded,
                  size: 30,
                  color: Colors.black,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatPrice(bill.price ?? 0.0),
                      style: AppTheme.textStyles.tileTextStyle,
                    ),
                    Text(
                      bill.name ?? '',
                      style: AppTheme.textStyles.subTileTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Status(isPayed: bill.isPayed ?? 0),
                const Icon(Icons.navigate_next_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
