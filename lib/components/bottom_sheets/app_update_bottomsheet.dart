import 'package:Fluxx/blocs/update_cubit/update_cubit.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/components/secondary_button.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Abre o aviso de nova versão. "Atualizar" inicia o download; fechar ou tocar em
/// "Agora não" adia o aviso e explica onde atualizar depois.
Future<void> showAppUpdateBottomsheet(BuildContext context) async {
  final accepted = await showModalBottomSheet<bool>(
    context: context,
    builder: (context) => const AppUpdateBottomsheet(),
  );

  final cubit = GetIt.I<UpdateCubit>();
  if (accepted == true) {
    await cubit.startUpdate();
    return;
  }

  await cubit.dismissPopup();
  if (!context.mounted) return;
  await showFlushbar(
    context,
    'Você pode atualizar depois pelo botão no menu lateral.',
    false,
  );
}

class AppUpdateBottomsheet extends StatelessWidget {
  const AppUpdateBottomsheet({super.key});

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
                  Icons.system_update_rounded,
                  color: AppTheme.colors.hintColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Nova versão',
                  style: AppTheme.textStyles.titleTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Há uma nova versão do Fluxx disponível. Atualize para continuar com tudo em dia.',
              style: AppTheme.textStyles.subTileTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Atualizar',
              onPressed: () => Navigator.pop(context, true),
              width: mediaQuery.width * .85,
              color: AppTheme.colors.hintColor,
              textStyle: AppTheme.textStyles.bodyTextStyle,
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: mediaQuery.width * .85,
              child: SecondaryButton(
                title: 'Agora não',
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
