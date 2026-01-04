part of 'credit_card_form_cubit.dart';

enum CreditCardFormMode { adding, editing }

enum ResponseStatus { initial, loading, success, error }

class CreditCardFormState extends Equatable {
  final String name;
  final double creditLimit;
  final int bankId;
  final int networkId;
  final String lastFourDigits;
  final DateTime? closingDay;
  final DateTime? dueDay;
  final CreditCardFormMode creditCardFormMode;
  final ResponseStatus responseStatus;
  final String responseMessage;

  const CreditCardFormState({
    this.name = '',
    this.creditLimit = 0.0,
    this.bankId = 0,
    this.networkId = 0,
    this.lastFourDigits = '',
    this.closingDay,
    this.dueDay,
    this.creditCardFormMode = CreditCardFormMode.adding,
    this.responseStatus = ResponseStatus.initial,
    this.responseMessage = '',
  });

  CreditCardFormState copyWith({
    String? name,
    double? creditLimit,
    int? bankId,
    int? networkId,
    String? lastFourDigits,
    DateTime? closingDay,
    DateTime? dueDay,
    CreditCardFormMode? creditCardFormMode,
    ResponseStatus? responseStatus,
    String? responseMessage,
  }) {
    return CreditCardFormState(
      name: name ?? this.name,
      creditLimit: creditLimit ?? this.creditLimit,
      bankId: bankId ?? this.bankId,
      networkId: networkId ?? this.networkId,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      closingDay: closingDay ?? this.closingDay,
      dueDay: dueDay ?? this.dueDay,
      creditCardFormMode: creditCardFormMode ?? this.creditCardFormMode,
      responseStatus: responseStatus ?? this.responseStatus,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        creditLimit,
        bankId,
        networkId,
        lastFourDigits,
        closingDay,
        dueDay,
        creditCardFormMode,
        responseStatus,
        responseMessage,
      ];
}
