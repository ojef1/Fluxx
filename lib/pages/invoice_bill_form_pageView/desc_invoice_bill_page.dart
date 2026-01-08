part of 'invoice_bill_form_page_view.dart';

class DescBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const DescBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<DescBillPage> createState() => _DescBillPageState();
}

class _DescBillPageState extends State<DescBillPage> {
  late TextEditingController _descController;

  @override
  void initState() {
    final descFromState = GetIt.I<InvoiceBillFormCubit>().state.desc;
    _descController = TextEditingController(text: descFromState);
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    //a descrição é opcional então não precisa validar nada
    GetIt.I<InvoiceBillFormCubit>().updateDesc(_descController.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Text(
            'Gostaria de adicionar alguma descrição?',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          Text(
            '(opcional)',
            style: AppTheme.textStyles.subTileTextStyle
                .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: mediaQuery.height * .05),
          CustomBigTextField(
            hint: '',
            maxLines: 6,
            height: mediaQuery.height * .4,
            controller: _descController,
          ),
        ],
      ),
    );
  }
}
