import 'package:Fluxx/blocs/invoices_cubits/invoice_payment_cubit.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InvoicePaymentConfirmationBottomsheet extends StatelessWidget {
  final String paymentName;
  const InvoicePaymentConfirmationBottomsheet({
    super.key,
    required this.paymentName,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<InvoicePaymentCubit, InvoicePaymentState>(
      bloc: GetIt.I(),
      listenWhen: (previous, current) =>
          previous.paymentStatus != current.paymentStatus,
      listener: (context, state) {
        if (state.paymentStatus == PaymentResponseStatus.success) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.colors.appBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BlocBuilder<InvoicePaymentCubit, InvoicePaymentState>(
          bloc: GetIt.I(),
          buildWhen: (previous, current) =>
              previous.paymentStatus != current.paymentStatus,
          builder: (context, state) {
            switch (state.paymentStatus) {
              case PaymentResponseStatus.error:
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Text(
                      'Erro ao carregar as estísticas. ${state.responseMessage}',
                    ),
                  ),
                );
              case PaymentResponseStatus.loading:
                return const CustomLoading(
                  padding: EdgeInsets.zero,
                );
              case PaymentResponseStatus.initial:
              case PaymentResponseStatus.success:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/payment_confirmation.png',
                      width: 200,
                    ),
                    Text(
                      'Deseja pagar a fatura de janeiro com a renda : $paymentName ?',
                      style: AppTheme.textStyles.subTileTextStyle,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 3,
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: 'Voltar',
                      onPressed: () => Navigator.of(context).pop(),
                      width: mediaQuery.width * .85,
                      color: AppTheme.colors.red,
                      textStyle: AppTheme.textStyles.bodyTextStyle,
                    ),
                    const SizedBox(height: 5),
                    PrimaryButton(
                      text: 'Pagar',
                      onPressed: () async =>
                          await GetIt.I<InvoicePaymentCubit>()
                              .submitPaymentStatus(),
                      width: mediaQuery.width * .85,
                      color: AppTheme.colors.hintColor,
                      textStyle: AppTheme.textStyles.bodyTextStyle,
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
