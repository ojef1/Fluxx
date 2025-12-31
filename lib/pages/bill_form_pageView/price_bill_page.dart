part of 'bill_form_page_view.dart';

class PriceBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;

  const PriceBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<PriceBillPage> createState() => _PriceBillPageState();
}

class _PriceBillPageState extends State<PriceBillPage> {
  late final MoneyMaskedTextController _moneyController;

  @override
  void initState() {
    final priceFromState = GetIt.I<BillFormCubit>().state.price;
    _moneyController = MoneyMaskedTextController(
      decimalSeparator: ',',
      thousandSeparator: '.',
      initialValue: priceFromState,
    );
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
  final text = _moneyController.text.trim();

  if (text.isEmpty) {
    widget.onError('Informe um valor');
    return false;
  }

  // Remove separadores de milhar e troca vírgula por ponto
  final formatted = text
      .replaceAll('.', '')
      .replaceAll(',', '.');

  final value = double.tryParse(formatted);

  if (value == null || value < 0.01) {
    widget.onError('Valor mínimo de 0,01');
    return false;
  }

  GetIt.I<BillFormCubit>().updatePrice(value);
  return true;
}


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual o valor dessa conta?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .1),
        TextFormField(
          maxLines: 1,
          textAlignVertical: TextAlignVertical.top,
          cursorColor: Colors.white,
          controller: _moneyController,
          keyboardType: TextInputType.number,
          style: AppTheme.textStyles.titleTextStyle,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '',
            hintStyle: AppTheme.textStyles.bodyTextStyle,
          ),
        ),
      ],
    );
  }
}
