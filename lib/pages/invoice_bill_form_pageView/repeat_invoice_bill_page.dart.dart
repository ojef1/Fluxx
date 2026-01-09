part of 'invoice_bill_form_page_view.dart';

class RepeatInvoiceBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const RepeatInvoiceBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<RepeatInvoiceBillPage> createState() => _RepeatInvoiceBillPageState();
}

class _RepeatInvoiceBillPageState extends State<RepeatInvoiceBillPage> {
  @override
  void initState() {
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    // não precisa validar nada
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
            'Qual foi a forma de pagamento?',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: mediaQuery.height * .05),
          BlocBuilder<InvoiceBillFormCubit, InvoiceBillFormState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) =>
                previous.repeatBill != current.repeatBill,
            builder: (context, state) {
              return Column(
                children: [
                  AnimatedToggleSwitch<bool>.dual(
                    current: state.repeatBill,
                    first: false,
                    second: true,
                    customTextBuilder: (context, local, global) => Text(
                      local.value ? 'Parcelado' : 'A vista',
                      style: AppTheme.textStyles.subTileTextStyle
                          .copyWith(color: AppTheme.colors.white),
                    ),
                    spacing: 80,
                    style: const ToggleStyle(
                      borderColor: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                    borderWidth: 5.0,
                    height: 55,
                    onChanged: (value) =>
                        GetIt.I<InvoiceBillFormCubit>().updateRepeatBill(value),
                    styleBuilder: (b) => ToggleStyle(
                        backgroundColor: b
                            ? AppTheme.colors.hintColor
                            : AppTheme.colors.lightHintColor,
                        indicatorColor: AppTheme.colors.white),
                    iconBuilder: (value) => value
                        ? const Icon(Icons.loop_rounded)
                        : const Icon(Icons.one_x_mobiledata),
                  ),
                  const SizedBox(height: 30),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: state.repeatBill
                        ? const _RepeatBillHandle()
                        : const SizedBox(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RepeatBillHandle extends StatefulWidget {
  const _RepeatBillHandle();

  @override
  State<_RepeatBillHandle> createState() => _RepeatBillHandleState();
}

class _RepeatBillHandleState extends State<_RepeatBillHandle> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Em quantas vezes?',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 20),
          BlocBuilder<InvoiceBillFormCubit, InvoiceBillFormState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) =>
                previous.repeatCount != current.repeatCount,
            builder: (context, state) {
              return Container(
                width: mediaQuery.width * .55,
                height: 50,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: AppTheme.colors.itemBackgroundColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: double.infinity,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.hintColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => GetIt.I<InvoiceBillFormCubit>()
                            .updateRepeatCount(state.repeatCount - 1),
                        style: IconButton.styleFrom(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(2)),
                        ),
                        icon: Icon(
                          Icons.remove_rounded,
                          color: AppTheme.colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'X${state.repeatCount}',
                      style: AppTheme.textStyles.subTileTextStyle
                          .copyWith(color: AppTheme.colors.white),
                    ),
                    Container(
                      height: double.infinity,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.hintColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => GetIt.I<InvoiceBillFormCubit>()
                            .updateRepeatCount(state.repeatCount + 1),
                        style: IconButton.styleFrom(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(2)),
                        ),
                        icon: Icon(
                          Icons.add_rounded,
                          color: AppTheme.colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          Text(
            'Atenção',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Text(
              'Compras parceladas não podem ser editadas depois.',
              style: AppTheme.textStyles.subTileTextStyle
                  .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
