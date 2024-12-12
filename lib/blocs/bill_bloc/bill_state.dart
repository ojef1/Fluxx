import 'package:Fluxx/extensions/category_extension.dart';
import 'package:equatable/equatable.dart';

enum AddBillsResponse { initial, loaging, success, error }

enum RemoveBillsResponse { initial, loaging, success, error }

enum EditBillsResponse { initial, loaging, success, error }

class BillState extends Equatable {
  final Categorys categoryInFocus;
  final Categorys editCategoryInFocus;
  final AddBillsResponse addBillsResponse;
  final RemoveBillsResponse removeBillsResponse;
  final EditBillsResponse editBillsResponse;
  final String successMessage;
  final String errorMessage;
  final int billIsPayed;

  const BillState({
    this.categoryInFocus = Categorys.casa,
    this.editCategoryInFocus = Categorys.casa,
    this.addBillsResponse = AddBillsResponse.initial,
    this.removeBillsResponse = RemoveBillsResponse.initial,
    this.editBillsResponse = EditBillsResponse.initial,
    this.successMessage = '',
    this.errorMessage = '',
    this.billIsPayed = 0,
  });

  BillState copyWith({
    Categorys? categoryInFocus,
    Categorys? editCategoryInFocus,
    AddBillsResponse? addBillsResponse,
    RemoveBillsResponse? removeBillsResponse,
    EditBillsResponse? editBillsResponse,
    String? successMessage,
    String? errorMessage,
    int? billIsPayed,
  }) {
    return BillState(
      categoryInFocus: categoryInFocus ?? this.categoryInFocus,
      editCategoryInFocus: editCategoryInFocus ?? this.editCategoryInFocus,
      addBillsResponse: addBillsResponse ?? this.addBillsResponse,
      removeBillsResponse: removeBillsResponse ?? this.removeBillsResponse,
      editBillsResponse: editBillsResponse ?? this.editBillsResponse,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      billIsPayed: billIsPayed ?? this.billIsPayed,
    );
  }

  @override
  List<Object?> get props => [
        categoryInFocus,
        editCategoryInFocus,
        addBillsResponse,
        removeBillsResponse,
        editBillsResponse,
        successMessage,
        errorMessage,
        billIsPayed,
      ];
}
