part of 'add_bill_pageview.dart';

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
    //a renda é opcional então não precisa validar nada
    return true;
  }

  Future<void> init() async {
    var monthInFocus = GetIt.I<ResumeCubit>().state.monthInFocus;
    GetIt.I<RevenueCubit>().calculateAvailableValue(monthInFocus!.id!);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual renda você usou/usará para pagar\n essa conta?',
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
              previous.availableRevenues != current.availableRevenues,
          builder: (context, state) {
            if (state.getRevenueResponse == GetRevenueResponse.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (state.availableRevenues.isEmpty) {
                return EmptyRevenueList(
                  onPressed: () {
                      RevenueModel revenue = RevenueModel();
                    Navigator.pushNamed(context, AppRoutes.addRevenuePage,
                            arguments: revenue)
                        .then(
                      (value) => init(),
                    );
                  },
                );
              } else {
                log('Available Revenues: ${state.availableRevenues}', name: '_PaymentBillPageState');
                return BlocBuilder<AddBillCubit, AddBillState>(
                    bloc: GetIt.I(),
                    buildWhen: (previous, current) =>
                        previous.revenueSelected != current.revenueSelected,
                    builder: (context, addState) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.availableRevenues.length,
                          itemBuilder: (context, index) {
                            bool available = _verifyAvailability(addState.price,
                                state.availableRevenues[index].value ?? 0.0);
                            bool isSelected = state.availableRevenues[index] ==
                                addState.revenueSelected;
                             return Column(
                              children: [
                                PrimaryButton(
                                  color: isSelected
                                      ? AppTheme.colors.hintColor
                                      : AppTheme.colors.itemBackgroundColor,
                                  textStyle: AppTheme.textStyles.bodyTextStyle,
                                  width: mediaQuery.width * .85,
                                  text:
                                      state.availableRevenues[index].name ?? '',
                                  onPressed: !available
                                      ? () => _showUnavailableDialog(
                                            context,
                                            state.availableRevenues[index]
                                                    .name ??
                                                '',
                                          )
                                      : () => _selectRevenue(
                                            state.availableRevenues[index],
                                          ),
                                ),
                                if (state.availableRevenues.length - 1 == index)
                                  const SizedBox(height: 24),
                                if (state.availableRevenues.length - 1 == index)
                                  PrimaryButton(
                                    color: AppTheme.colors.itemBackgroundColor,
                                    textStyle: AppTheme.textStyles.bodyTextStyle
                                        .copyWith(
                                            color: AppTheme.colors.hintColor),
                                    width: mediaQuery.width * .85,
                                    text: 'Adicionar mais Rendas',
                                    onPressed: () {
                                      RevenueModel revenue = RevenueModel();
                                      return Navigator.pushNamed(
                                              context, AppRoutes.addRevenuePage,
                                              arguments: revenue)
                                          .then(
                                        (value) => init(),
                                      );
                                    },
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    });
              }
            }
          },
        ),
      ],
    );
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
    GetIt.I<AddBillCubit>().updateRevenue(revenue);
  }

  bool _verifyAvailability(double billValue, double revenueValue) {
    if (billValue <= revenueValue) {
      return true;
    } else {
      return false;
    }
  }
}
