class CreditCardModel {
  String? id;
  String? name;
  double? creditLimit;
  int? closingDay;
  int? dueDay;
  int? bankId;
  int? networkId;
  String? lastFourDigits;

  CreditCardModel({
    this.id,
    this.name,
    this.creditLimit,
    this.closingDay,
    this.dueDay,
    this.bankId,
    this.networkId,
    this.lastFourDigits,
  });

  CreditCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    creditLimit = json['total_limit'];
    closingDay = json['closing_day'];
    dueDay = json['due_day'];
    bankId = json['bank_id'];
    networkId = json['network_id'];
    lastFourDigits = json['last_digits'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['total_limit'] = creditLimit;
    data['closing_day'] = closingDay;
    data['due_day'] = dueDay;
    data['bank_id'] = bankId;
    data['network_id'] = networkId;
    data['last_digits'] = lastFourDigits;
    return data;
  }

  @override
  String toString() {
    return 'CreditCardModel{id: $id, name: $name, creditLimit: $creditLimit, closingDay: $closingDay, dueDay: $dueDay, bankId: $bankId, networkId: $networkId, lastFourDigits: $lastFourDigits}';
  }
}
