import 'package:Fluxx/blocs/update_cubit/update_cubit.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/components/secondary_button.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.colors.appBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppTheme.colors.hintColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Atualização pronta',
                  style: AppTheme.textStyles.titleTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'A nova versão foi baixada. O app será reiniciado para concluir a atualização.',
              style: AppTheme.textStyles.subTileTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Reiniciar agora',
              onPressed: () => Navigator.pop(context, true),
              width: mediaQuery.width * .85,
              color: AppTheme.colors.hintColor,
              textStyle: AppTheme.textStyles.bodyTextStyle,
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: mediaQuery.width * .85,
              child: SecondaryButton(
                title: 'Depois',
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
