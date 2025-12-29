import 'package:Fluxx/models/category_model.dart';
import 'package:equatable/equatable.dart';


enum GetCategoriesResponse { initial, loading, success, error }

enum GetTotalResponse { initial, loading, success, error }

class CategoryState extends Equatable {
  final List<CategoryModel> categories;
  final List<CategoryModel> totalByCategory;
  final CategoryModel? selectedCategory;
  final GetCategoriesResponse getCategoriesResponse;
  final GetTotalResponse getTotalByCategoryResponse;
  final String successMessage;
  final String errorMessage;

  const CategoryState({
    this.selectedCategory,
    this.categories = const [],
    this.totalByCategory = const [],
    this.getCategoriesResponse = GetCategoriesResponse.initial,
    this.getTotalByCategoryResponse = GetTotalResponse.initial,
    this.successMessage = '',
    this.errorMessage = '',
  });

  CategoryState copyWith({
    CategoryModel? selectedCategory,
    List<CategoryModel>? categories,
    List<CategoryModel>? totalByCategory,
    GetCategoriesResponse? getCategoriesResponse,
    GetTotalResponse? getTotalByCategoryResponse,
    String? successMessage,
    String? errorMessage,
  }) {
    return CategoryState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      totalByCategory: totalByCategory ?? this.totalByCategory,
      getCategoriesResponse:
          getCategoriesResponse ?? this.getCategoriesResponse,
          getTotalByCategoryResponse: getTotalByCategoryResponse ?? this.getTotalByCategoryResponse,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedCategory,
        categories,
        totalByCategory,
        getCategoriesResponse,
        getTotalByCategoryResponse,
        successMessage,
        errorMessage,
      ];
}
