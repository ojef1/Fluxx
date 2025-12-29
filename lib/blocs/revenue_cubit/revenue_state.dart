import 'package:Fluxx/models/revenue_model.dart';
import 'package:equatable/equatable.dart';

enum GetRevenueResponse { initial, loading, success, error }

class RevenueState extends Equatable {
  final GetRevenueResponse getRevenueResponse;
  final List<RevenueModel> revenuesList; 
  final List<RevenueModel> availableRevenues;
  final RevenueModel? selectedRevenue;
  final double totalRevenue;
  final double remainingRevenue;
  final String successMessage;
  final String errorMessage;

  const RevenueState({
    this.selectedRevenue,
    this.getRevenueResponse = GetRevenueResponse.initial,
    this.revenuesList = const [],
    this.availableRevenues = const [],
    this.successMessage = '',
    this.errorMessage = '',
    this.totalRevenue = 0.0,
    this.remainingRevenue = 0.0
  });

  RevenueState copyWith({
    GetRevenueResponse? getRevenueResponse,
    List<RevenueModel>? revenuesList,
    List<RevenueModel>? availableRevenues,
    RevenueModel? selectedRevenue,
    String? successMessage,
    String? errorMessage,
    double? totalRevenue,
    double? remainingRevenue
  }) {
    return RevenueState(
      getRevenueResponse: getRevenueResponse ?? this.getRevenueResponse,
      revenuesList: revenuesList ?? this.revenuesList,
      availableRevenues: availableRevenues ?? this.availableRevenues,
      selectedRevenue: selectedRevenue ?? this.selectedRevenue,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      remainingRevenue: remainingRevenue ?? this.remainingRevenue,
    );
  }

  @override
  List<Object?> get props => [
        getRevenueResponse,
        revenuesList,
        availableRevenues,
        selectedRevenue,
        successMessage,
        errorMessage,
        totalRevenue,
        remainingRevenue
      ];
}
