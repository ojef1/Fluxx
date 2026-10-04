import 'package:Fluxx/blocs/update_cubit/update_cubit.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Pede confirmação antes de reiniciar o app para concluir a atualização já baixada.
Future<void> showAppUpdateRestartBottomsheet(BuildContext context) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    builder: (context) => const AppUpdateRestartBottomsheet(),
  );

  if (confirmed == true) {
    await GetIt.I<UpdateCubit>().completeUpdate();
  }
}

class AppUpdateRestartBottomsheet extends StatelessWidget {
  const AppUpdateRestartBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: AppTheme.colors.itemBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/confirmation_check.png',
              height: mediaQuery.height * .2,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              'Atualização pronta',
              style: AppTheme.textStyles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'A nova versão foi baixada. O app será reiniciado para concluir a atualização.',
              style: AppTheme.textStyles.subTileTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Reiniciar agora',
              onPressed: () => Navigator.pop(context, true),
              width: mediaQuery.width * .85,
              color: AppTheme.colors.hintColor,
              textStyle: AppTheme.textStyles.bodyTextStyle,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context, false),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Depois',
                  style: AppTheme.textStyles.bodyTextStyle.copyWith(
                    color: AppTheme.colors.hintTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
