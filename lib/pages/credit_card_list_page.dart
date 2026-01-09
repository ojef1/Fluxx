import 'package:Fluxx/blocs/credit_card_cubits/credit_card_form_cubit.dart'
    as formcubit;
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_list_cubit.dart';
import 'package:Fluxx/components/secondary_button.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_credit_card_list.dart';
import 'package:Fluxx/models/bank_model.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreditCardListPage extends StatefulWidget {
  const CreditCardListPage({super.key});

  @override
  State<CreditCardListPage> createState() => _CreditCardListPageState();
}

class _CreditCardListPageState extends State<CreditCardListPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    GetIt.I<CreditCardListCubit>().getActiveCardsList();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<formcubit.CreditCardFormCubit,
        formcubit.CreditCardFormState>(
      listenWhen: (previous, current) =>
          previous.responseStatus != current.responseStatus,
      bloc: GetIt.I(),
      listener: (context, state) {
        if (state.responseStatus == formcubit.ResponseStatus.success) {
          init();
        }
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppTheme.colors.appBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: const CustomAppBar(title: 'Lista de Cartões'),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * .05,
              ),
              child: Column(
                children: [
                  const SizedBox(height: Constants.topMargin),
                  BlocBuilder<CreditCardListCubit, CreditCardListState>(
                    bloc: GetIt.I(),
                    buildWhen: (previous, current) =>
                        previous.cardList != current.cardList,
                    builder: (context, state) {
                      if (state.cardList.isEmpty) {
                        return EmptyCreditCardList(
                          onPressed: () => goToCreditCardForm(context: context),
                          title:
                              'Parece que você não possui nenhum cartão ainda',
                          subTitle: 'Clique aqui para criar',
                        );
                      } else {
                        return Expanded(
                          child: Column(
                            spacing: 35,
                            children: [
                              SecondaryButton(
                                title: 'Adicionar',
                                icon: Icons.add_rounded,
                                onPressed: () =>
                                    goToCreditCardForm(context: context),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.cardList.length,
                                itemBuilder: (context, index) {
                                  CreditCardModel card = state.cardList[index];
                                  BankModel bank = getBank(card.bankId!);
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      shape: BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      tileColor:
                                          AppTheme.colors.itemBackgroundColor,
                                      isThreeLine: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            card.name ?? '',
                                            style: AppTheme
                                                .textStyles.tileTextStyle
                                                .copyWith(
                                              color: AppTheme
                                                  .colors.primaryTextColor,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 18,
                                            color: AppTheme.colors.hintColor,
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Row(
                                          spacing: 10,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                spacing: 15,
                                                children: [
                                                  ClipOval(
                                                    child: Image.asset(
                                                      fit: BoxFit.cover,
                                                      isAntiAlias: true,
                                                      bank.iconPath,
                                                      height: 25,
                                                      width: 25,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      bank.name,
                                                      style: AppTheme.textStyles
                                                          .secondaryTextStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'final ${card.lastFourDigits}',
                                                  style: AppTheme.textStyles
                                                      .secondaryTextStyle,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () => goToCreditCardInfo(
                                          context: context, id: card.id!),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
