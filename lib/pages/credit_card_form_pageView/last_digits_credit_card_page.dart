part of 'credit_card_form_page_view.dart';

class LastDigitsCreditCardPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const LastDigitsCreditCardPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<LastDigitsCreditCardPage> createState() =>
      _LastDigitsCreditCardPageState();
}

class _LastDigitsCreditCardPageState extends State<LastDigitsCreditCardPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    final nameFromState = GetIt.I<CreditCardFormCubit>().state.lastFourDigits;

    _nameController = TextEditingController(text: nameFromState);

    widget.registerValidator(_validate);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<bool> _validate() async {
    if (_nameController.text.length <4) {
      widget.onError('Preencha os 4 digitos');
      return false;
    }
    GetIt.I<CreditCardFormCubit>().updateLastFourDigits(_nameController.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Quais o 4 últimos digitos?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .1),
        CustomTextField(
          hint: 'Ex. 1234',
          showIcon: false,
          controller: _nameController,
          icon: Icons.text_fields_sharp,
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Não se preocupe, Usamos essa informação apenas para identificar seus cartões e evitar confusão entre cartões parecidos.',
            style: AppTheme.textStyles.subTileTextStyle
                .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
