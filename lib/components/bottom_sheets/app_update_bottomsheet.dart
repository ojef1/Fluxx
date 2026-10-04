import 'package:Fluxx/blocs/update_cubit/update_cubit.dart';
import 'package:Fluxx/components/primary_button.dart';
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
              'assets/images/update_confirmation.png',
              height: mediaQuery.height * .2,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              'Nova versão disponível',
              style: AppTheme.textStyles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Há uma nova versão do Fluxx disponível. Atualize para continuar com tudo em dia.',
              style: AppTheme.textStyles.subTileTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Atualizar',
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
                  'Agora não',
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
