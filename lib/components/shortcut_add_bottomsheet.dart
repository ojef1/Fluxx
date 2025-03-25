import 'package:Fluxx/blocs/resume_bloc/resume_cubit.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ShortcutAddBottomsheet extends StatelessWidget {
  const ShortcutAddBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * .4,
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
              onTap: () {
                var currentMonthId =
                    GetIt.I<ResumeCubit>().state.currentMonthId;
                BillModel billModel = BillModel(monthId: currentMonthId);
                Navigator.pushReplacementNamed(
                context,
                AppRoutes.addBillPage,
                arguments: billModel,
              );
              },
              title: Text(
                'Adicionar Conta',
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
                var currentMonthId =
                    GetIt.I<ResumeCubit>().state.currentMonthId;
                RevenueModel revenue = RevenueModel(monthId: currentMonthId);
                Navigator.pushReplacementNamed(
                    context, AppRoutes.addRevenuePage,
                    arguments: revenue);
              },
              title: Text(
                'Adicionar Renda',
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
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.addCategoryPage),
              title: Text(
                'Adicionar Categoria',
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
