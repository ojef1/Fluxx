part of 'revenue_form_page_view.dart';

class NameRevenuePage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const NameRevenuePage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<NameRevenuePage> createState() => _NameRevenuePageState();
}

class _NameRevenuePageState extends State<NameRevenuePage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    final nameFromState = GetIt.I<RevenueFormCubit>().state.name;

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
    GetIt.I<RevenueFormCubit>().updateName(_nameController.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual o nome dessa renda?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .1),
        CustomTextField(
          hint: 'Ex. Salário',
          showIcon: false,
          controller: _nameController,
          icon: Icons.text_fields_sharp,
        ),
      ],
    );
  }
}
