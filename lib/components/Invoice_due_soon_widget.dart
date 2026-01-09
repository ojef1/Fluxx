import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/components/invoice_item.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InvoiceDueSoonWidget extends StatefulWidget {
  const InvoiceDueSoonWidget({super.key});

  @override
  State<InvoiceDueSoonWidget> createState() => _InvoiceDueSoonWidgetState();
}

class _InvoiceDueSoonWidgetState extends State<InvoiceDueSoonWidget> {
  @override
  void initState() {
    GetIt.I<ResumeCubit>().getPriorityInvoice();
    super.initState();
  }

  void init() async {
    GetIt.I<ResumeCubit>().getPriorityInvoice();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumeCubit, ResumeState>(
      buildWhen: (previous, current) =>
          previous.priorityInvoiceStatus != current.priorityInvoiceStatus,
      bloc: GetIt.I(),
      builder: (context, state) {
        switch (state.priorityInvoiceStatus) {
          case GetPriorityInvoiceStatus.initial:
          case GetPriorityInvoiceStatus.loading:
            return const CustomLoading();
          case GetPriorityInvoiceStatus.error:
            return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                child: Text(
                  'Erro ao carregar a fatura.',
                  style: AppTheme.textStyles.secondaryTextStyle,
                ),
              ),
            );
          case GetPriorityInvoiceStatus.success:
            if(state.priorityInvoice !=null){

            return const _InvoiceDueSoonContent();
            }else{
              return const SizedBox();
            }
        }
      },
    );
  }
}

class _InvoiceDueSoonContent extends StatelessWidget {
  const _InvoiceDueSoonContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumeCubit, ResumeState>(
      buildWhen: (previous, current) =>
          previous.priorityInvoiceStatus != current.priorityInvoiceStatus,
      bloc: GetIt.I(),
      builder: (context, state) {
        CreditCardModel card = getCardFromInvoice(
            cards: state.cardsList, invoice: state.priorityInvoice!);
        return GestureDetector(
          onTap: () => goToInvoiceBillPage(
              context: context, invoice: state.priorityInvoice!),
          child: InvoiceItem(
            invoice: state.priorityInvoice!,
            card: card,
          ),
        );
      },
    );
  }
}
