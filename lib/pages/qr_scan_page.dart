import 'package:Fluxx/blocs/qr_scan_cubit/qr_scan_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/qr_scan_status_view.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    GetIt.I<QrScanCubit>().checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    GetIt.I<QrScanCubit>().resetState();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //o usuário pode ter ativado a permissão nas configurações do app
    if (state == AppLifecycleState.resumed &&
        GetIt.I<QrScanCubit>().state.status == QrScanStatus.permissionDenied) {
      GetIt.I<QrScanCubit>().checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrScanCubit, QrScanState>(
      bloc: GetIt.I(),
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == QrScanStatus.success,
      listener: (context, state) {
        //os dados da nota já estão no formulário, que abre direto na revisão
        goToBillForm(context: context, replace: true);
      },
      builder: (context, state) {
        final isScanning = state.status == QrScanStatus.initial ||
            state.status == QrScanStatus.scanning;
        return AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: AppTheme.colors.appBackgroundColor,
            appBar: isScanning ? const CustomAppBar(title: 'Ler QR Code') : null,
            body: SafeArea(child: _buildBody(state)),
          ),
        );
      },
    );
  }

  Widget _buildBody(QrScanState state) {
    switch (state.status) {
      case QrScanStatus.initial:
        return const SizedBox.shrink();
      case QrScanStatus.scanning:
        return _QrScannerView(
          onDetect: GetIt.I<QrScanCubit>().onQrDetected,
          onPermissionDenied: GetIt.I<QrScanCubit>().onPermissionDenied,
        );
      case QrScanStatus.loading:
      case QrScanStatus.success:
        return const _LoadingView();
      case QrScanStatus.error:
        return QrScanStatusView(
          icon: Icons.warning_amber_rounded,
          iconColor: AppTheme.colors.red,
          iconBackgroundColor: AppTheme.colors.red.withAlpha(50),
          title: 'Não conseguimos ler essa nota',
          subtitle:
              'Verifique sua internet ou tente novamente com o QR Code visível',
          primaryText: 'Tentar novamente',
          onPrimaryPressed: GetIt.I<QrScanCubit>().retry,
          onManualPressed: _fillManually,
        );
      case QrScanStatus.permissionDenied:
        return QrScanStatusView(
          icon: Icons.no_photography_outlined,
          iconColor: AppTheme.colors.hintTextColor,
          iconBackgroundColor: AppTheme.colors.itemBackgroundColor,
          title: 'Precisamos da câmera pra ler o QR Code',
          subtitle: 'Ative a permissão de câmera nas configurações do app',
          primaryText: 'Abrir configurações',
          onPrimaryPressed: openAppSettings,
          onManualPressed: _fillManually,
        );
    }
  }

  void _fillManually() {
    goToBillForm(context: context, replace: true);
  }
}

class _QrScannerView extends StatefulWidget {
  final void Function(String rawValue) onDetect;
  final VoidCallback onPermissionDenied;

  const _QrScannerView({
    required this.onDetect,
    required this.onPermissionDenied,
  });

  @override
  State<_QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<_QrScannerView> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          child: MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final rawValue = capture.barcodes
                  .map((barcode) => barcode.rawValue)
                  .whereType<String>()
                  .firstOrNull;
              if (rawValue != null) widget.onDetect(rawValue);
            },
            errorBuilder: (context, error, child) {
              if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
                //a permissão foi negada/revogada com a câmera já aberta
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => widget.onPermissionDenied());
              }
              return Center(
                child: Text(
                  'Não foi possível abrir a câmera',
                  style: AppTheme.textStyles.secondaryTextStyle,
                ),
              );
            },
          ),
        ),
        const Center(child: _QrFrame()),
        Positioned(
          left: mediaQuery.width * .1,
          right: mediaQuery.width * .1,
          bottom: mediaQuery.height * .06,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.colors.itemBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Posicione o QR Code da nota dentro da moldura',
              style: AppTheme.textStyles.secondaryTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              color: AppTheme.colors.hintColor,
              strokeWidth: 6,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Buscando dados da nota',
            style: AppTheme.textStyles.bodyTextStyle,
          ),
          const SizedBox(height: 8),
          Text(
            'Isso pode levar alguns segundos',
            style: AppTheme.textStyles.secondaryTextStyle,
          ),
        ],
      ),
    );
  }
}

/// Moldura de guia com os quatro cantos arredondados.
class _QrFrame extends StatelessWidget {
  const _QrFrame();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(240, 240),
      painter: _QrFramePainter(color: AppTheme.colors.hintColor),
    );
  }
}

class _QrFramePainter extends CustomPainter {
  final Color color;

  _QrFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 24.0;
    const arm = 56.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    final path = Path()
      // superior esquerdo
      ..moveTo(0, arm)
      ..lineTo(0, radius)
      ..arcToPoint(const Offset(radius, 0), radius: const Radius.circular(radius))
      ..lineTo(arm, 0)
      // superior direito
      ..moveTo(w - arm, 0)
      ..lineTo(w - radius, 0)
      ..arcToPoint(Offset(w, radius), radius: const Radius.circular(radius))
      ..lineTo(w, arm)
      // inferior direito
      ..moveTo(w, h - arm)
      ..lineTo(w, h - radius)
      ..arcToPoint(Offset(w - radius, h), radius: const Radius.circular(radius))
      ..lineTo(w - arm, h)
      // inferior esquerdo
      ..moveTo(arm, h)
      ..lineTo(radius, h)
      ..arcToPoint(Offset(0, h - radius), radius: const Radius.circular(radius))
      ..lineTo(0, h - arm);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_QrFramePainter oldDelegate) => oldDelegate.color != color;
}
