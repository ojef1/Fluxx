
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:equatable/equatable.dart';



enum GetBillsResponse { initial, loading, success, error }
enum GetStatsResponse { initial, loading, success, error }

class ListBillState extends Equatable {
  final double monthTotalSpent;
  final double monthTotalPaid;
  final List<BillModel> bills;
  final List<CategoryModel> stats;
  final GetBillsResponse getBillsResponse;
  final GetStatsResponse getStatsResponse;
  final String successMessage;
  final String errorMessage;

  const ListBillState({
    this.monthTotalSpent = 0.0,
    this.monthTotalPaid = 0.0,
    this.bills = const [],
    this.stats = const [],
    this.getBillsResponse = GetBillsResponse.initial,
    this.getStatsResponse = GetStatsResponse.initial,
    this.successMessage = '',
    this.errorMessage = '',
  });

  ListBillState copyWith({
    double? monthTotalSpent,
    double? monthTotalPaid,
    List<BillModel>? bills,
    List<CategoryModel>? stats,
    GetBillsResponse? getBillsResponse,
    GetStatsResponse? getStatsResponse,
    String? successMessage,
    String? errorMessage,
  }) {
    return ListBillState(
      monthTotalSpent: monthTotalSpent ?? this.monthTotalSpent,
      monthTotalPaid: monthTotalPaid ?? this.monthTotalPaid,
      bills: bills ?? this.bills,
      stats: stats ?? this.stats,
      getBillsResponse: getBillsResponse ?? this.getBillsResponse,
      getStatsResponse: getStatsResponse ?? this.getStatsResponse,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        monthTotalSpent,
        monthTotalPaid,
        bills,
        stats,
        getBillsResponse,
        getStatsResponse,
        successMessage,
        errorMessage,
      ];
}
