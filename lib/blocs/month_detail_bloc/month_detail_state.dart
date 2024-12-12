import 'package:Fluxx/extensions/category_extension.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/chart_category_model.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:equatable/equatable.dart';



enum GetBillsResponse { initial, loaging, success, error }
enum GetStatsResponse { initial, loaging, success, error }

class MonthsDetailState extends Equatable {
  final double monthTotalSpent;
  final double monthTotalPaid;
  final MonthModel? monthInFocus;
  final Categorys categoryInFocus;
  final List<BillModel> bills;
  final List<StatsCategoryModel> stats;
  final GetBillsResponse getBillsResponse;
  final GetStatsResponse getStatsResponse;
  final String successMessage;
  final String errorMessage;

  const MonthsDetailState({
    this.monthTotalSpent = 0.0,
    this.monthTotalPaid = 0.0,
    this.monthInFocus,
    this.categoryInFocus = Categorys.casa,
    this.bills = const [],
    this.stats = const [],
    this.getBillsResponse = GetBillsResponse.initial,
    this.getStatsResponse = GetStatsResponse.initial,
    this.successMessage = '',
    this.errorMessage = '',
  });

  MonthsDetailState copyWith({
    double? monthTotalSpent,
    double? monthTotalPaid,
    MonthModel? monthInFocus,
    Categorys? categoryInFocus,
    List<BillModel>? bills,
    List<StatsCategoryModel>? stats,
    GetBillsResponse? getBillsResponse,
    GetStatsResponse? getStatsResponse,
    String? successMessage,
    String? errorMessage,
  }) {
    return MonthsDetailState(
      monthTotalSpent: monthTotalSpent ?? this.monthTotalSpent,
      monthTotalPaid: monthTotalPaid ?? this.monthTotalPaid,
      monthInFocus: monthInFocus ?? this.monthInFocus,
      categoryInFocus: categoryInFocus ?? this.categoryInFocus,
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
        monthInFocus,
        categoryInFocus,
        bills,
        stats,
        getBillsResponse,
        getStatsResponse,
        successMessage,
        errorMessage,
      ];
}
