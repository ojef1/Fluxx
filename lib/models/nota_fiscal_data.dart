import 'package:Fluxx/utils/helpers.dart';

class NotaFiscalItem {
  final String name;
  final double quantity;
  final double unitPrice;
  final double total;

  const NotaFiscalItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

class NotaFiscalData {
  final String accessKey;
  final String emitente;
  final String? cnpj;
  final double total;
  final DateTime date;
  final List<NotaFiscalItem> items;

  const NotaFiscalData({
    required this.accessKey,
    required this.emitente,
    required this.total,
    required this.date,
    this.cnpj,
    this.items = const [],
  });

  /// Resumo dos itens para preencher a descrição da conta.
  /// Ex.: "4 itens: Refr Po Tang 18g, Steak Sadia 100grs..."
  String itemsDescription({int maxLength = 300}) {
    if (items.isEmpty) return '';

    final count = items.length;
    final header = count == 1 ? '1 item: ' : '$count itens: ';
    final buffer = StringBuffer(header);

    for (var i = 0; i < count; i++) {
      final name = capitalizeWordsPtBr(items[i].name);
      final separator = i == 0 ? '' : ', ';
      if (buffer.length + separator.length + name.length > maxLength - 3) {
        buffer.write('...');
        break;
      }
      buffer.write('$separator$name');
    }

    return buffer.toString();
  }
}
