part of 'credit_card_form_page_view.dart';

class DueCreditCardPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const DueCreditCardPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<DueCreditCardPage> createState() => _DueCreditCardPageState();
}

class _DueCreditCardPageState extends State<DueCreditCardPage> {
  @override
  void initState() {
    super.initState();
    widget.registerValidator(_validate);
  }

  Future<bool> _validate() async {
    //o calendário sempre inicia com a data de hoje então não precisa validara seleção
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      children: [
        Text(
          'Qual o vencimento da fatura?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        DateSelector(
          selectedDateFromState: GetIt.I<CreditCardFormCubit>().state.dueDay,
          onDateSelected: (date) =>
              GetIt.I<CreditCardFormCubit>().updateDueDay(date),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            spacing: 10,
            children: [
              Text(
                'Não se incomode com a sequência exata dos dias, precisamos apenas do número exato do dia.',
                style: AppTheme.textStyles.subTileTextStyle.copyWith(
                    color: AppTheme.colors.hintTextColor.withAlpha(100)),
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              Text(
                'Ex. todo dia 20.',
                style: AppTheme.textStyles.subTileTextStyle.copyWith(
                    color: AppTheme.colors.hintTextColor.withAlpha(100)),
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
