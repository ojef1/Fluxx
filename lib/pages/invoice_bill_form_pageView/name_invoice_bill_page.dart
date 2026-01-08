part of 'invoice_bill_form_page_view.dart';


class NameInvoiceBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const NameInvoiceBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<NameInvoiceBillPage> createState() => _NameInvoiceBillPageState();
}

class _NameInvoiceBillPageState extends State<NameInvoiceBillPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    final nameFromState = GetIt.I<InvoiceBillFormCubit>().state.name;

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
    GetIt.I<InvoiceBillFormCubit>().updateName(_nameController.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual o nome dessa compra?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .1),
        CustomTextField(
          hint: 'Ex. Tênis da adidas',
          showIcon: false,
          controller: _nameController,
          icon: Icons.text_fields_sharp,
        ),
      ],
    );
  }
}
