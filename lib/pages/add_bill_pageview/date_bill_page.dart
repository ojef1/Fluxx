part of 'add_bill_pageview.dart';

class DateBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const DateBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<DateBillPage> createState() => _DateBillPageState();
}

class _DateBillPageState extends State<DateBillPage> {
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
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Quando essa conta foi/deverá ser paga?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .03),
        DateSelector(
          onDateSelected: (date) {},
        ),
      ],
    );
  }
}

class DateSelector extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.onDateSelected,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime selectedDate = () {
    DateTime? selectedDateFromState;
    try {
      selectedDateFromState =
          DateFormat('dd/MM/yyyy').parse(GetIt.I<AddBillCubit>().state.date);
    } catch (_) {
      // Em caso de erro, só deixa null mesmo
      selectedDateFromState = null;
    }
    var selectedDate = selectedDateFromState ?? DateTime.now();
    GetIt.I<AddBillCubit>().updateDate(selectedDate.toString());
    return selectedDate;
  }();

  void _selectDay(DateTime date) {
    setState(() => selectedDate = date);
    GetIt.I<AddBillCubit>().updateDate(date.toString());
    widget.onDateSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _quickButton(
              "Ontem",
              DateTime.now().subtract(const Duration(days: 1)),
            ),
            _quickButton("Hoje", DateTime.now()),
            _quickButton(
              "Amanhã",
              DateTime.now().add(const Duration(days: 1)),
            ),
          ],
        ),
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

  Widget _quickButton(String label, DateTime date) {
    final bool isSelected = _isSameDay(date, selectedDate);

    return GestureDetector(
      onTap: () => _selectDay(date),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.colors.hintColor
              : AppTheme.colors.itemBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppTheme.textStyles.subTileTextStyle
                  .copyWith(color: AppTheme.colors.white)
              : AppTheme.textStyles.subTileTextStyle,
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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

  void _changeMonth(int offset) {
    final nextMonth = DateTime(focusedMonth.year, focusedMonth.month + offset);

    final int currentYear = DateTime.now().year;

    if (nextMonth.year != currentYear) return;

    setState(() => focusedMonth = nextMonth);
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
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _arrowButton(Icons.chevron_left, () => _changeMonth(-1)),
              Text(
                DateFormat("MMMM yyyy").format(focusedMonth),
                style: AppTheme.textStyles.tileTextStyle,
              ),
              _arrowButton(Icons.chevron_right, () => _changeMonth(1)),
            ],
          ),

          const SizedBox(height: 15),

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

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.colors.appBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.colors.white),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
