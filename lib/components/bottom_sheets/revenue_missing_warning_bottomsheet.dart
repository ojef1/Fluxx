import 'package:Fluxx/blocs/add_bill_cubit/add_bill_cubit.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RevenueMissingWarningBottomsheet extends StatelessWidget {
  const RevenueMissingWarningBottomsheet({super.key});

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
      child: BlocBuilder<AddBillCubit, AddBillState>(
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
                  'º A renda “${state.revenueSelected?.name}” não existe até o mês de “${state.repeatMonthName}”.',
                  style: AppTheme.textStyles.subTileTextStyle,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'º As contas serão criadas normalmente, mas alguns meses ficarão sem renda selecionada.',
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
                    Text(
                      'Dica: rendas podem ser criadas\n apenas para meses específicos',
                      style: AppTheme.textStyles.subTileTextStyle.copyWith(
                          color: AppTheme.colors.hintTextColor.withAlpha(100)),
                      softWrap: true,
                      textAlign: TextAlign.center,
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
}
