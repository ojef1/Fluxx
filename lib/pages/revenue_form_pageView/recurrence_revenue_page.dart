part of 'revenue_form_page_view.dart';

class RecurrenceRevenuePage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  final MonthModel currentMonth;
  const RecurrenceRevenuePage(
      {super.key, required this.registerValidator, required this.onError, required this.currentMonth});
  @override
  State<RecurrenceRevenuePage> createState() => _RecurrenceRevenuePageState();
}

class _RecurrenceRevenuePageState extends State<RecurrenceRevenuePage> {
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
                                  'Elas começarão a valer a partir desse mês (${widget.currentMonth.name}).',
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
                          : Column(
                            spacing: 10,
                            children: [
                              Text(
                                  'Rendas únicas servirão apenas para o mês em questão.',
                                  style: AppTheme.textStyles.subTileTextStyle
                                      .copyWith(
                                          color: AppTheme.colors.hintTextColor
                                              .withAlpha(100)),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                              Text(
                                  'Nesse caso ela existirá apenas para o mês de ${widget.currentMonth.name}.',
                                  style: AppTheme.textStyles.subTileTextStyle
                                      .copyWith(
                                          color: AppTheme.colors.hintTextColor
                                              .withAlpha(100)),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                            ],
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
