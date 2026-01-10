import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_cubit.dart'
    as invoicecubit;
import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_list_cubit.dart';
import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_form_cubit.dart'
    as invoiceform;
import 'package:Fluxx/blocs/invoices_cubits/invoice_payment_cubit.dart' as invoicepayment;
import 'package:Fluxx/components/empty_list_placeholder/empty_invoice_bill_list.dart';
import 'package:Fluxx/components/secondary_button.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/components/invoice_bill_item.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InvoiceBillsPage extends StatefulWidget {
  const InvoiceBillsPage({super.key});

  @override
  State<InvoiceBillsPage> createState() => _InvoiceBillsPageState();
}

class _InvoiceBillsPageState extends State<InvoiceBillsPage> {
  @override
  void initState() {
    GetIt.I<InvoiceBillListCubit>().getInvoiceBills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ListenerWrapper(
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppTheme.colors.appBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: const CustomAppBar(title: 'Fatura'),
          body: SafeArea(
            child: SingleChildScrollView(
              child: BlocBuilder<InvoiceBillListCubit, InvoiceListBillState>(
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
                            'Erro ao carregar as contas da fatura.',
                            style: AppTheme.textStyles.secondaryTextStyle,
                          ),
                        ),
                      );
                    case ResponseStatus.success:
                    if(state.bills.isEmpty){
                      return EmptyInvoiceBillList(
                          onPressed: () => goToInvoiceBillForm(context: context),
                          title:
                              'Parece que você não possui compras',
                          subTitle: 'Clique aqui para adicionar',
                        );
                    }else{

                      return const _InvoiceBillsPageContent();
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InvoiceBillsPageContent extends StatefulWidget {
  const _InvoiceBillsPageContent();

  @override
  State<_InvoiceBillsPageContent> createState() =>
      __InvoiceBillsPageContentState();
}

class __InvoiceBillsPageContentState extends State<_InvoiceBillsPageContent> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocBuilder<InvoiceBillListCubit, InvoiceListBillState>(
      bloc: GetIt.I(),
      buildWhen: (previous, current) => previous.bills != current.bills,
      builder: (context, state) {
        bool invoiceClosed = isInvoiceClosed(endDate : state.invoice?.endDate);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Constants.topMargin),
            //também só vai aparecer se a fatura tiver fechada
            if (state.invoice!.isPaid == 0 && invoiceClosed)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: mediaQuery.width * .06),
                child: SecondaryButton(
                  title: 'Pagar Fatura',
                  icon: Icons.attach_money_rounded,
                  onPressed: () => goToInvoicePaymentPage(
                      context: context, invoice: state.invoice!),
                ),
              ),
            const SizedBox(height: 40),
            ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.bills.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InvoiceBillItem(bill: state.bills[index]),
                          if (index == state.bills.length)
                            SizedBox(height: mediaQuery.height * .5),
                        ],
                      );
                    },
                  )
          ],
        );
      },
    );
  }
}

class _ListenerWrapper extends StatelessWidget {
  final Widget child;
  const _ListenerWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<invoiceform.InvoiceBillFormCubit,
            invoiceform.InvoiceBillFormState>(
          listenWhen: (previous, current) =>
              previous.responseStatus != current.responseStatus,
          bloc: GetIt.I(),
          listener: (context, state) {
            if (state.responseStatus == invoiceform.ResponseStatus.success) {
              GetIt.I<InvoiceBillListCubit>().getInvoiceBills();
            }
          },
        ),
        BlocListener<invoicecubit.InvoiceBillCubit,
            invoicecubit.InvoiceBillState>(
          listenWhen: (previous, current) => previous.status != current.status,
          bloc: GetIt.I(),
          listener: (context, state) {
            if (state.status == invoicecubit.ResponseStatus.success) {
              GetIt.I<InvoiceBillListCubit>().getInvoiceBills();
            }
          },
        ),
        BlocListener<invoicepayment.InvoicePaymentCubit, invoicepayment.InvoicePaymentState>(
          bloc: GetIt.I(),
          listenWhen: (previous, current) =>
              previous.paymentStatus != current.paymentStatus,
          listener: (context, state) {
            if (state.paymentStatus == invoicepayment.PaymentResponseStatus.success) {
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: child,
    );
  }
}
