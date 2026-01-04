import 'package:Fluxx/models/bank_model.dart';
import 'package:Fluxx/models/card_network_model.dart';
import 'package:Fluxx/models/month_model.dart';

class Constants {
  static const defaultPicture = 'assets/images/default_user.jpeg';
  static const topMargin = 20.0;
}

class AppMonths {
  static List<MonthModel> all = [
    MonthModel(monthNumber: 1, name: 'Janeiro'),
    MonthModel(monthNumber: 2, name: 'Fevereiro'),
    MonthModel(monthNumber: 3, name: 'Março'),
    MonthModel(monthNumber: 4, name: 'Abril'),
    MonthModel(monthNumber: 5, name: 'Maio'),
    MonthModel(monthNumber: 6, name: 'Junho'),
    MonthModel(monthNumber: 7, name: 'Julho'),
    MonthModel(monthNumber: 8, name: 'Agosto'),
    MonthModel(monthNumber: 9, name: 'Setembro'),
    MonthModel(monthNumber: 10, name: 'Outubro'),
    MonthModel(monthNumber: 11, name: 'Novembro'),
    MonthModel(monthNumber: 12, name: 'Dezembro'),
  ];
}

class Banks {
   static const String _banks = 'assets/images/banks_path';
  static List<BankModel> all = [
    BankModel(id: 1, name: 'Nubank',iconPath: '$_banks/nubank.png'),
    BankModel(id: 2, name: 'Inter',iconPath: '$_banks/inter.png'),
    BankModel(id: 3, name: 'Santander',iconPath: '$_banks/santander.png'),
    BankModel(id: 4, name: 'Bradesco',iconPath: '$_banks/bradesco.png'),
    BankModel(id: 5, name: 'Itaú',iconPath: '$_banks/itau.png'),
    BankModel(id: 6, name: 'Caixa Econômica Federal',iconPath: '$_banks/caixa_economica_federal.png'),
    BankModel(id: 7, name: 'Banco do Brasil',iconPath: '$_banks/banco_do_brasil.png'),
    BankModel(id: 8, name: 'C6 Bank',iconPath: '$_banks/c6.png'),
    BankModel(id: 9, name: 'Safra',iconPath: '$_banks/safra.png'),
    BankModel(id: 10, name: 'Pan',iconPath: '$_banks/pan.png'),
    BankModel(id: 11, name: 'Banrisul',iconPath: '$_banks/banrisul.png'),
    BankModel(id: 12, name: 'PagBank',iconPath: '$_banks/pagbank.png'),
    BankModel(id: 13, name: 'Neon',iconPath: '$_banks/neon.png'),
    BankModel(id: 14, name: 'Next',iconPath: '$_banks/next.png'),
    BankModel(id: 15, name: 'Mercado Pago',iconPath: '$_banks/mercado_pago.png'),
    BankModel(id: 15, name: 'Original',iconPath: '$_banks/original.png'),
    BankModel(id: 15, name: 'BV',iconPath: '$_banks/bv.png'),
    BankModel(id: 15, name: 'agiBank',iconPath: '$_banks/agibank.png'),
    BankModel(id: 16, name: 'Outro',iconPath: '$_banks/outro.png'),
  ];
}

class CardNetwork {
   static const String _cardNetworks = 'assets/images/cardNetworks_path';
  static List<CardNetworkModel> all = [
    CardNetworkModel(id : 1, name: 'Visa', iconPath: '$_cardNetworks/visa.png'),
    CardNetworkModel(id : 2, name: 'Mastercard', iconPath: '$_cardNetworks/mastercard.jpg'),
    CardNetworkModel(id : 3, name: 'Elo', iconPath: '$_cardNetworks/elo.png'),
    CardNetworkModel(id : 4, name: 'HiperCard', iconPath: '$_cardNetworks/hipercard.jpg'),
    CardNetworkModel(id : 5, name: 'AmericanExpress (Amex)', iconPath: '$_cardNetworks/amex.jpg'),
    CardNetworkModel(id : 6, name: 'Diners Club', iconPath: '$_cardNetworks/diners.png'),
  ];
}
