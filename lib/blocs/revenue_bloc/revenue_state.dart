import 'package:Fluxx/extensions/category_extension.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:equatable/equatable.dart';

enum AddRevenueResponse { initial, loading, success, error }

enum RemoveRevenueResponse { initial, loading, success, error }

enum EditRevenueResponse { initial, loading, success, error }

enum GetRevenueResponse { initial, loading, success, error }

class RevenueState extends Equatable {
  final AddRevenueResponse addRevenueResponse;
  final RemoveRevenueResponse removeRevenueResponse;
  final EditRevenueResponse editRevenueResponse;
  final GetRevenueResponse getRevenueResponse;
  final List<RevenueModel> revenuesList; 
  final List<RevenueModel> availableRevenues;
  final RevenueModel? selectedRevenue;
  final double totalRevenue;
  final String successMessage;
  final String errorMessage;

  const RevenueState({
    this.selectedRevenue,
    this.addRevenueResponse = AddRevenueResponse.initial,
    this.removeRevenueResponse = RemoveRevenueResponse.initial,
    this.editRevenueResponse = EditRevenueResponse.initial,
    this.getRevenueResponse = GetRevenueResponse.initial,
    this.revenuesList = const [],
    this.availableRevenues = const [],
    this.successMessage = '',
    this.errorMessage = '',
    this.totalRevenue = 0.0
  });

  RevenueState copyWith({
    Categorys? categoryInFocus,
    Categorys? editCategoryInFocus,
    AddRevenueResponse? addRevenueResponse,
    RemoveRevenueResponse? removeRevenueResponse,
    EditRevenueResponse? editRevenueResponse,
    GetRevenueResponse? getRevenueResponse,
    List<RevenueModel>? revenuesList,
    List<RevenueModel>? availableRevenues,
    RevenueModel? selectedRevenue,
    String? successMessage,
    String? errorMessage,
    double? totalRevenue
  }) {
    return RevenueState(
      addRevenueResponse: addRevenueResponse ?? this.addRevenueResponse,
      removeRevenueResponse:
          removeRevenueResponse ?? this.removeRevenueResponse,
      editRevenueResponse: editRevenueResponse ?? this.editRevenueResponse,
      getRevenueResponse: getRevenueResponse ?? this.getRevenueResponse,
      revenuesList: revenuesList ?? this.revenuesList,
      availableRevenues: availableRevenues ?? this.availableRevenues,
      selectedRevenue: selectedRevenue ?? this.selectedRevenue,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }

  @override
  List<Object?> get props => [
        addRevenueResponse,
        removeRevenueResponse,
        editRevenueResponse,
        getRevenueResponse,
        revenuesList,
        availableRevenues,
        selectedRevenue,
        successMessage,
        errorMessage,
        totalRevenue
      ];
}
