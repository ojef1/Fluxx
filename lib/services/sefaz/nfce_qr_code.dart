import 'package:Fluxx/services/sefaz/sefaz_exceptions.dart';

/// Conteúdo lido do QR Code de uma NFC-e: a URL de consulta e a chave de acesso.
class NfceQrCode {
  static const _nfceModel = '65';

  final Uri url;
  final String accessKey;

  const NfceQrCode._({required this.url, required this.accessKey});

  /// Dois primeiros dígitos da chave de acesso (código da UF, ex.: 35 = SP).
  String get ufCode => accessKey.substring(0, 2);

  /// Extrai a URL e a chave de acesso do texto lido no QR Code.
  /// Lança [QrCodeInvalidoException] se não for o QR Code de uma NFC-e.
  factory NfceQrCode.parse(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw const QrCodeInvalidoException();
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw const QrCodeInvalidoException();
    }

    // QR Code v2: ?p=chave|versão|ambiente|idCSC|hash
    // QR Code v1: ?chNFe=chave&nVersao=...
    final p = uri.queryParameters['p'];
    final key = p != null ? p.split('|').first : uri.queryParameters['chNFe'];

    if (key == null || !_isValidAccessKey(key)) {
      throw const QrCodeInvalidoException();
    }

    return NfceQrCode._(url: uri, accessKey: key);
  }

  static bool _isValidAccessKey(String key) {
    if (!RegExp(r'^\d{44}$').hasMatch(key)) return false;
    // posições 20-21 da chave: modelo do documento (65 = NFC-e)
    if (key.substring(20, 22) != _nfceModel) return false;
    return _checkDigit(key.substring(0, 43)) == int.parse(key[43]);
  }

  // dígito verificador da chave de acesso (módulo 11, pesos de 2 a 9)
  static int _checkDigit(String digits) {
    var weight = 2;
    var sum = 0;
    for (var i = digits.length - 1; i >= 0; i--) {
      sum += int.parse(digits[i]) * weight;
      weight = weight == 9 ? 2 : weight + 1;
    }
    final rest = sum % 11;
    return rest < 2 ? 0 : 11 - rest;
  }
}
