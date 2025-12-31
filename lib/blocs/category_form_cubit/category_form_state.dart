part of 'category_form_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

enum CategoryFormMode { adding, editing }

enum RecurrenceMode { single, monthly }

class CategoryFormState extends Equatable {
  final String id; // só será preenchida no modo editing
  final String name;
  final CategoryFormMode categoryFormMode;
  final RecurrenceMode recurrenceMode;
  final ResponseStatus responseStatus;
  final String responseMessage;

  const CategoryFormState({
    this.id = '',
    this.name = '',
    this.categoryFormMode = CategoryFormMode.adding,
    this.recurrenceMode = RecurrenceMode.single,
    this.responseStatus = ResponseStatus.initial,
    this.responseMessage = '',
  });

  CategoryFormState copyWith({
    String? id,
    String? name,
    CategoryFormMode? categoryFormMode,
    RecurrenceMode? recurrenceMode,
    ResponseStatus? responseStatus,
    String? responseMessage,
  }) {
    return CategoryFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryFormMode: categoryFormMode ?? this.categoryFormMode,
      recurrenceMode: recurrenceMode ?? this.recurrenceMode,
      responseStatus: responseStatus ?? this.responseStatus,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        categoryFormMode,
        recurrenceMode,
        responseStatus,
        responseMessage,
      ];
}