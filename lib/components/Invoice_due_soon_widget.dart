import 'package:Fluxx/blocs/credit_card_cubits/credit_card_form_cubit.dart';
import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_form_cubit.dart' as invoicebill;
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/components/invoice_item.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
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

  @override
  Widget build(BuildContext context) {
    return _ListenerWrapper(
      child: BlocBuilder<ResumeCubit, ResumeState>(
        buildWhen: (previous, current) =>
            previous.priorityInvoiceStatus != current.priorityInvoiceStatus,
        bloc: GetIt.I(),
        builder: (context, state) {
          switch (state.priorityInvoiceStatus) {
            case GetPriorityInvoiceStatus.initial:
            case GetPriorityInvoiceStatus.loading:
            case GetPriorityInvoiceStatus.error:
              return const SizedBox();
            case GetPriorityInvoiceStatus.success:
              if (state.priorityInvoice != null) {
                return const _InvoiceDueSoonContent();
              } else {
                return const SizedBox();
              }
          }
        },
      ),
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

class _ListenerWrapper extends StatelessWidget {
  final Widget child;
  const _ListenerWrapper({required this.child});


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<CreditCardFormCubit, CreditCardFormState>(
        bloc: GetIt.I(),
        listenWhen: (previous, current) =>
            previous.responseStatus != current.responseStatus,
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            GetIt.I<ResumeCubit>().getPriorityInvoice();
          }
        },
      ),
      BlocListener<invoicebill.InvoiceBillFormCubit, invoicebill.InvoiceBillFormState>(
        bloc: GetIt.I(),
        listenWhen: (previous, current) =>
            previous.responseStatus != current.responseStatus,
        listener: (context, state) {
          if (state.responseStatus == invoicebill.ResponseStatus.success) {
            GetIt.I<ResumeCubit>().getPriorityInvoice();
          }
        },
      ),
    ], child: child);
  }
}
