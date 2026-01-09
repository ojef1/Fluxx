part of 'invoice_bill_form_page_view.dart';

class CheckBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const CheckBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<CheckBillPage> createState() => _CheckBillPageState();
}

class _CheckBillPageState extends State<CheckBillPage> {
  @override
  void initState() {
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    var state = GetIt.I<InvoiceBillFormCubit>().state;
    if (state.name.isEmpty) {
      showFlushbar(context, 'A conta precisa ter um nome', true);
      return false;
    }
    if (state.price == 0.0) {
      showFlushbar(context, 'A conta não pode ser R\$00,00', true);
      return false;
    }
    if (state.categorySelected == null) {
      showFlushbar(context, 'Escolha a categoria da conta', true);
      return false;
    }
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
            'Revise os dados da conta',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: mediaQuery.height * .05),
          BlocBuilder<InvoiceBillFormCubit, InvoiceBillFormState>(
              bloc: GetIt.I(),
              builder: (context, state) {
                BankModel bank = getBank(state.cardSelected!.bankId!);
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: mediaQuery.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DataItem(title: 'Nome da conta', subtitle: state.name),
                      _DataItem(
                          title: 'Valor',
                          subtitle: 'R\$${formatPrice(state.price)}'),
                      _DataItem(
                        title: 'Cartão usado',
                        subtitle: state.cardSelected?.name ?? 'Nenhuma',
                        iconPath: bank.iconPath,
                      ),
                      _DataItem(
                          title: 'Categoria',
                          subtitle: state.categorySelected!.categoryName ??
                              'Nenhuma'),
                      _DataItem(
                          title: 'Data da compra',
                          subtitle: formatDate(state.date) ?? 'Nenhuma'),
                      _DataItem(
                          title: 'Forma de pagamento',
                          subtitle: state.repeatBill
                              ? 'Parcelado em ${state.repeatCount} vezes'
                              : 'A vista'),
                      if (state.repeatBill)
                        _DataItem(
                            title: 'Valor de cada parcela',
                            subtitle:
                                'R\$${formatPrice(state.price / state.repeatCount)}'),
                      _DataItem(title: 'Descrição', subtitle: state.desc),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? iconPath;
  const _DataItem({
    required this.title,
    required this.subtitle,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(
          title,
          style: AppTheme.textStyles.secondaryTextStyle
              .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subtitle.isNotEmpty
                  ? subtitle
                  : 'sem ${title.toLowerCase()} informado(a)',
              style: AppTheme.textStyles.subTileTextStyle,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            if (iconPath != null)
              ClipOval(
                child: Image.asset(
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                  iconPath!,
                  height: 25,
                  width: 25,
                ),
              ),
          ],
        ),
        Divider(
          color: AppTheme.colors.hintTextColor,
          thickness: 1,
        ),
      ],
    );
  }
}
