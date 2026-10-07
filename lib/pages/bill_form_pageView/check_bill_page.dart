part of 'bill_form_page_view.dart';

class CheckBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  final void Function(int pageIndex) onEdit;
  final int? repeatPageIndex; // null quando a página de repetição não existe
  const CheckBillPage(
      {super.key,
      required this.registerValidator,
      required this.onError,
      required this.onEdit,
      this.repeatPageIndex});
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
    var state = GetIt.I<BillFormCubit>().state;
    if (state.name.isEmpty) {
      showFlushbar(context, 'A conta precisa ter um nome', true);
      return false;
    }
    if (state.price == 0.0) {
      showFlushbar(context, 'A conta não pode ser R\$00,00', true);
      return false;
    }
    if (state.date.isEmpty) {
      showFlushbar(context, 'Escolha a data de pagamento', true);
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
          BlocBuilder<BillFormCubit, BillFormState>(
              bloc: GetIt.I(),
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: mediaQuery.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DataItem(
                          title: 'Nome da conta',
                          subtitle: state.name,
                          onEdit: () => widget.onEdit(0)),
                      _DataItem(
                          title: 'Data de Pagamento',
                          subtitle: formatDate(state.date) ?? 'Nenhuma',
                          onEdit: () => widget.onEdit(2)),
                      _DataItem(
                          title: 'Valor',
                          subtitle: 'R\$${formatPrice(state.price)}',
                          onEdit: () => widget.onEdit(1)),
                      _DataItem(
                          title: 'Receita usada',
                          subtitle: state.revenueSelected?.name ?? 'Nenhuma',
                          onEdit: () => widget.onEdit(5)),
                      _DataItem(
                          title: 'Categoria',
                          subtitle: state.categorySelected == null
                              ? 'Não selecionado'
                              : state.categorySelected!.categoryName ??
                                  'Nenhuma',
                          hasError: state.categorySelected == null,
                          onEdit: () => widget.onEdit(4)),
                      if (state.repeatBill)
                        _DataItem(
                            title: 'Repetição',
                            subtitle: 'até ${state.repeatMonthName}',
                            onEdit: widget.repeatPageIndex == null
                                ? null
                                : () => widget.onEdit(widget.repeatPageIndex!)),
                      _DataItem(
                          title: 'Descrição',
                          subtitle: state.desc,
                          onEdit: () => widget.onEdit(3)),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}


class _DataItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onEdit;
  final bool hasError; // destaca o item quando um dado obrigatório falta
  const _DataItem({
    required this.title,
    required this.subtitle,
    this.onEdit,
    this.hasError = false,
  });

  @override
  State<_DataItem> createState() => _DataItemState();
}

class _DataItemState extends State<_DataItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _updateBlink();
  }

  @override
  void didUpdateWidget(covariant _DataItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasError != widget.hasError) _updateBlink();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  //o botão de editar pisca entre a cor de erro e a original enquanto houver erro
  void _updateBlink() {
    if (widget.hasError) {
      _blinkController.repeat(reverse: true);
    } else {
      _blinkController.stop();
      _blinkController.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(
          widget.title,
          style: AppTheme.textStyles.secondaryTextStyle
              .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.subtitle.isNotEmpty
                    ? widget.subtitle
                    : 'sem ${widget.title.toLowerCase()} informado(a)',
                style: widget.hasError
                    ? AppTheme.textStyles.subTileTextStyle
                        .copyWith(color: AppTheme.colors.red)
                    : AppTheme.textStyles.subTileTextStyle,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
            if (widget.onEdit != null)
              AnimatedBuilder(
                animation: _blinkController,
                builder: (context, child) {
                  final blink = _blinkController.value;
                  return IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Color.lerp(
                        AppTheme.colors.itemBackgroundColor,
                        AppTheme.colors.red,
                        blink,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(
                      Icons.edit_rounded,
                      size: 20,
                      color: Color.lerp(
                        AppTheme.colors.hintColor,
                        AppTheme.colors.white,
                        blink,
                      ),
                    ),
                    onPressed: widget.onEdit,
                  );
                },
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
