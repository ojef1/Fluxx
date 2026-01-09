import 'package:Fluxx/blocs/invoices_cubits/invoice_payment_cubit.dart';
import 'package:Fluxx/blocs/revenue_form_cubit/revenue_form_cubit.dart'
    as revenueform;
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/bottom_sheets/invoice_payment_confirmation_bottomsheet.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_revenue_list.dart';
import 'package:Fluxx/components/listTiles/revenue_listTile.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InvoicePaymentPage extends StatefulWidget {
  const InvoicePaymentPage({super.key});

  @override
  State<InvoicePaymentPage> createState() => _InvoicePaymentPageState();
}

class _InvoicePaymentPageState extends State<InvoicePaymentPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var monthId = GetIt.I<InvoicePaymentCubit>().state.invoice!.monthId;
    GetIt.I<InvoicePaymentCubit>().getAvailableRevenues(monthId!);
  }

  @override
  void dispose() {
    GetIt.I<InvoicePaymentCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<revenueform.RevenueFormCubit,
            revenueform.RevenueFormState>(
          listenWhen: (previous, current) =>
              previous.responseStatus != current.responseStatus,
          bloc: GetIt.I(),
          listener: (context, state) {
            if (state.responseStatus == revenueform.ResponseStatus.success) {
              init();
            }
          },
        ),
        BlocListener<InvoicePaymentCubit, InvoicePaymentState>(
          bloc: GetIt.I(),
          listenWhen: (previous, current) =>
              previous.paymentStatus != current.paymentStatus,
          listener: (context, state) {
            if (state.paymentStatus == PaymentResponseStatus.success) {
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppTheme.colors.appBackgroundColor,
          appBar: const CustomAppBar(title: 'Pagar Fatura'),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: BlocBuilder<InvoicePaymentCubit, InvoicePaymentState>(
                bloc: GetIt.I(),
                builder: (context, state) {
                  switch (state.status) {
                    case ResponseStatus.initial:
                    case ResponseStatus.loading:
                      return const CustomLoading();
                    case ResponseStatus.error:
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: Center(
                          child: Text(
                            'Erro ao carregar as estísticas. ${state.responseMessage}',
                          ),
                        ),
                      );
                    case ResponseStatus.success:
                      if (state.availableRevenues.isEmpty) {
                        return EmptyRevenueList(
                          onPressed: () => goToRevenueForm(context: context),
                        );
                      } else {
                        return const _InvoicePaymentPageContent();
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

class _InvoicePaymentPageContent extends StatelessWidget {
  const _InvoicePaymentPageContent();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocBuilder<InvoicePaymentCubit, InvoicePaymentState>(
        bloc: GetIt.I(),
        builder: (context, state) {
          var formatted = DateTime.parse(state.invoice?.endDate ?? '');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: Constants.topMargin),
              Container(
                padding: const EdgeInsets.all(18),
                height: mediaQuery.height * .12,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppTheme.colors.itemBackgroundColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fatura de ${getMonthName(formatted)}',
                          style: AppTheme.textStyles.bodyTextStyle,
                        ),
                        Text(
                          getInvoiceStatus(
                            endDate: state.invoice?.endDate ?? '',
                            dueDay: int.parse(state.invoice?.dueDate ?? '0'),
                            isPaid: state.invoice?.isPaid == 1,
                          ),
                          style: AppTheme.textStyles.secondaryTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      'R\$${formatPrice(
                        state.invoice?.price ?? 0.0,
                      )}',
                      style: AppTheme.textStyles.titleTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Text(
                'Qual renda você usará para pagar?',
                style: AppTheme.textStyles.subTileTextStyle,
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 20),
              Text(
                'O status de pagamento não pode ser alterado depois.',
                style: AppTheme.textStyles.subTileTextStyle.copyWith(
                    color: AppTheme.colors.hintTextColor.withAlpha(100)),
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 35),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.availableRevenues.length,
                  itemBuilder: (context, index) {
                    bool available = _verifyAvailability(state.invoice!.price!,
                        state.availableRevenues[index].value ?? 0.0);
                    bool isSelected = state.availableRevenues[index].id ==
                        state.paymentSelected?.id;
                    return Column(
                      children: [
                        RevenueListTile(
                          title: state.availableRevenues[index].name ?? '',
                          subtitle:
                              'R\$${formatPrice(state.availableRevenues[index].value ?? 0.0)}',
                          isSelected: isSelected,
                          onPressed: !available
                              ? () => _showUnavailableDialog(
                                    context,
                                    state.availableRevenues[index].name ?? '',
                                  )
                              : () => _selectRevenue(
                                    state.availableRevenues[index],
                                  ),
                        ),
                        if (state.availableRevenues.length - 1 == index)
                          const SizedBox(height: 24),
                        if (state.availableRevenues.length - 1 == index)
                          PrimaryButton(
                            color: AppTheme.colors.itemBackgroundColor,
                            textStyle: AppTheme.textStyles.bodyTextStyle
                                .copyWith(color: AppTheme.colors.hintColor),
                            width: mediaQuery.width * .85,
                            text: 'Adicionar mais Receitas',
                            onPressed: () => goToRevenueForm(context: context),
                          ),
                      ],
                    );
                  },
                ),
              ),
              BlocBuilder<InvoicePaymentCubit, InvoicePaymentState>(
                  bloc: GetIt.I(),
                  buildWhen: (previous, current) =>
                      previous.paymentSelected != current.paymentSelected,
                  builder: (context, state) {
                    bool hasPaymentSelected = state.paymentSelected != null;
                    return PrimaryButton(
                      text: 'Pagar',
                      onPressed: hasPaymentSelected
                          ? () => showPaymentBottomSheet(
                              context, state.paymentSelected?.name ?? '')
                          : () {},
                     width: mediaQuery.width * .85,
                      color: hasPaymentSelected
                          ? AppTheme.colors.hintColor
                          : AppTheme.colors.lightHintColor,
                      textStyle: AppTheme.textStyles.bodyTextStyle,
                    );
                  }),
              SizedBox(height: mediaQuery.height * .03),
            ],
          );
        });
  }

  void _showUnavailableDialog(BuildContext context, String name) {
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
            'Oops!',
            style: AppTheme.textStyles.tileTextStyle,
          ),
          content: Text(
            maxLines: 4,
            textAlign: TextAlign.center,
            '" $name " não está disponível pois o valor da conta é maior que o valor disponível.',
            style: AppTheme.textStyles.subTileTextStyle,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.hintColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'OK',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  void showPaymentBottomSheet(BuildContext context, String paymentName) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          InvoicePaymentConfirmationBottomsheet(paymentName: paymentName),
    );
  }

  void _selectRevenue(RevenueModel revenue) {
    GetIt.I<InvoicePaymentCubit>().updatePaymentSelected(revenue);
  }

  bool _verifyAvailability(double billValue, double revenueValue) {
    if (billValue <= revenueValue) {
      return true;
    } else {
      return false;
    }
  }
}
