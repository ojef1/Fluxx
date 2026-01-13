part of 'bill_form_page_view.dart';

class PaymentBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const PaymentBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<PaymentBillPage> createState() => _PaymentBillPageState();
}

class _PaymentBillPageState extends State<PaymentBillPage> {
  @override
  void initState() {
    init();
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    //a receita é opcional então não precisa validar nada
    return true;
  }

  Future<void> init() async {
    var selectedMonthId = GetIt.I<BillFormCubit>().state.selectedMonth!.id!;
    GetIt.I<RevenueCubit>().getRevenues(selectedMonthId);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual receita você usou/usará para pagar\n essa conta?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          textAlign: TextAlign.center,
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
        BlocBuilder<RevenueCubit, RevenueState>(
          bloc: GetIt.I(),
          buildWhen: (previous, current) =>
              previous.getRevenueResponse != current.getRevenueResponse,
          builder: (context, state) {
            switch (state.getRevenueResponse) {
              case GetRevenueResponse.initial:
              case GetRevenueResponse.loading:
                return const CustomLoading();
              case GetRevenueResponse.error:
                return Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Erro ao carregar as receitas!',
                          style: AppTheme.textStyles.subTileTextStyle,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => init(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colors.hintColor,
                            minimumSize: const Size(50, 50),
                          ),
                          child: Text('Tentar novamente',
                              style: AppTheme.textStyles.bodyTextStyle),
                        ),
                      ],
                    ),
                  ),
                );
              case GetRevenueResponse.success:
                if (state.availableRevenues.isEmpty) {
                  return EmptyRevenueList(
                    onPressed: () => goToRevenueForm(context: context),
                  );
                } else {
                  return _PaymentBillPageContent(
                      availableRevenues: state.availableRevenues);
                }
            }
          },
        ),
      ],
    );
  }
}

void _showUnavailableDialog(BuildContext context, String name) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppTheme.colors.appBackgroundColor,
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          maxLines: 4,
          textAlign: TextAlign.center,
          'Oops!',
          style: AppTheme.textStyles.tileTextStyle,
        ),
        content: Text(
          maxLines: 4,
          textAlign: TextAlign.center,
          '" $name " não está disponível pois o valor da conta é maior que o valor disponível.',
          style: AppTheme.textStyles.subTileTextStyle,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors.hintColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'OK',
              style: AppTheme.textStyles.bodyTextStyle,
            ),
          ),
        ],
      );
    },
  );
}

void _selectRevenue(RevenueModel revenue) {
  GetIt.I<BillFormCubit>().updateRevenue(revenue);
}

bool _verifyAvailability(double billValue, double revenueValue) {
  if (billValue <= revenueValue) {
    return true;
  } else {
    return false;
  }
}

class _PaymentBillPageContent extends StatelessWidget {
  final List<RevenueModel> availableRevenues;
  const _PaymentBillPageContent({required this.availableRevenues});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocBuilder<BillFormCubit, BillFormState>(
        bloc: GetIt.I(),
        buildWhen: (previous, current) =>
            previous.revenueSelected != current.revenueSelected,
        builder: (context, addState) {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableRevenues.length,
              itemBuilder: (context, index) {
                bool available = _verifyAvailability(
                    addState.price, availableRevenues[index].value ?? 0.0);
                bool isSelected =
                    availableRevenues[index].id == addState.revenueSelected?.id;
                return Column(
                  children: [
                    PrimaryButton(
                      color: isSelected
                          ? AppTheme.colors.hintColor
                          : AppTheme.colors.itemBackgroundColor,
                      textStyle: AppTheme.textStyles.bodyTextStyle,
                      width: mediaQuery.width * .85,
                      text: availableRevenues[index].name ?? '',
                      onPressed: !available
                          ? () => _showUnavailableDialog(
                                context,
                                availableRevenues[index].name ?? '',
                              )
                          : () => _selectRevenue(
                                availableRevenues[index],
                              ),
                    ),
                    if (availableRevenues.length - 1 == index)
                      const SizedBox(height: 24),
                    if (availableRevenues.length - 1 == index)
                      PrimaryButton(
                        color: AppTheme.colors.itemBackgroundColor,
                        textStyle: AppTheme.textStyles.bodyTextStyle
                            .copyWith(color: AppTheme.colors.hintColor),
                        width: mediaQuery.width * .85,
                        text: 'Adicionar mais Receitas',
                        onPressed: () => goToRevenueForm(context: context),
                      ),
                  ],
                );
              },
            ),
          );
        });
  }
}
