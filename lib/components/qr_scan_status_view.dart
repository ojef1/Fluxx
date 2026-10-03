import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// Tela cheia usada nos estados de erro e de permissão negada da leitura do QR Code.
class QrScanStatusView extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final String primaryText;
  final Function() onPrimaryPressed;
  final Function() onManualPressed;

  const QrScanStatusView({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.primaryText,
    required this.onPrimaryPressed,
    required this.onManualPressed,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: iconColor),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: AppTheme.textStyles.bodyTextStyle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: AppTheme.textStyles.secondaryTextStyle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ),
        PrimaryButton(
          text: primaryText,
          onPressed: onPrimaryPressed,
          width: mediaQuery.width * .85,
          color: AppTheme.colors.hintColor,
          textStyle: AppTheme.textStyles.bodyTextStyle,
        ),
        TextButton(
          onPressed: onManualPressed,
          child: Text(
            'Preencher manualmente',
            style: AppTheme.textStyles.secondaryTextStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.colors.hintTextColor,
            ),
          ),
        ),
        SizedBox(height: mediaQuery.height * .03),
      ],
    );
  }
}
