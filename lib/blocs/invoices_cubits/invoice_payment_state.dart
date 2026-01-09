part of 'invoice_payment_cubit.dart';

enum ResponseStatus { initial, loading, success, error }
enum PaymentResponseStatus { initial, loading, success, error }

class InvoicePaymentState extends Equatable {
  final InvoiceModel? invoice;
  final RevenueModel? paymentSelected;
  final List<RevenueModel> availableRevenues;
  final ResponseStatus status;
  final PaymentResponseStatus paymentStatus;
  final String responseMessage;

  const InvoicePaymentState({
    this.invoice,
    this.paymentSelected,
    this.availableRevenues = const [],
    this.status = ResponseStatus.initial,
    this.paymentStatus = PaymentResponseStatus.initial,
    this.responseMessage = '',
  });

  InvoicePaymentState copyWith({
     InvoiceModel? invoice,
     RevenueModel? paymentSelected,
  List<RevenueModel>? availableRevenues,
    ResponseStatus? status,
    PaymentResponseStatus? paymentStatus,
    String? responseMessage,
  }) {
    return InvoicePaymentState(
      paymentSelected: paymentSelected ?? this.paymentSelected,
      invoice: invoice ?? this.invoice,
      availableRevenues: availableRevenues ?? this.availableRevenues,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        paymentSelected,
        invoice,
        availableRevenues,
        status,
        paymentStatus,
        responseMessage,
      ];
}
