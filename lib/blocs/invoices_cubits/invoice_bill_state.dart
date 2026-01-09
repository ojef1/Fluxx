part of 'invoice_bill_cubit.dart';


enum ResponseStatus {initial, loading, success, error}

class InvoiceBillState extends Equatable{
  final String idToGet;
  final ResponseStatus status;
  final String responseMessage;
  final InvoiceBillModel? bill;

  const InvoiceBillState({
    this.idToGet = '',
    this.status = ResponseStatus.initial,
    this.responseMessage = '',
    this.bill,
  });

  InvoiceBillState copyWith({
    String? idToGet,
    ResponseStatus? status,
    String? responseMessage,
    InvoiceBillModel? bill,
  }){
    return InvoiceBillState(
      idToGet: idToGet ?? this.idToGet,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
      bill: bill ?? this.bill,
    );
  }

    @override
  List<Object?> get props => [
        idToGet,
        status,
        responseMessage,
        bill,
      ];
}