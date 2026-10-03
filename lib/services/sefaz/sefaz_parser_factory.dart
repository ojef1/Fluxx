import 'package:Fluxx/services/sefaz/nfce_qr_code.dart';
import 'package:Fluxx/services/sefaz/sefaz_exceptions.dart';
import 'package:Fluxx/services/sefaz/sefaz_parser.dart';
import 'package:Fluxx/services/sefaz/sefaz_parser_sp.dart';

class SefazParserFactory {
  // código da UF (2 primeiros dígitos da chave de acesso) -> parser
  static final Map<String, SefazParser Function()> _parsers = {
    '35': () => SefazParserSP(),
  };

  /// Resolve o parser do estado da nota.
  /// Lança [EstadoNaoSuportadoException] se o estado não tiver parser.
  static SefazParser fromQrCode(NfceQrCode qrCode) {
    final parser = _parsers[qrCode.ufCode];
    if (parser == null) throw EstadoNaoSuportadoException(qrCode.ufCode);
    return parser();
  }
}
