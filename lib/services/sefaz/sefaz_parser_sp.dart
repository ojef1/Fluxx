import 'dart:async';
import 'dart:io';

import 'package:Fluxx/models/nota_fiscal_data.dart';
import 'package:Fluxx/services/sefaz/nfce_qr_code.dart';
import 'package:Fluxx/services/sefaz/sefaz_exceptions.dart';
import 'package:Fluxx/services/sefaz/sefaz_parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class SefazParserSP implements SefazParser {
  static const _allowedHost = 'www.nfce.fazenda.sp.gov.br';
  static const _timeout = Duration(seconds: 10);

  final http.Client? _client;

  SefazParserSP({http.Client? client}) : _client = client;

  @override
  Future<NotaFiscalData> fetch(NfceQrCode qrCode) async {
    // só consulta o portal da SEFAZ-SP, nunca uma URL arbitrária do QR Code
    if (qrCode.url.host != _allowedHost) {
      throw const QrCodeInvalidoException('URL fora do portal da SEFAZ-SP');
    }
    final url = qrCode.url.replace(scheme: 'https');

    final client = _client ?? http.Client();
    try {
      final response = await client.get(url).timeout(_timeout);
      if (response.statusCode != 200) {
        throw SefazFalhaRedeException('Status ${response.statusCode}');
      }
      return parseHtml(response.body, qrCode);
    } on TimeoutException {
      throw const SefazTimeoutException();
    } on IOException {
      throw const SefazFalhaRedeException();
    } on http.ClientException {
      throw const SefazFalhaRedeException();
    } finally {
      if (_client == null) client.close();
    }
  }

  /// Interpreta o HTML da "Consulta Resumida NFC-e" da SEFAZ-SP.
  NotaFiscalData parseHtml(String body, NfceQrCode qrCode) {
    final doc = html_parser.parse(body);

    if (doc.querySelector('#hdfNotaCancelada') != null ||
        doc.querySelector('#hdfNotaDenegada') != null) {
      throw const SefazHtmlNaoReconhecidoException('Nota cancelada ou denegada');
    }

    final emitente = doc.querySelector('#u20')?.text.trim();
    final total = _parseNumber(
        doc.querySelector('#totalNota .linhaShade .totalNumb')?.text);
    final date = _parseDate(doc.querySelector('#infos')?.text);

    if (emitente == null || emitente.isEmpty || total == null || date == null) {
      throw const SefazHtmlNaoReconhecidoException();
    }

    return NotaFiscalData(
      accessKey: qrCode.accessKey,
      emitente: emitente,
      cnpj: _parseCnpj(doc),
      total: total,
      date: date,
      items: _parseItems(doc),
    );
  }

  String? _parseCnpj(Document doc) {
    final text = doc.querySelector('.txtCenter .text')?.text;
    final match = RegExp(r'\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}').firstMatch(text ?? '');
    return match?.group(0);
  }

  List<NotaFiscalItem> _parseItems(Document doc) {
    final items = <NotaFiscalItem>[];
    for (final row in doc.querySelectorAll('#tabResult tr')) {
      final name = row.querySelector('.txtTit')?.text.trim();
      final total = _parseNumber(row.querySelector('.valor')?.text);
      if (name == null || name.isEmpty || total == null) continue;

      items.add(NotaFiscalItem(
        name: name,
        quantity: _parseNumber(_afterColon(row.querySelector('.Rqtd')?.text)) ?? 1,
        unitPrice:
            _parseNumber(_afterColon(row.querySelector('.RvlUnit')?.text)) ??
                total,
        total: total,
      ));
    }
    return items;
  }

  // "Qtde.:1" -> "1"
  String? _afterColon(String? text) {
    if (text == null) return null;
    final index = text.indexOf(':');
    return index == -1 ? text : text.substring(index + 1);
  }

  // "1.234,56" -> 1234.56
  double? _parseNumber(String? text) {
    if (text == null) return null;
    final normalized = text.trim().replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  // "Emissão: 27/09/2026 00:26:10"
  DateTime? _parseDate(String? text) {
    final match = RegExp(r'Emiss[ãa]o:\s*(\d{2})/(\d{2})/(\d{4})\s+(\d{2}):(\d{2}):(\d{2})')
        .firstMatch(text ?? '');
    if (match == null) return null;

    final parts = [for (var i = 1; i <= 6; i++) int.parse(match.group(i)!)];
    return DateTime(parts[2], parts[1], parts[0], parts[3], parts[4], parts[5]);
  }
}
