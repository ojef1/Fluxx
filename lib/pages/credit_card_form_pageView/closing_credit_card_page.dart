part of 'credit_card_form_page_view.dart';

class ClosingCreditCardPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const ClosingCreditCardPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<ClosingCreditCardPage> createState() => _ClosingCreditCardPageState();
}

class _ClosingCreditCardPageState extends State<ClosingCreditCardPage> {
  @override
  void initState() {
    super.initState();
    widget.registerValidator(_validate);
  }

  Future<bool> _validate() async {
    //o calendário sempre inicia com a data de hoje então não precisa validara seleção
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      children: [
        Text(
          'Quando esse cartão fecha a fatura?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        DateSelector(
          selectedDateFromState: GetIt.I<CreditCardFormCubit>().state.closingDay,
          onDateSelected: (date) =>
              GetIt.I<CreditCardFormCubit>().updateClosingDay(date),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            spacing: 10,
            children: [
              Text(
                'Não se incomode com a sequência exata dos dias, precisamos apenas do número exato do dia.',
                style: AppTheme.textStyles.subTileTextStyle.copyWith(
                    color: AppTheme.colors.hintTextColor.withAlpha(100)),
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              Text(
                'Ex. todo dia 20.',
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

class DateSelector extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? selectedDateFromState;

  const DateSelector({
    super.key,
    required this.onDateSelected, required this.selectedDateFromState,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    selectedDate = widget.selectedDateFromState ?? DateTime.now();

    widget.onDateSelected(selectedDate);
  }

  void _selectDay(DateTime date) {
    setState(() => selectedDate = date);
    widget.onDateSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: _CalendarWidget(
            selectedDate: selectedDate,
            onDateSelected: _selectDay,
          ),
        ),
      ],
    );
  }
}

class _CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarWidget({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<_CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<_CalendarWidget> {
  late DateTime focusedMonth;

  @override
  void initState() {
    super.initState();
    focusedMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth =
        DateUtils.getDaysInMonth(focusedMonth.year, focusedMonth.month);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.itemBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"]
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: AppTheme.textStyles.secondaryTextStyle,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox.shrink();

              final dayNumber = index - firstWeekday + 1;
              final date =
                  DateTime(focusedMonth.year, focusedMonth.month, dayNumber);

              final bool isSelected = _isSameDay(date, widget.selectedDate);

              return GestureDetector(
                onTap: () => widget.onDateSelected(date),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.colors.hintColor
                        : AppTheme.colors.appBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "$dayNumber",
                      style: TextStyle(
                        color: AppTheme.colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
