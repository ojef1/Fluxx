part of 'credit_card_list_cubit.dart';

enum ResponseStatus { initial, loading, success, error }

class CreditCardListState extends Equatable {
  final List<CreditCardModel> cardList;
  final ResponseStatus status;
  final String responseMessage;

  const CreditCardListState({
    this.cardList = const [],
    this.status = ResponseStatus.initial,
    this.responseMessage = '',
  });

  CreditCardListState copyWith({
    List<CreditCardModel>? cardList,
    ResponseStatus? status,
    String? responseMessage,
  }) {
    return CreditCardListState(
      cardList: cardList ?? this.cardList,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  @override
  List<Object?> get props => [
        cardList,
        status,
        responseMessage,
      ];
}
