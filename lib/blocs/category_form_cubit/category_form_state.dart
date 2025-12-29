part of 'category_form_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

enum CategoryFormMode { adding, editing }

class CategoryFormState extends Equatable {
  final String id; // só será preenchida no modo editing
  final String name;
  final CategoryFormMode categoryFormMode;
  final ResponseStatus responseStatus;
  final String responseMessage;

  const CategoryFormState({
    this.id = '',
    this.name = '',
    this.categoryFormMode = CategoryFormMode.adding,
    this.responseStatus = ResponseStatus.initial,
    this.responseMessage = '',
  });

  CategoryFormState copyWith({
    String? id,
    String? name,
    CategoryFormMode? categoryFormMode,
    ResponseStatus? responseStatus,
    String? responseMessage,
  }) {
    return CategoryFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryFormMode: categoryFormMode ?? this.categoryFormMode,
      responseStatus: responseStatus ?? this.responseStatus,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        categoryFormMode,
        responseStatus,
        responseMessage,
      ];
}