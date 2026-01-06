import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

enum InfoCardType { recommendedSpending, revenueImpairment }

class CreditCardInfoBottomsheet extends StatelessWidget {
  final InfoCardType type;
  const CreditCardInfoBottomsheet({super.key, required this.type});

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
                'INFORMAÇÃO',
                style: AppTheme.textStyles.titleTextStyle,
              ),
            ],
          ),
          const Spacer(),
          Text(
            _getFirstMessage(),
            style: AppTheme.textStyles.bodyTextStyle,
            textAlign: TextAlign.start,
            softWrap: true,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Text(
            _getSecondMessage(),
            style: AppTheme.textStyles.bodyTextStyle,
            textAlign: TextAlign.start,
            softWrap: true,
            maxLines: 3,
          ),
          const Spacer(),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
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

  String _getFirstMessage() {
    switch (type) {
      case InfoCardType.recommendedSpending:
        return 'º A recomendação do máximo que você pode gastar é baseado na soma das suas outras contas além do cartão de crédito.';
      case InfoCardType.revenueImpairment:
        return 'º O comprometimento da receita é baseado no quanto a fatura atual diz respeito a sua receita total.';
      
    }
  }

  String _getSecondMessage() {
    switch (type) {
      case InfoCardType.recommendedSpending:
        return 'º O valor recomendado não diz respeito ao quanto você tem disponível, mas sim no quanto você deveria gastar sem se comprometer financeiramente.';
      case InfoCardType.revenueImpairment:
        return 'º A receita total é a soma de todas as suas receitas.';
    }
  }
}
