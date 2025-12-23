part of 'add_bill_pageview.dart';

class NameBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const NameBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<NameBillPage> createState() => _NameBillPageState();
}

class _NameBillPageState extends State<NameBillPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    final nameFromState = GetIt.I<AddBillCubit>().state.name;

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
    GetIt.I<AddBillCubit>().updateName(_nameController.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual o nome dessa conta?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .1),
        CustomTextField(
          hint: 'Ex. Boleto da faculdade',
          showIcon: false,
          controller: _nameController,
          icon: Icons.text_fields_sharp,
        ),
      ],
    );
  }
}
