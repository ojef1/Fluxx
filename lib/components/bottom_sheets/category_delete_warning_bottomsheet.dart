import 'package:Fluxx/blocs/category_form_cubit/category_form_cubit.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/services/app_period_service.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoryDisableWarningBottomsheet extends StatelessWidget {
  final String categoryId;
  const CategoryDisableWarningBottomsheet(
      {super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      height: mediaQuery.height * .5,
      decoration: BoxDecoration(
        color: AppTheme.colors.appBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppTheme.colors.hintColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'ATENÇÃO',
                style: AppTheme.textStyles.titleTextStyle,
              ),
            ],
          ),
          const Spacer(),
          Text(
            'º Só é possível excluir uma categoria se não houver nenhuma conta (de qualquer mês) vinculada à ela.',
            style: AppTheme.textStyles.subTileTextStyle,
            textAlign: TextAlign.start,
            softWrap: true,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Tem certeza que deseja excluir esta categoria?',
              style: AppTheme.textStyles.subTileTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 3,
            ),
          ),
          const Spacer(),
          Center(
            child: PrimaryButton(
              text: 'Tenho certeza',
              onPressed: () async {
                var currentMonthId =
                    AppPeriodService().monthInFocus.id;
                Navigator.of(context).pop();
                await GetIt.I<CategoryFormCubit>().disableCategory(currentMonthId!);
              },
              width: mediaQuery.width * .85,
              color: AppTheme.colors.red,
              textStyle: AppTheme.textStyles.bodyTextStyle,
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: PrimaryButton(
              text: 'Voltar',
              onPressed: () => Navigator.of(context).pop(),
              width: mediaQuery.width * .85,
              color: AppTheme.colors.hintColor,
              textStyle: AppTheme.textStyles.bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
