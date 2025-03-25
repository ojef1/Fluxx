import 'package:Fluxx/models/category_model.dart';
import 'package:equatable/equatable.dart';

enum AddCategoriesResponse { initial, loaging, success, error }

enum RemoveCategoriesResponse { initial, loaging, success, error }

enum EditCategoriesResponse { initial, loaging, success, error }

enum GetCategoriesResponse { initial, loaging, success, error }

class CategoryState extends Equatable {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final AddCategoriesResponse addCategoriesResponse;
  final RemoveCategoriesResponse removeCategoriesResponse;
  final EditCategoriesResponse editCategoriesResponse;
  final GetCategoriesResponse getCategoriesResponse;
  final String successMessage;
  final String errorMessage;

  const CategoryState({
    this.selectedCategory,
    this.categories = const [],
    this.addCategoriesResponse = AddCategoriesResponse.initial,
    this.removeCategoriesResponse = RemoveCategoriesResponse.initial,
    this.editCategoriesResponse = EditCategoriesResponse.initial,
    this.getCategoriesResponse = GetCategoriesResponse.initial,
    this.successMessage = '',
    this.errorMessage = '',
  });

  CategoryState copyWith({
    CategoryModel? selectedCategory,
    List<CategoryModel>? categories,
    AddCategoriesResponse? addCategoriesResponse,
    RemoveCategoriesResponse? removeCategoriesResponse,
    EditCategoriesResponse? editCategoriesResponse,
    GetCategoriesResponse? getCategoriesResponse,
    String? successMessage,
    String? errorMessage,
  }) {
    return CategoryState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      addCategoriesResponse:
          addCategoriesResponse ?? this.addCategoriesResponse,
      removeCategoriesResponse:
          removeCategoriesResponse ?? this.removeCategoriesResponse,
      editCategoriesResponse:
          editCategoriesResponse ?? this.editCategoriesResponse,
      getCategoriesResponse:
          getCategoriesResponse ?? this.getCategoriesResponse,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedCategory,
        categories,
        addCategoriesResponse,
        removeCategoriesResponse,
        editCategoriesResponse,
        getCategoriesResponse,
        successMessage,
        errorMessage,
      ];
}
