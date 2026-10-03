part of 'qr_scan_cubit.dart';

enum QrScanStatus {
  initial, // verificando a permissão da câmera
  scanning, // câmera aberta, esperando um QR Code
  loading, // buscando os dados da nota
  success,
  error, // QR inválido, estado não suportado, rede, timeout ou HTML não reconhecido
  permissionDenied,
}

class QrScanState extends Equatable {
  final QrScanStatus status;

  const QrScanState({this.status = QrScanStatus.initial});

  QrScanState copyWith({QrScanStatus? status}) {
    return QrScanState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
