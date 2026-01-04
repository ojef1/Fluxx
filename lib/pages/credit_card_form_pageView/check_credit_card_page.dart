part of 'credit_card_form_page_view.dart';

class CheckCreditCardPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const CheckCreditCardPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<CheckCreditCardPage> createState() => _CheckCreditCardPageState();
}

class _CheckCreditCardPageState extends State<CheckCreditCardPage> {
  @override
  void initState() {
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    var state = GetIt.I<CreditCardFormCubit>().state;
    if (state.name.isEmpty) {
      showFlushbar(context, 'A conta precisa ter um nome', true);
      return false;
    }
    if (state.creditLimit == 0.0) {
      showFlushbar(context, 'A conta não pode ser R\$00,00', true);
      return false;
    }
    if (state.closingDay == 0) {
      showFlushbar(context, 'Escolha a data de pagamento', true);
      return false;
    }
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
            'Revise os dados antes de adicionar',
            style: AppTheme.textStyles.subTileTextStyle,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: mediaQuery.height * .05),
          BlocBuilder<CreditCardFormCubit, CreditCardFormState>(
              bloc: GetIt.I(),
              builder: (context, state) {
                BankModel bank = getBank(state.bankId);
                CardNetworkModel cardNetwork = getCardNetwork(state.networkId);

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: mediaQuery.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DataItem(
                          title: 'Nome do cartão de crédito',
                          subtitle: state.name),
                      _DataItem(
                          title: 'Limite do cartão',
                          subtitle: 'R\$${formatPrice(state.creditLimit)}'),
                      _DataItem(title: 'Banco', subtitle: bank.name, iconPath: bank.iconPath,),
                      _DataItem(title: 'Bandeira', subtitle: cardNetwork.name, iconPath: cardNetwork.iconPath,),
                      _DataItem(
                          title: '4 últimos digitos',
                          subtitle: state.lastFourDigits),
                      _DataItem(
                          title: 'Data de fechamento da fatura',
                          subtitle:
                              'Todo dia ${formatDate(state.closingDay!.day.toString()) ?? 'Nenhuma'}'),
                      _DataItem(
                          title: 'Data de vencimento da fatura',
                          subtitle:
                              'Todo dia ${formatDate(state.dueDay!.day.toString()) ?? 'Nenhuma'}'),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

BankModel getBank(int bankId) {
  return Banks.all.firstWhere((bank) => bank.id == bankId);
}

CardNetworkModel getCardNetwork(int cardNetworkId) {
  return CardNetwork.all.firstWhere((bank) => bank.id == cardNetworkId);
}

class _DataItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? iconPath;
  const _DataItem({
    required this.title,
    required this.subtitle,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(
          title,
          style: AppTheme.textStyles.secondaryTextStyle
              .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subtitle.isNotEmpty
                  ? subtitle
                  : 'sem ${title.toLowerCase()} informado(a)',
              style: AppTheme.textStyles.subTileTextStyle,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            if (iconPath != null)
              ClipOval(
                child: Image.asset(
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                  iconPath!,
                  height: 25,
                  width: 25,
                ),
              ),
          ],
        ),
        Divider(
          color: AppTheme.colors.hintTextColor,
          thickness: 1,
        ),
      ],
    );
  }
}
