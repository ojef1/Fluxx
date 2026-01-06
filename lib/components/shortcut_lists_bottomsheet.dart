
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ShortcutListsBottomsheet extends StatelessWidget {
  const ShortcutListsBottomsheet({super.key, });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * .6,
      color: AppTheme.colors.appBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 6,
            width: 30,
            decoration: BoxDecoration(
                color: AppTheme.colors.hintColor,
                borderRadius: BorderRadius.circular(25)),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
                color: AppTheme.colors.itemBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            width: mediaQuery.width * .85,
            child: ListTile(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.creditCardListPage),
              title: Text(
                'Lista de Cartões',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.colors.hintColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: AppTheme.colors.itemBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            width: mediaQuery.width * .85,
            child: ListTile(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.monthListPage),
              title: Text(
                'Lista de Meses',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.colors.hintColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
             decoration: BoxDecoration(
                color: AppTheme.colors.itemBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            width: mediaQuery.width * .85,
            child: ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.detailPage);
              },
              title: Text(
                'Lista de Contas',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.colors.hintColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
             decoration: BoxDecoration(
                color: AppTheme.colors.itemBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            width: mediaQuery.width * .85,
            child: ListTile(
              onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.categoryListPage),
              title: Text(
                'Lista de Categorias',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.colors.hintColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
             decoration: BoxDecoration(
                color: AppTheme.colors.itemBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            width: mediaQuery.width * .85,
            child: ListTile(
              onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.revenueListPage),
              
              title: Text(
                'Lista de Receitas',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.colors.hintColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
