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
  //mês de referência da categoria: é nele que ela passa a valer
  final MonthModel? month;

  const CategoryFormState({
    this.id = '',
    this.name = '',
    this.categoryFormMode = CategoryFormMode.adding,
    this.recurrenceMode = RecurrenceMode.single,
    this.responseStatus = ResponseStatus.initial,
    this.responseMessage = '',
    this.month,
  });

  CategoryFormState copyWith({
    String? id,
    String? name,
    CategoryFormMode? categoryFormMode,
    RecurrenceMode? recurrenceMode,
    ResponseStatus? responseStatus,
    String? responseMessage,
    MonthModel? month,
  }) {
    return CategoryFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryFormMode: categoryFormMode ?? this.categoryFormMode,
      recurrenceMode: recurrenceMode ?? this.recurrenceMode,
      responseStatus: responseStatus ?? this.responseStatus,
      responseMessage: responseMessage ?? this.responseMessage,
      month: month ?? this.month,
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
        month,
      ];
}