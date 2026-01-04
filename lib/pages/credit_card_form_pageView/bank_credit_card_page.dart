part of 'credit_card_form_page_view.dart';

class BankCreditCardPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const BankCreditCardPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<BankCreditCardPage> createState() => _BankCreditCardPageState();
}

class _BankCreditCardPageState extends State<BankCreditCardPage> {
  @override
  void initState() {
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    bool hasCategorySelected = GetIt.I<CreditCardFormCubit>().state.bankId != 0;
    if (hasCategorySelected) {
      return true;
    } else {
      widget.onError('É obrigatório a seleção de um banco');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'De qual banco esse cartão pertence?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .05),
        BlocBuilder<CreditCardFormCubit, CreditCardFormState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) => previous.bankId != current.bankId,
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Banks.all.length,
                  itemBuilder: (context, index) {
                    bool isSelected = Banks.all[index].id == state.bankId;
                    return Column(
                      //arrumar as imagens que não estão sendo achadas
                      children: [
                        GestureDetector(
                          onTap: () => GetIt.I<CreditCardFormCubit>()
                              .updateBankId(Banks.all[index].id),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 20),
                            alignment: Alignment.center,
                            height: 60,
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.colors.hintColor
                                    : AppTheme.colors.itemBackgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            width: mediaQuery.width * .85,
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    fit: BoxFit.cover,
                                    isAntiAlias: true,
                                    Banks.all[index].iconPath,
                                    height: 35,
                                    width: 35,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  Banks.all[index].name,
                                  style: AppTheme.textStyles.bodyTextStyle,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
      ],
    );
  }
}
