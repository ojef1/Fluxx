part of 'credit_card_form_page_view.dart';

class NetworkCreditCardPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const NetworkCreditCardPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<NetworkCreditCardPage> createState() => _NetworkCreditCardPageState();
}

class _NetworkCreditCardPageState extends State<NetworkCreditCardPage> {
  @override
  void initState() {
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    //a receita é opcional então não precisa validar nada
    return true;
  }


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Qual a bandeira desse cartão?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .05),
        BlocBuilder<CreditCardFormCubit, CreditCardFormState>(
            bloc: GetIt.I(),
            buildWhen: (previous, current) =>
                previous.networkId != current.networkId,
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: CardNetwork.all.length,
                  itemBuilder: (context, index) {
                    bool isSelected = CardNetwork.all[index].id == state.networkId;
                     return Column(
                      children: [
                        GestureDetector(
                          onTap: () => GetIt.I<CreditCardFormCubit>()
                              .updateNetworkId(CardNetwork.all[index].id),
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
                                    CardNetwork.all[index].iconPath,
                                    height: 35,
                                    width: 35,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  CardNetwork.all[index].name,
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
