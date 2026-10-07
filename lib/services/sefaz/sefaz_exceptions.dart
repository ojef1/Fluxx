/// Erros tratáveis da leitura de nota fiscal.
/// Todos caem no mesmo fluxo de erro da tela de leitura do QR Code.
abstract class SefazException implements Exception {
  final String message;
  const SefazException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class QrCodeInvalidoException extends SefazException {
  const QrCodeInvalidoException([super.message = 'QR Code inválido']);
}

class EstadoNaoSuportadoException extends SefazException {
  final String ufCode;
  EstadoNaoSuportadoException(this.ufCode)
      : super('Estado não suportado (código $ufCode)');
}

class SefazTimeoutException extends SefazException {
  const SefazTimeoutException([super.message = 'Tempo de espera esgotado']);
}

class SefazFalhaRedeException extends SefazException {
  const SefazFalhaRedeException([super.message = 'Falha de rede']);
}

class SefazHtmlNaoReconhecidoException extends SefazException {
  const SefazHtmlNaoReconhecidoException(
      [super.message = 'HTML da SEFAZ não reconhecido']);
}
