part of 'revenue_form_cubit.dart';


enum ResponseStatus { initial, loading, success, error }

enum RevenueFormMode { adding, editing }

enum RecurrenceMode { single, monthly }

class RevenueFormState extends Equatable {
  final String id; // só será preenchida no modo editing
  final String name;
  final double price;
  final RevenueFormMode revenueFormMode;
  final RecurrenceMode recurrenceMode;
  final ResponseStatus responseStatus;
  final String responseMessage;

  const RevenueFormState({
    this.id = '',
    this.name = '',
    this.price = 0.0,
    this.revenueFormMode = RevenueFormMode.adding,
    this.recurrenceMode = RecurrenceMode.single,
    this.responseStatus = ResponseStatus.initial,
    this.responseMessage = '',
  });

  RevenueFormState copyWith({
    String? id,
    String? name,
    double? price,
    RevenueFormMode? revenueFormMode,
    RecurrenceMode? recurrenceMode,
    ResponseStatus? responseStatus,
    String? responseMessage,
  }) {
    return RevenueFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      revenueFormMode: revenueFormMode ?? this.revenueFormMode,
      recurrenceMode: recurrenceMode ?? this.recurrenceMode,
      responseStatus: responseStatus ?? this.responseStatus,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        revenueFormMode,
        recurrenceMode,
        responseStatus,
        responseMessage,
      ];
}
