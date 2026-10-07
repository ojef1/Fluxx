import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';

enum AddBillOption { manual, qrCode }

/// Abre o bottom sheet com as formas de adicionar uma conta e segue o fluxo escolhido.
Future<void> showAddBillOptions(BuildContext context) async {
  final option = await showModalBottomSheet<AddBillOption>(
    context: context,
    builder: (context) => const AddBillOptionsBottomsheet(),
  );

  if (option == null || !context.mounted) return;

  switch (option) {
    case AddBillOption.manual:
      goToBillForm(context: context);
    case AddBillOption.qrCode:
      goToQrScanPage(context: context);
  }
}

class AddBillOptionsBottomsheet extends StatelessWidget {
  const AddBillOptionsBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.colors.itemBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Como você quer adicionar a conta?',
              style: AppTheme.textStyles.bodyTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 32),
            _OptionTile(
              icon: Icons.edit_rounded,
              title: 'Preencher manualmente',
              subtitle: 'Digite os dados da conta',
              onTap: () => Navigator.pop(context, AddBillOption.manual),
            ),
            const SizedBox(height: 12),
            _OptionTile(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Ler QR Code da nota',
              subtitle: 'Requer internet',
              onTap: () => Navigator.pop(context, AddBillOption.qrCode),
            ),
            const SizedBox(height: 12),
            //será implementado em outra tarefa
            const _OptionTile(
              icon: Icons.photo_camera_outlined,
              title: 'Foto da nota inteira',
              subtitle: 'Funciona sem QR Code',
              isDisabled: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDisabled ? null : AppTheme.colors.appBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDisabled
                  ? AppTheme.colors.appBackgroundColor
                  : AppTheme.colors.hintColor.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isDisabled
                  ? AppTheme.colors.hintTextColor
                  : AppTheme.colors.hintColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.textStyles.bodyTextStyle),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTheme.textStyles.secondaryTextStyle),
              ],
            ),
          ),
          if (isDisabled)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.colors.appBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Em breve', style: AppTheme.textStyles.secondaryTextStyle),
            ),
        ],
      ),
    );

    if (isDisabled) {
      return Opacity(
        opacity: .5,
        child: CustomPaint(
          foregroundPainter: _DashedBorderPainter(
            color: AppTheme.colors.hintTextColor,
            radius: 10,
          ),
          child: content,
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(radius),
      ));

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
