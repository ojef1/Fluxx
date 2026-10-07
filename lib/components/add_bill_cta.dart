import 'package:Fluxx/components/bottom_sheets/add_bill_options_bottomsheet.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// Card de destaque da Home para adicionar uma conta (manual, QR Code ou foto).
class AddBillCta extends StatelessWidget {
  const AddBillCta({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => showAddBillOptions(context),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: mediaQuery.width * .05),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.colors.hintColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 32,
                color: AppTheme.colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adicionar Conta',
                    style: AppTheme.textStyles.bodyTextStyle
                        .copyWith(color: AppTheme.colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manual, Qr code ou foto da nota fiscal',
                    style: AppTheme.textStyles.secondaryTextStyle.copyWith(
                      color: AppTheme.colors.white.withAlpha(200),
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
