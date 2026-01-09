import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';

class QuickAccessWidget extends StatefulWidget {
  const QuickAccessWidget({super.key});

  @override
  State<QuickAccessWidget> createState() => _QuickAccessWidgetState();
}

class _QuickAccessWidgetState extends State<QuickAccessWidget> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> get _quickAccessList {
    List<Widget> items = [
      _QuickAccessItem(
        () => goToMonthBillsPage(context: context),
        'Contas',
        Icons.receipt_long_rounded,
      ),
      _QuickAccessItem(
        () => goToCardsListPage(context: context),
        'Cartões',
        Icons.credit_card_rounded,
      ),
      _QuickAccessItem(
        () => goToMonthListPage(context: context),
        'Meses',
        Icons.calendar_month_rounded,
      ),
      _QuickAccessItem(
        () => goToCategoryListPage(context: context),
        'Categorias',
        Icons.category_outlined,
      ),
      _QuickAccessItem(
        () => goToRevenuesListPage(context: context),
        'Receitas',
        Icons.attach_money_rounded,
      ),
    ];
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _quickAccessList.length,
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemBuilder: (context, index) {
        return Row(
          children: [
            if (index == 0)
              SizedBox(
                width: mediaQuery.width * .05,
              ),
            _quickAccessList[index],
            if (index == _quickAccessList.length - 1)
              SizedBox(
                width: mediaQuery.width * .05,
              ),
          ],
        );
      },
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final IconData icon;
  const _QuickAccessItem(this.onPressed, this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 5),
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.colors.itemBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.colors.hintColor,
              size: 30,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style:
                  AppTheme.textStyles.subTileTextStyle.copyWith(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
