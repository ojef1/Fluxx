part of 'invoice_bill_form_page_view.dart';

class PriceInvoiceBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;

  const PriceInvoiceBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<PriceInvoiceBillPage> createState() => _PriceBillPageState();
}

class _PriceBillPageState extends State<PriceInvoiceBillPage> {
  late final MoneyMaskedTextController _moneyController;

  @override
  void initState() {
    final priceFromState = GetIt.I<InvoiceBillFormCubit>().state.price;
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

  GetIt.I<InvoiceBillFormCubit>().updatePrice(value);
  return true;
}


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual o valor total dessa compra?',
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
