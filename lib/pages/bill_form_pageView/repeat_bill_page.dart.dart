part of 'bill_form_page_view.dart';

class RepeatBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const RepeatBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<RepeatBillPage> createState() => _RepeatBillPageState();
}

class _RepeatBillPageState extends State<RepeatBillPage> {
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
            'Deseja repetir essa conta nos próximos\n meses?',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          Text(
            'Ex. compras parceladas\n ou recorrentes',
            style: AppTheme.textStyles.subTileTextStyle
                .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: mediaQuery.height * .05),
          BlocBuilder<BillFormCubit, BillFormState>(
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
                      local.value ? 'Repetir' : 'Não Repetir',
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
                        GetIt.I<BillFormCubit>().updateRepeatBill(value),
                    styleBuilder: (b) => ToggleStyle(
                        backgroundColor: b
                            ? AppTheme.colors.hintColor
                            : AppTheme.colors.lightHintColor,
                        indicatorColor: AppTheme.colors.white),
                    iconBuilder: (value) => value
                        ? const Icon(Icons.check_rounded)
                        : const Icon(Icons.close_rounded),
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
  late final List<DateTime> monthsList;
  late final MonthModel _currentMonth;

  @override
  void initState() {
    _currentMonth = GetIt.I<ResumeCubit>().state.monthInFocus!;
    monthsList = getNextMonthsUntilDecember(_currentMonth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Até quando?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        Text(
          '(Isso não poderá ser editado depois)',
          style: AppTheme.textStyles.subTileTextStyle
              .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
          softWrap: true,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        const SizedBox(height: 20),
        BlocBuilder<BillFormCubit, BillFormState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) =>
                previous.repeatCount != current.repeatCount,
            builder: (context, state) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                itemCount: monthsList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final month = monthsList[index];
                  final repeatValue = index + 1;
                  var isSelected = state.repeatCount == repeatValue;

                  return PrimaryButton(
                      color: isSelected
                          ? AppTheme.colors.hintColor
                          : AppTheme.colors.itemBackgroundColor,
                      textStyle: AppTheme.textStyles.bodyTextStyle,
                      width: mediaQuery.width * .85,
                      text: DateFormat('MMMM yyyy', 'pt_BR').format(month),
                      onPressed: () async {
                        if (state.revenueSelected != null) {
                          await _validateSelectedMonth(
                              state.revenueSelected!, repeatValue);
                        }
                        _updateStates(repeatValue, month);
                      });
                },
              );
            }),
      ],
    );
  }

  Future<void> _validateSelectedMonth(
      RevenueModel revenue, int repeatValue) async {
    var targetMonthId = _currentMonth.id! + repeatValue;
    bool hasRevenues =
        GetIt.I<BillFormCubit>().revenueExistsInMonth(revenue, targetMonthId);

    if (hasRevenues) {
      return;
    } else {
      _showRevenueWarning();
    }
  }

  void _updateStates(int repeatValue, DateTime month) {
    GetIt.I<BillFormCubit>().updateRepeatCount(repeatValue);
    GetIt.I<BillFormCubit>()
        .updateRepeatMonthName(DateFormat('MMMM yyyy', 'pt_BR').format(month));
  }

  void _showRevenueWarning() {
    showModalBottomSheet(
        context: context,
        builder: (context) => const RevenueMissingWarningBottomsheet());
  }
}
