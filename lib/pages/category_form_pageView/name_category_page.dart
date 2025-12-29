part of 'category_form_page_view.dart';

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
    final nameFromState = GetIt.I<CategoryFormCubit>().state.name;

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
    GetIt.I<CategoryFormCubit>().updateName(_nameController.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual o nome dessa categoria?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .05),
        CustomTextField(
          hint: 'Ex. Lazer, Alimentação, Transporte',
          showIcon: false,
          controller: _nameController,
          icon: Icons.text_fields_sharp,
        ),
        SizedBox(height: mediaQuery.height * .05),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            spacing: 10,
            children: [
              Text(
                'A categoria servirá para todos os meses e não poderá ser excluída se houver alguma conta vinculada à ela.',
                style: AppTheme.textStyles.subTileTextStyle.copyWith(
                    color: AppTheme.colors.hintTextColor.withAlpha(100)),
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              Text(
                'Crie com sabedoria.',
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
