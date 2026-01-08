part of 'bill_list_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

class ListBillState extends Equatable {
  final List<BillModel> bills;
  final ResponseStatus status;
  final String responseMessage;

  const ListBillState({
    this.bills = const [],
    this.status = ResponseStatus.initial,
    this.responseMessage = '',
  });

  ListBillState copyWith({
    List<BillModel>? bills,
    ResponseStatus? status,
    String? responseMessage,
  }) {
    return ListBillState(
      bills: bills ?? this.bills,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        bills,
        status,
        responseMessage,
      ];
}
