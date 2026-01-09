import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_cubit.dart';
import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_form_cubit.dart'
    as invoiceform;
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/auto_marquee_text.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/models/invoice_bill_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class DetailInvoiceBillPage extends StatefulWidget {
  const DetailInvoiceBillPage({super.key});

  @override
  State<DetailInvoiceBillPage> createState() => _DetailInvoiceBillPageState();
}

class _DetailInvoiceBillPageState extends State<DetailInvoiceBillPage> {
  @override
  void initState() {
    GetIt.I<InvoiceBillCubit>().getInvoiceBill();
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
    return BlocListener<invoiceform.InvoiceBillFormCubit,
        invoiceform.InvoiceBillFormState>(
      bloc: GetIt.I(),
      listenWhen: (previous, current) =>
          previous.responseStatus != current.responseStatus,
      listener: (context, state) {
        if (state.responseStatus == invoiceform.ResponseStatus.success) {
          GetIt.I<InvoiceBillCubit>().getInvoiceBill();
        }
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) =>
              !didPop ? Navigator.pop(context) : null,
          child: Scaffold(
            backgroundColor: AppTheme.colors.appBackgroundColor,
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(
              title: 'Detalhes',
              backButton: () => Navigator.pop(context),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: BlocBuilder<InvoiceBillCubit, InvoiceBillState>(
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
                              '${state.responseMessage}.',
                              style: AppTheme.textStyles.secondaryTextStyle,
                            ),
                          ),
                        );
                      case ResponseStatus.success:
                        return const _DetailInvoiceBillPageContent();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailInvoiceBillPageContent extends StatelessWidget {
  const _DetailInvoiceBillPageContent();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.width * .08,
      ),
      child: BlocBuilder<InvoiceBillCubit, InvoiceBillState>(
        bloc: GetIt.I(),
        buildWhen: (previous, current) => previous.bill != current.bill,
        builder: (context, state) {
          bool isPaidInFull = state.bill!.installmentTotal == 1;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              //compras parceladas não podem ser editadas
              if (isPaidInFull)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    IconButton.filled(
                      onPressed: () => goToInvoiceBillForm(
                          context: context, invoiceBill: state.bill),
                      icon: Icon(
                        Icons.mode_edit_rounded,
                        color: AppTheme.colors.white,
                      ),
                      style: IconButton.styleFrom(
                          minimumSize: const Size(55, 55),
                          backgroundColor: AppTheme.colors.hintColor),
                    ),
                    const Spacer(),
                    IconButton.filled(
                      onPressed: () => _showDeleteDialog(context, state.bill!),
                      icon: Icon(
                        Icons.delete_forever_rounded,
                        color: AppTheme.colors.white,
                      ),
                      style: IconButton.styleFrom(
                          minimumSize: const Size(55, 55),
                          backgroundColor: AppTheme.colors.hintColor),
                    ),
                    const Spacer(),
                  ],
                ),
              const SizedBox(height: 65),
              _DataItem(
                  title: 'Nome da conta', subtitle: state.bill!.name ?? ''),
              _DataItem(
                  title: isPaidInFull ? 'Valor' : 'Valor da parcela',
                  subtitle: 'R\$${formatPrice(state.bill!.price ?? 0.0)}'),
              _DataItem(
                  title: 'Categoria',
                  subtitle: state.bill!.categoryName ?? 'Nenhuma'),
              _DataItem(
                  title: 'Data da compra',
                  subtitle: formatDate(state.bill!.date) ?? 'Nenhuma'),
              _DataItem(
                  title: 'Pagamento',
                  subtitle:
                      '${state.bill!.installmentNumber}/${state.bill!.installmentTotal}'),
              _DataItem(
                  title: 'Descrição', subtitle: state.bill!.description ?? ''),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, InvoiceBillModel bill) {
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
                _removeBill(
                  context: context,
                  id: bill.id!,
                  invoiceId: bill.invoiceId!,
                );
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

  Future<void> _removeBill(
      {required BuildContext context,
      required String id,
      required String invoiceId}) async {
    var result = await GetIt.I<InvoiceBillCubit>()
        .deleteInvoiceBill(id: id, invoiceId: invoiceId);
    var state = GetIt.I<InvoiceBillCubit>().state;
    if (result > 0) {
      Navigator.pop(context);
      showFlushbar(context, state.responseMessage, false);
    } else {
      showFlushbar(context, state.responseMessage, true);
    }
  }
}

class _DataItem extends StatelessWidget {
  final String title;
  final String subtitle;
  const _DataItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        AutoMarqueeText(
          text: title,
          style: AppTheme.textStyles.secondaryTextStyle
              .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
        ),
        Text(
          subtitle.isNotEmpty
              ? subtitle
              : 'sem ${title.toLowerCase()} informado(a)',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        Divider(
          color: AppTheme.colors.hintTextColor,
          thickness: 1,
        ),
      ],
    );
  }
}
