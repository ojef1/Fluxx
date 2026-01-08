import 'package:Fluxx/blocs/invoices_cubits/invoices_list_cubit.dart';
import 'package:Fluxx/components/add_button.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_bill_list.dart';
import 'package:Fluxx/components/invoice_item.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InvoicesListPage extends StatelessWidget {
  const InvoicesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<InvoicesListCubit, InvoicesListState>(
        buildWhen: (previous, current) => previous.status != current.status,
        bloc: GetIt.I(),
        builder: (context, state) {
          switch (state.status) {
            case ResponseStatus.initial:
            case ResponseStatus.loading:
              return const CustomLoading();
            case ResponseStatus.error:
              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                  child: Text(
                    'Erro ao carregar as faturas.',
                    style: AppTheme.textStyles.secondaryTextStyle,
                  ),
                ),
              );
            case ResponseStatus.success:
              return const _InvoiceListPageContent();
          }
        },
      ),
    );
  }
}

class _InvoiceListPageContent extends StatefulWidget {
  const _InvoiceListPageContent();

  @override
  State<_InvoiceListPageContent> createState() =>
      __InvoiceListPageContentState();
}

class __InvoiceListPageContentState extends State<_InvoiceListPageContent> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocBuilder<InvoicesListCubit, InvoicesListState>(
        buildWhen: (previous, current) =>
            previous.invoicesList != current.invoicesList,
        bloc: GetIt.I(),
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Constants.topMargin),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: mediaQuery.width * .06),
                child: AddButton(
                  onPressed: () => goToInvoiceBillForm(context: context),
                ),
              ),
              const SizedBox(height: 40),
              state.invoicesList.isEmpty
                  ? EmptyBillList(onPressed: () {})
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.invoicesList.length,
                      itemBuilder: (context, index) {
                        CreditCardModel card = getCardFromInvoice(
                            cards: state.cardsList,
                            invoice: state.invoicesList[index]);
                        return Column(
                          children: [
                            InvoiceItem(
                              invoice: state.invoicesList[index],
                              card: card,
                            ),
                            if (index == state.invoicesList.length)
                              SizedBox(height: mediaQuery.height * .5),
                          ],
                        );
                      },
                    )
            ],
          );
        });
  }
}
