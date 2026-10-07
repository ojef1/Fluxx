import 'package:Fluxx/models/nota_fiscal_data.dart';
import 'package:Fluxx/services/sefaz/nfce_qr_code.dart';

/// Contrato para ler uma NFC-e no portal da SEFAZ de um estado.
/// Para suportar um novo estado, crie um `SefazParserXX` e registre no
/// [SefazParserFactory].
abstract class SefazParser {
  /// Busca e interpreta a nota do [qrCode].
  /// Lança uma `SefazException` em qualquer falha tratável.
  Future<NotaFiscalData> fetch(NfceQrCode qrCode);
}
