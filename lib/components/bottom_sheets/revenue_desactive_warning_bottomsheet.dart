import 'package:Fluxx/blocs/bills_cubit/bill_form_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_form_cubit/revenue_form_cubit.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class RevenueDisableWarningBottomsheet extends StatelessWidget {
  const RevenueDisableWarningBottomsheet({super.key});

  String get nextMonth {
    var monthInFocus = GetIt.I<ResumeCubit>().state.monthInFocus;
    if (monthInFocus != null) {
      var nextMonthDate = DateTime.now().month + 1;
      // Se o mês for 13 (janeiro do próximo ano), ajusta para 1 (janeiro)
      if (nextMonthDate > 12) {
        nextMonthDate = 1;
      }
    // Retorna o nome do mês
    return DateFormat('MMMM', 'pt_BR').format(DateTime(DateTime.now().year, nextMonthDate));
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.colors.appBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BlocBuilder<BillFormCubit, BillFormState>(
          bloc: GetIt.I(),
          buildWhen: (previous, current) =>
              previous.revenueSelected != current.revenueSelected ||
              previous.repeatMonthName != current.repeatMonthName,
          builder: (context, state) {
            return Column(
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
                  'º Ela ainda ficará disponível para uso durante o resto do mês.',
                  style: AppTheme.textStyles.subTileTextStyle,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'º A partir de $nextMonth, essa receita não fará mais parte da sua lista de receitas mensais.',
                  style: AppTheme.textStyles.subTileTextStyle,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Tem certeza que deseja desativar esta receita?',
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
                          GetIt.I<ResumeCubit>().state.monthInFocus!.id;
                      Navigator.of(context).pop();
                      await GetIt.I<RevenueFormCubit>()
                          .desactiveRevenue(currentMonthId!);
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
            );
          }),
    );
  }
}
