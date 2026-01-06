part of 'credit_card_info_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

class CreditCardInfoState extends Equatable {
  final double revenueImpairment;
  final InvoiceModel? invoice;
  final int invoiceBillsLength;
  final double recommendedSpending;
  final String idToGet;
  final CreditCardModel? card;
  final ResponseStatus status;
  final String responseMessage;

  const CreditCardInfoState({
    this.revenueImpairment = 0,
    this.invoice,
    this.invoiceBillsLength = 0,
    this.recommendedSpending = 0.0,
    this.idToGet = '',
    this.card,
    this.status = ResponseStatus.initial,
    this.responseMessage = '',
  });

  CreditCardInfoState copyWith({
    double? revenueImpairment,
    InvoiceModel? invoice,
    int? invoiceBillsLength,
    double? recommendedSpending,
    String? idToGet,
    CreditCardModel? card,
    ResponseStatus? status,
    String? responseMessage,
  }) {
    return CreditCardInfoState(
      revenueImpairment: revenueImpairment ?? this.revenueImpairment,
      invoice: invoice ?? this.invoice,
      invoiceBillsLength: invoiceBillsLength ?? this.invoiceBillsLength,
      recommendedSpending: recommendedSpending ?? this.recommendedSpending,
      idToGet: idToGet ?? this.idToGet,
      card: card ?? this.card,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        revenueImpairment,
        invoice,
        invoiceBillsLength,
        recommendedSpending,
        idToGet,
        card,
        status,
        responseMessage,
      ];
}
