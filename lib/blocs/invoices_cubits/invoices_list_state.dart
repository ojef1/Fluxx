part of 'invoices_list_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

class InvoicesListState extends Equatable {
  final List<InvoiceModel> invoicesList;
  final List<CreditCardModel> cardsList;
  final ResponseStatus status;
  final String responseMessage;

  const InvoicesListState({
    this.invoicesList = const [],
    this.cardsList = const [],
    this.status = ResponseStatus.initial,
    this.responseMessage = '',
  });

  InvoicesListState copyWith({
    List<InvoiceModel>? invoicesList,
    List<CreditCardModel>? cardsList,
    ResponseStatus? status,
    String? responseMessage,
  }) {
    return InvoicesListState(
      invoicesList: invoicesList ?? this.invoicesList,
      cardsList: cardsList ?? this.cardsList,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        invoicesList,
        cardsList,
        status,
        responseMessage,
      ];
}
