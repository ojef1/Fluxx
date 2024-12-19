import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ShortcutListsBottomsheet extends StatelessWidget {
  const ShortcutListsBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * .5,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 10,
            width: 50,
            decoration: BoxDecoration(
                color: AppTheme.colors.accentColor,
                borderRadius: BorderRadius.circular(25)),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
                color: AppTheme.colors.accentColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            child: ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.monthListPage),
              title: Text(
                'Lista de Meses',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: AppTheme.colors.accentColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            child: ListTile(
              onTap: () {
                debugPrint('Lista de Contas');
              },
              title: Text(
                'Lista de Contas',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: AppTheme.colors.accentColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            child: ListTile(
              onTap: () {
                debugPrint('Lista de Categorias');
              },
              title: Text(
                'Lista de Categorias',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: AppTheme.colors.accentColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            child: ListTile(
              onTap: () {
                debugPrint('Lista de Rendas');
              },
              title: Text(
                'Lista de Rendas',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
