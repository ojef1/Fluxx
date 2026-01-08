
import 'package:Fluxx/models/bill_model.dart';
import 'package:equatable/equatable.dart';


enum RemoveBillsResponse { initial, loading, success, error }

enum EditBillsResponse { initial, loading, success, error }

enum GetBillResponse { initial, loading, success, error }

class BillState extends Equatable {
  final RemoveBillsResponse removeBillsResponse;
  final EditBillsResponse editBillsResponse;
  final GetBillResponse getBillResponse;
  final BillModel? detailBill;
  final String successMessage;
  final String errorMessage;
  // final 

  const BillState({
    this.removeBillsResponse = RemoveBillsResponse.initial,
    this.editBillsResponse = EditBillsResponse.initial,
    this.getBillResponse = GetBillResponse.initial,
    this.detailBill,
    this.successMessage = '',
    this.errorMessage = '',
  });

  BillState copyWith({
    RemoveBillsResponse? removeBillsResponse,
    EditBillsResponse? editBillsResponse,
    GetBillResponse? getBillResponse,
    BillModel? detailBill,
    String? successMessage,
    String? errorMessage,
  }) {
    return BillState(
      removeBillsResponse: removeBillsResponse ?? this.removeBillsResponse,
      editBillsResponse: editBillsResponse ?? this.editBillsResponse,
      getBillResponse: getBillResponse ?? this.getBillResponse,
      detailBill: detailBill ?? this.detailBill,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        removeBillsResponse,
        editBillsResponse,
        getBillResponse,
        detailBill,
        successMessage,
        errorMessage,
      ];
}
