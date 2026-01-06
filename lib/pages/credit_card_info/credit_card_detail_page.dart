import 'package:Fluxx/blocs/credit_card_cubits/credit_card_form_cubit.dart'
    as formcubit;
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_info_cubit.dart';
import 'package:Fluxx/models/bank_model.dart';
import 'package:Fluxx/models/card_network_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreditCardDetailPage extends StatefulWidget {
  const CreditCardDetailPage({super.key});

  @override
  State<CreditCardDetailPage> createState() => _CreditCardDetailPageState();
}

class _CreditCardDetailPageState extends State<CreditCardDetailPage> {
  late final String idToGet;

  @override
  void initState() {
    idToGet = GetIt.I<CreditCardInfoCubit>().state.idToGet;
    super.initState();
  }

  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<formcubit.CreditCardFormCubit,
        formcubit.CreditCardFormState>(
      bloc: GetIt.I(),
      listenWhen: (previous, current) =>
          previous.responseStatus != current.responseStatus,
      listener: (context, state) {
        if (state.responseStatus == formcubit.ResponseStatus.success) {
          GetIt.I<CreditCardInfoCubit>().getCreditCardById(idToGet);
        }
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) => _exit(didPop),
          child: SafeArea(
            child: SingleChildScrollView(
              child: BlocBuilder<CreditCardInfoCubit, CreditCardInfoState>(
                bloc: GetIt.I(),
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, loadState) {
                  switch (loadState.status) {
                    case ResponseStatus.initial:
                    case ResponseStatus.loading:
                      return Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: Center(
                          child: CircularProgressIndicator(
                            constraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                            backgroundColor: AppTheme.colors.hintColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.colors.lightHintColor),
                          ),
                        ),
                      );
                    case ResponseStatus.error:
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Center(child: Text('Erro ao carregar os detalhes.')),
                      );
                    case ResponseStatus.success:
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width * .08,
                        ),
                        child: BlocBuilder<CreditCardInfoCubit,
                            CreditCardInfoState>(
                          bloc: GetIt.I(),
                          buildWhen: (previous, current) =>
                              previous.card != current.card,
                          builder: (context, state) {
                            BankModel bank = getBank(state.card?.bankId ?? 0);
                            CardNetworkModel cardNetwork =
                                getCardNetwork(state.card?.networkId ?? 0);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    const Spacer(),
                                    IconButton.filled(
                                      onPressed: () => goToCreditCardForm(
                                          context: context,
                                          creditCard: state.card),
                                      icon: Icon(
                                        Icons.mode_edit_rounded,
                                        color: AppTheme.colors.white,
                                      ),
                                      style: IconButton.styleFrom(
                                          minimumSize: const Size(55, 55),
                                          backgroundColor:
                                              AppTheme.colors.hintColor),
                                    ),
                                    const Spacer(),
                                    IconButton.filled(
                                      onPressed: () => _showDeleteDialog(
                                          context, state.card?.id ?? ''),
                                      icon: Icon(
                                        Icons.delete_forever_rounded,
                                        color: AppTheme.colors.white,
                                      ),
                                      style: IconButton.styleFrom(
                                          minimumSize: const Size(55, 55),
                                          backgroundColor:
                                              AppTheme.colors.hintColor),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 65),
                                _DataItem(
                                    title: 'Nome do cartão de crédito',
                                    subtitle: state.card?.name ?? ''),
                                _DataItem(
                                    title: 'Limite do cartão',
                                    subtitle:
                                        'R\$${formatPrice(state.card?.creditLimit ?? 0.0)}'),
                                _DataItem(
                                  title: 'Banco',
                                  subtitle: bank.name,
                                  iconPath: bank.iconPath,
                                ),
                                _DataItem(
                                  title: 'Bandeira',
                                  subtitle: cardNetwork.name,
                                  iconPath: cardNetwork.iconPath,
                                ),
                                _DataItem(
                                    title: '4 últimos digitos',
                                    subtitle: state.card?.lastFourDigits ?? ''),
                                _DataItem(
                                    title: 'Data de fechamento da fatura',
                                    subtitle:
                                        'Todo dia ${formatDate(state.card?.closingDay.toString()) ?? 'Nenhuma'}'),
                                _DataItem(
                                    title: 'Data de vencimento da fatura',
                                    subtitle:
                                        'Todo dia ${formatDate(state.card?.dueDay.toString()) ?? 'Nenhuma'}'),
                              ],
                            );
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exit(bool fromPopInvoked) async {
    if (!fromPopInvoked) Navigator.pop(context);
  }

  void _showDeleteDialog(BuildContext context, String id) {
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
            'Tem certeza de que deseja excluir este item?',
            style: AppTheme.textStyles.tileTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: AppTheme.textStyles.secondaryTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _disableItem(id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Excluir',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _disableItem(String id) async {
    var result = await GetIt.I<CreditCardInfoCubit>().disableCreditCard(id);
    var state = GetIt.I<CreditCardInfoCubit>().state;
    if (result > 0) {
      goToHomePage(context: context);
      showFlushbar(context, state.responseMessage, false);
    } else {
      showFlushbar(context, state.responseMessage, true);
    }
  }
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
