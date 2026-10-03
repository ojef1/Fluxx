import 'dart:developer';

import 'package:Fluxx/blocs/bills_cubit/bill_form_cubit.dart';
import 'package:Fluxx/services/sefaz/nfce_qr_code.dart';
import 'package:Fluxx/services/sefaz/sefaz_parser_factory.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

part 'qr_scan_state.dart';

class QrScanCubit extends Cubit<QrScanState> {
  QrScanCubit() : super(const QrScanState());

  /// Pede a permissão da câmera só quando a tela de leitura é aberta.
  Future<void> checkPermission() async {
    final permission = await Permission.camera.request();
    emit(state.copyWith(
      status: permission.isGranted
          ? QrScanStatus.scanning
          : QrScanStatus.permissionDenied,
    ));
  }

  void onPermissionDenied() {
    emit(state.copyWith(status: QrScanStatus.permissionDenied));
  }

  Future<void> onQrDetected(String rawValue) async {
    //a câmera detecta o mesmo QR Code várias vezes, só a primeira leitura vale
    if (state.status != QrScanStatus.scanning) return;
    emit(state.copyWith(status: QrScanStatus.loading));

    try {
      final qrCode = NfceQrCode.parse(rawValue);
      final parser = SefazParserFactory.fromQrCode(qrCode);
      final nota = await parser.fetch(qrCode);

      await GetIt.I<BillFormCubit>().loadBillFromNota(nota);
      emit(state.copyWith(status: QrScanStatus.success));
    } catch (e) {
      log('$e', name: 'onQrDetected');
      emit(state.copyWith(status: QrScanStatus.error));
    }
  }

  void retry() {
    emit(state.copyWith(status: QrScanStatus.scanning));
  }

  void resetState() {
    emit(const QrScanState());
  }
}
