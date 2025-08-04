import 'package:Fluxx/models/category_model.dart';
import 'package:equatable/equatable.dart';

enum AddCategoriesResponse { initial, loading, success, error }

enum RemoveCategoriesResponse { initial, loading, success, error }

enum EditCategoriesResponse { initial, loading, success, error }

enum GetCategoriesResponse { initial, loading, success, error }

enum GetTotalResponse { initial, loading, success, error }

class CategoryState extends Equatable {
  final List<CategoryModel> categories;
  final List<CategoryModel> totalByCategory;
  final CategoryModel? selectedCategory;
  final AddCategoriesResponse addCategoriesResponse;
  final RemoveCategoriesResponse removeCategoriesResponse;
  final EditCategoriesResponse editCategoriesResponse;
  final GetCategoriesResponse getCategoriesResponse;
  final GetTotalResponse getTotalByCategoryResponse;
  final String successMessage;
  final String errorMessage;

  const CategoryState({
    this.selectedCategory,
    this.categories = const [],
    this.totalByCategory = const [],
    this.addCategoriesResponse = AddCategoriesResponse.initial,
    this.removeCategoriesResponse = RemoveCategoriesResponse.initial,
    this.editCategoriesResponse = EditCategoriesResponse.initial,
    this.getCategoriesResponse = GetCategoriesResponse.initial,
    this.getTotalByCategoryResponse = GetTotalResponse.initial,
    this.successMessage = '',
    this.errorMessage = '',
  });

  CategoryState copyWith({
    CategoryModel? selectedCategory,
    List<CategoryModel>? categories,
    List<CategoryModel>? totalByCategory,
    AddCategoriesResponse? addCategoriesResponse,
    RemoveCategoriesResponse? removeCategoriesResponse,
    EditCategoriesResponse? editCategoriesResponse,
    GetCategoriesResponse? getCategoriesResponse,
    GetTotalResponse? getTotalByCategoryResponse,
    String? successMessage,
    String? errorMessage,
  }) {
    return CategoryState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      totalByCategory: totalByCategory ?? this.totalByCategory,
      addCategoriesResponse:
          addCategoriesResponse ?? this.addCategoriesResponse,
      removeCategoriesResponse:
          removeCategoriesResponse ?? this.removeCategoriesResponse,
      editCategoriesResponse:
          editCategoriesResponse ?? this.editCategoriesResponse,
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
        addCategoriesResponse,
        removeCategoriesResponse,
        editCategoriesResponse,
        getCategoriesResponse,
        getTotalByCategoryResponse,
        successMessage,
        errorMessage,
      ];
}
