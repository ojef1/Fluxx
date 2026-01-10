part of 'resume_cubit.dart';

enum TotalSpentStatus { initial, loading, success, error }
enum GetPriorityInvoiceStatus { initial, loading, success, error }

class ResumeState extends Equatable {
  final InvoiceModel? priorityInvoice;
  final List<CreditCardModel> cardsList;
  final TotalSpentStatus totalSpentStatus;
  final GetPriorityInvoiceStatus priorityInvoiceStatus;
  final double totalSpent;
  final double percentSpent;
  const ResumeState({
    this.priorityInvoice,
    this.cardsList = const [],
    this.totalSpentStatus = TotalSpentStatus.initial,
    this.priorityInvoiceStatus = GetPriorityInvoiceStatus.initial,
    this.totalSpent = 0.0,
    this.percentSpent = 0,
  });

  ResumeState copyWith({
    InvoiceModel? priorityInvoice,
    List<CreditCardModel>? cardsList,
    TotalSpentStatus? totalSpentStatus,
    GetPriorityInvoiceStatus? priorityInvoiceStatus,
    double? totalSpent,
    double? percentSpent,
  }) {
    return ResumeState(
      priorityInvoice: priorityInvoice ?? this.priorityInvoice,
      cardsList: cardsList ?? this.cardsList,
      totalSpentStatus: totalSpentStatus ?? this.totalSpentStatus,
      priorityInvoiceStatus: priorityInvoiceStatus ?? this.priorityInvoiceStatus,
      totalSpent: totalSpent ?? this.totalSpent,
      percentSpent: percentSpent ?? this.percentSpent,
    );
  }

  @override
  List<Object?> get props => [
        priorityInvoice,
        cardsList,
        totalSpentStatus,
        priorityInvoiceStatus,
        totalSpent,
        percentSpent,
      ];
}
