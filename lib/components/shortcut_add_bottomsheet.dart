import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ShortcutAddBottomsheet extends StatelessWidget {
  const ShortcutAddBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * .4,
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
              onTap: () {
                var currentMonthId =
                    GetIt.I<ResumeCubit>().state.currentMonth!.id!;
                BillModel billModel = BillModel(monthId: currentMonthId);
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.billFormPage,
                  arguments: billModel,
                );
              },
              title: Text(
                'Adicionar Conta',
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
                RevenueModel revenue = RevenueModel();
                Navigator.pushReplacementNamed(
                    context, AppRoutes.revenueFormPage,
                    arguments: revenue);
              },
              title: Text(
                'Adicionar Receita',
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
              onTap: () => goToCategoryForm(context: context),
              title: Text(
                'Adicionar Categoria',
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
