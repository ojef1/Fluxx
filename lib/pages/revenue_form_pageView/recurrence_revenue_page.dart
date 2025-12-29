part of 'revenue_form_page_view.dart';

class RecurrenceRevenuePage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const RecurrenceRevenuePage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<RecurrenceRevenuePage> createState() => _RecurrenceRevenuePageState();
}

class _RecurrenceRevenuePageState extends State<RecurrenceRevenuePage> {
  late final MonthModel _currentMonth;
  @override
  void initState() {
    _currentMonth = GetIt.I<ResumeCubit>().state.monthInFocus!;
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
            'Essa renda será mensal ou única?',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: mediaQuery.height * .05),
          BlocBuilder<RevenueFormCubit, RevenueFormState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) =>
                previous.recurrenceMode != current.recurrenceMode,
            builder: (context, state) {
              return Column(
                children: [
                  AnimatedToggleSwitch<bool>.dual(
                    current: state.recurrenceMode == RecurrenceMode.monthly,
                    first: false,
                    second: true,
                    customTextBuilder: (context, local, global) => Text(
                      local.value ? 'Mensal' : 'Única',
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
                    onChanged: (value) => GetIt.I<RevenueFormCubit>()
                        .updateRecurrenceMode(value
                            ? RecurrenceMode.monthly
                            : RecurrenceMode.single),
                    styleBuilder: (b) => ToggleStyle(
                        backgroundColor: b
                            ? AppTheme.colors.hintColor
                            : AppTheme.colors.lightHintColor,
                        indicatorColor: AppTheme.colors.white),
                    iconBuilder: (value) => value
                        ? const Icon(Icons.lock_open_rounded)
                        : const Icon(Icons.lock_rounded),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: state.recurrenceMode == RecurrenceMode.monthly
                          ? Column(
                              spacing: 10,
                              children: [
                                Text(
                                  'Rendas mensais são aquelas que você provavelmente terá até o fim do ano.',
                                  style: AppTheme.textStyles.subTileTextStyle
                                      .copyWith(
                                          color: AppTheme.colors.hintTextColor
                                              .withAlpha(100)),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                                Text(
                                  'Não se preocupe, se precisar você pode desativar a renda a qualquer momento e ela não aparecerá mais para os meses seguintes.',
                                  style: AppTheme.textStyles.subTileTextStyle
                                      .copyWith(
                                          color: AppTheme.colors.hintTextColor
                                              .withAlpha(100)),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            )
                          : Text(
                              'Rendas únicas servirão apenas para o mês atual (${_currentMonth.name})',
                              style: AppTheme.textStyles.subTileTextStyle
                                  .copyWith(
                                      color: AppTheme.colors.hintTextColor
                                          .withAlpha(100)),
                              softWrap: true,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                            ),
                    ),
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

// class _RepeatBillHandle extends StatefulWidget {
//   const _RepeatBillHandle();

//   @override
//   State<_RepeatBillHandle> createState() => _RepeatBillHandleState();
// }

// class _RepeatBillHandleState extends State<_RepeatBillHandle> {
//   late final List<DateTime> monthsList;
//   late final MonthModel _currentMonth;

//   @override
//   void initState() {
//     _currentMonth = GetIt.I<ResumeCubit>().state.monthInFocus!;
//     monthsList = getNextMonthsUntilDecember(_currentMonth);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         Text(
//           'Até quando?',
//           style: AppTheme.textStyles.subTileTextStyle,
//           softWrap: true,
//           textAlign: TextAlign.center,
//           overflow: TextOverflow.visible,
//         ),
//         Text(
//           '(Isso não poderá ser editado depois)',
//           style: AppTheme.textStyles.subTileTextStyle
//               .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
//           softWrap: true,
//           textAlign: TextAlign.center,
//           overflow: TextOverflow.visible,
//         ),
//         const SizedBox(height: 20),
//         BlocBuilder<BillFormCubit, BillFormState>(
//             bloc: GetIt.I(),
//             buildWhen: (previous, current) =>
//                 previous.repeatCount != current.repeatCount,
//             builder: (context, state) {
//               return ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 itemCount: monthsList.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   final month = monthsList[index];
//                   final repeatValue = index + 1;
//                   var isSelected = state.repeatCount == repeatValue;

//                   return PrimaryButton(
//                       color: isSelected
//                           ? AppTheme.colors.hintColor
//                           : AppTheme.colors.itemBackgroundColor,
//                       textStyle: AppTheme.textStyles.bodyTextStyle,
//                       width: mediaQuery.width * .85,
//                       text: getMonthName(month, withYear: true),
//                       onPressed: () async {
//                         if (state.revenueSelected != null) {
//                           await _validateSelectedMonth(
//                               state.revenueSelected!, repeatValue, month);
//                         } else {
//                           _updateStates(repeatValue, month);
//                         }
//                       });
//                 },
//               );
//             }),
//       ],
//     );
//   }

//   Future<void> _validateSelectedMonth(
//       RevenueModel revenue, int repeatValue, DateTime month) async {
//     _updateStates(repeatValue, month);
//     var targetMonthId = _currentMonth.id! + repeatValue;
//     bool hasRevenues =
//         GetIt.I<BillFormCubit>().revenueExistsInMonth(revenue, targetMonthId);

//     if (hasRevenues) {
//       bool hasBalance =
//           await GetIt.I<BillFormCubit>().balanceValidation(_currentMonth.id!);
//       if (hasBalance) return;
//       _showRevenueWarning(MissingRevenueType.insufficientBalance);
//     } else {
//       _showRevenueWarning(MissingRevenueType.revenueNotFound);
//     }
//   }

//   void _updateStates(int repeatValue, DateTime month) {
//     GetIt.I<BillFormCubit>().updateRepeatCount(repeatValue);
//     GetIt.I<BillFormCubit>()
//         .updateRepeatMonthName(getMonthName(month, withYear: true));
//   }

//   void _showRevenueWarning(MissingRevenueType type) {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) => RevenueMissingWarningBottomsheet(type: type));
//   }
// }
