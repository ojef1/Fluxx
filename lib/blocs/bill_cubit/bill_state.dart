
import 'package:Fluxx/models/bill_model.dart';
import 'package:equatable/equatable.dart';

enum AddBillsResponse { initial, loading, success, error }

enum RemoveBillsResponse { initial, loading, success, error }

enum EditBillsResponse { initial, loading, success, error }

enum GetBillResponse { initial, loading, success, error }

class BillState extends Equatable {
  final AddBillsResponse addBillsResponse;
  final RemoveBillsResponse removeBillsResponse;
  final EditBillsResponse editBillsResponse;
  final GetBillResponse getBillResponse;
  final BillModel? detailBill;
  final String successMessage;
  final String errorMessage;
  final String paymentDate;
  // final 

  const BillState({
    this.addBillsResponse = AddBillsResponse.initial,
    this.removeBillsResponse = RemoveBillsResponse.initial,
    this.editBillsResponse = EditBillsResponse.initial,
    this.getBillResponse = GetBillResponse.initial,
    this.detailBill,
    this.successMessage = '',
    this.errorMessage = '',
    this.paymentDate = '',
  });

  BillState copyWith({
    AddBillsResponse? addBillsResponse,
    RemoveBillsResponse? removeBillsResponse,
    EditBillsResponse? editBillsResponse,
    GetBillResponse? getBillResponse,
    BillModel? detailBill,
    String? successMessage,
    String? errorMessage,
    String? paymentDate,
  }) {
    return BillState(
      addBillsResponse: addBillsResponse ?? this.addBillsResponse,
      removeBillsResponse: removeBillsResponse ?? this.removeBillsResponse,
      editBillsResponse: editBillsResponse ?? this.editBillsResponse,
      getBillResponse: getBillResponse ?? this.getBillResponse,
      detailBill: detailBill ?? this.detailBill,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }

  @override
  List<Object?> get props => [
        addBillsResponse,
        removeBillsResponse,
        editBillsResponse,
        getBillResponse,
        detailBill,
        successMessage,
        errorMessage,
        paymentDate,
      ];
}
