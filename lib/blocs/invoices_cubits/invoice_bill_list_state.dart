part of 'invoice_bill_list_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

class InvoiceListBillState extends Equatable {
  final String idToGet;
  final List<InvoiceBillModel> bills;
  final ResponseStatus status;
  final String responseMessage;

  const InvoiceListBillState({
    this.idToGet = '',
    this.bills = const [],
    this.status = ResponseStatus.initial,
    this.responseMessage = '',
  });

  InvoiceListBillState copyWith({
    String? idToGet,
    List<InvoiceBillModel>? bills,
    ResponseStatus? status,
    String? responseMessage,
  }) {
    return InvoiceListBillState(
      idToGet: idToGet ?? this.idToGet,
      bills: bills ?? this.bills,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        idToGet,
        bills,
        status,
        responseMessage,
      ];
}
