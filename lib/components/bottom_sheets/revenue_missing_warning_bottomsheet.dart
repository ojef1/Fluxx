import 'package:Fluxx/blocs/bill_form_cubit/bill_form_cubit.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

enum MissingRevenueType { revenueNotFound, insufficientBalance }

class RevenueMissingWarningBottomsheet extends StatelessWidget {
  final MissingRevenueType type;
  const RevenueMissingWarningBottomsheet({super.key, required this.type});

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
                      'AVISO',
                      style: AppTheme.textStyles.titleTextStyle,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  _getFirstMessage(state),
                  style: AppTheme.textStyles.subTileTextStyle,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'º As contas serão criadas normalmente, mas alguns meses ficarão sem receita selecionada.',
                  style: AppTheme.textStyles.subTileTextStyle,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'º Você pode ajustar isso depois.',
                  style: AppTheme.textStyles.subTileTextStyle,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 3,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '#',
                      style: AppTheme.textStyles.titleTextStyle.copyWith(
                          color: AppTheme.colors.hintColor.withAlpha(100)),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _gettipMessage(),
                        style: AppTheme.textStyles.subTileTextStyle.copyWith(
                            color:
                                AppTheme.colors.hintTextColor.withAlpha(100)),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: PrimaryButton(
                    text: 'Continuar',
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

  String _getFirstMessage(BillFormState state) {
    switch (type) {
      case MissingRevenueType.revenueNotFound:
        return 'º A receita “${state.revenueSelected?.name}” não existe até o mês de “${state.repeatMonthName}.';
      case MissingRevenueType.insufficientBalance:
        final monthsText = _formatMonths(state.monthsWithoutBalance);

        if (monthsText.isEmpty) {
          return 'º A receita “${state.revenueSelected?.name}” '
              'não possui saldo suficiente.';
        }

        final plural = state.monthsWithoutBalance.length > 1;

        return 'º A receita “${state.revenueSelected?.name}” '
            'não possui saldo suficiente para '
            '${plural ? 'os meses : ' : 'o mês de'} "$monthsText".';
    }
  }

  String _gettipMessage() {
    switch (type) {
      case MissingRevenueType.revenueNotFound:
        return 'Dica: rendas podem ser criadas apenas para meses específicos';
      case MissingRevenueType.insufficientBalance:
        return 'Dica: você pode ajustar o valor da receita ou criar uma receita extra para os próximos meses';
    }
  }

  String _formatMonths(List<MonthModel> months) {
    if (months.isEmpty) return '';

    final names = months.map((m) => m.name).whereType<String>().toList();

    if (names.length == 1) {
      return names.first;
    }

    if (names.length == 2) {
      return '${names.first} e ${names.last}';
    }

    final allButLast = names.sublist(0, names.length - 1).join(', ');
    return '$allButLast e ${names.last}';
  }
}
