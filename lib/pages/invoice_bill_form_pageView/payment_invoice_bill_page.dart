part of 'invoice_bill_form_page_view.dart';

class PaymentInvoiceBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const PaymentInvoiceBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<PaymentInvoiceBillPage> createState() => _PaymentInvoiceBillPageState();
}

class _PaymentInvoiceBillPageState extends State<PaymentInvoiceBillPage> {
  @override
  void initState() {
    init();
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    var cardSelected = GetIt.I<InvoiceBillFormCubit>().state.cardSelected;
    var billPrice = GetIt.I<InvoiceBillFormCubit>().state.price;
    if (cardSelected != null) {
      bool isAvailable =
          _verifyAvailability(billPrice, cardSelected.creditLimit!);
      if (isAvailable) return true;
      _showUnavailableDialog(context, cardSelected.name ?? '');
      return false;
    } else {
      widget.onError('É obrigatório a seleção de um cartão');
      return false;
    }
  }

  Future<void> init() async {
    GetIt.I<InvoiceBillFormCubit>().getCards();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<cardform.CreditCardFormCubit,
        cardform.CreditCardFormState>(
        bloc: GetIt.I(),
      listenWhen: (previous, current) =>
          previous.responseStatus != current.responseStatus,
      listener: (context, state) {
        if (state.responseStatus == cardform.ResponseStatus.success) {
          init();
        }
        //próximo passo é criar contas parceladas
      },
      child: Column(
        children: [
          Text(
            'Em qual cartão essa compra foi feita?',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: mediaQuery.height * .05),
          BlocBuilder<InvoiceBillFormCubit, InvoiceBillFormState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) =>
                previous.cardsList != current.cardsList,
            builder: (context, state) {
              if (state.responseStatus == ResponseStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (state.cardsList.isEmpty) {
                  return EmptyRevenueList(
                    onPressed: () => goToCreditCardForm(context: context),
                  );
                } else {
                  return BlocBuilder<InvoiceBillFormCubit,
                          InvoiceBillFormState>(
                      bloc: GetIt.I(),
                      buildWhen: (previous, current) =>
                          previous.cardSelected != current.cardSelected,
                      builder: (context, addState) {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.cardsList.length,
                            itemBuilder: (context, index) {
                              CreditCardModel card = state.cardsList[index];
                              BankModel bank = getBank(card.bankId!);
                              bool available = _verifyAvailability(
                                  addState.price,
                                  state.cardsList[index].creditLimit ?? 0.0);
                              bool isSelected = state.cardsList[index].id ==
                                  addState.cardSelected?.id;
                              return Column(
                                children: [
                                  Container(
                                    width: mediaQuery.width * .85,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      shape: BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      tileColor: isSelected
                                          ? AppTheme.colors.hintColor
                                          : AppTheme.colors.itemBackgroundColor,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                      title: Row(
                                        children: [
                                          Column(
                                            spacing: 5,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipOval(
                                                child: Image.asset(
                                                  fit: BoxFit.cover,
                                                  isAntiAlias: true,
                                                  bank.iconPath,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              Text(
                                                'final ${card.lastFourDigits}',
                                                style: AppTheme.textStyles
                                                    .secondaryTextStyle
                                                    .copyWith(
                                                  color: isSelected
                                                      ? AppTheme.colors.white
                                                      : AppTheme
                                                          .colors.hintTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              spacing: 5,
                                              children: [
                                                Text(card.name ?? '',
                                                    style: AppTheme.textStyles
                                                        .bodyTextStyle),
                                                Text(
                                                  'Limite disponível : R\$${formatPrice(card.creditLimit ?? 0.0)}',
                                                  style: AppTheme.textStyles
                                                      .secondaryTextStyle
                                                      .copyWith(
                                                    color: isSelected
                                                        ? AppTheme.colors.white
                                                        : AppTheme.colors
                                                            .hintTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: !available
                                          ? () => _showUnavailableDialog(
                                                context,
                                                card.name ?? '',
                                              )
                                          : () => _selectRevenue(card),
                                    ),
                                  ),
                                  if (state.cardsList.length - 1 == index)
                                    const SizedBox(height: 24),
                                  if (state.cardsList.length - 1 == index)
                                    PrimaryButton(
                                      color:
                                          AppTheme.colors.itemBackgroundColor,
                                      textStyle: AppTheme
                                          .textStyles.bodyTextStyle
                                          .copyWith(
                                              color: AppTheme.colors.hintColor),
                                      width: mediaQuery.width * .85,
                                      text: 'Adicionar mais Cartões',
                                      onPressed: () =>
                                          goToCreditCardForm(context: context),
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
      ),
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

  void _selectRevenue(CreditCardModel card) {
    GetIt.I<InvoiceBillFormCubit>().updateCard(card);
  }

  bool _verifyAvailability(double billValue, double revenueValue) {
    if (billValue <= revenueValue) {
      return true;
    } else {
      return false;
    }
  }
}
