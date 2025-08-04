
import 'package:Fluxx/models/bill_model.dart';
import 'package:equatable/equatable.dart';

enum AddBillsResponse { initial, loaging, success, error }

enum RemoveBillsResponse { initial, loaging, success, error }

enum EditBillsResponse { initial, loaging, success, error }

enum GetBillResponse { initial, loaging, success, error }

class BillState extends Equatable {
  final AddBillsResponse addBillsResponse;
  final RemoveBillsResponse removeBillsResponse;
  final EditBillsResponse editBillsResponse;
  final GetBillResponse getBillResponse;
  final BillModel? detailBill;
  final String successMessage;
  final String errorMessage;
  final int billIsPayed;
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
    this.billIsPayed = 0,
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
    int? billIsPayed,
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
      
      billIsPayed: billIsPayed ?? this.billIsPayed,
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
        billIsPayed,
        paymentDate,
      ];
}
