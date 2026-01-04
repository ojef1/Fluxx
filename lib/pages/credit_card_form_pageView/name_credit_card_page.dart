part of 'credit_card_form_page_view.dart';

class NameCreditCardPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const NameCreditCardPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<NameCreditCardPage> createState() => _NameCreditCardPageState();
}

class _NameCreditCardPageState extends State<NameCreditCardPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    final nameFromState = GetIt.I<CreditCardFormCubit>().state.name;

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
    if (_nameController.text.isEmpty || _nameController.text == '') {
      widget.onError('Preencha o nome');
      return false;
    }
    GetIt.I<CreditCardFormCubit>().updateName(_nameController.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual o nome do cartão?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .1),
        CustomTextField(
          hint: 'Ex. Cartão de emergência',
          showIcon: false,
          controller: _nameController,
          icon: Icons.text_fields_sharp,
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            spacing: 10,
            children: [
              Text(
                'Esse nome será apenas informativo.',
                style: AppTheme.textStyles.subTileTextStyle.copyWith(
                    color: AppTheme.colors.hintTextColor.withAlpha(100)),
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              Text(
                'Servirá para você diferenciar os seus cartões de forma mais fácil.',
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
