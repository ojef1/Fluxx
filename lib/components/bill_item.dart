import 'package:Fluxx/blocs/bills_cubit/bill_cubit.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:get_it/get_it.dart';

class BillItem extends StatefulWidget {
  final BillModel bill;

  const BillItem({
    super.key,
    required this.bill,
  });

  @override
  State<BillItem> createState() => _BillItemState();
}

class _BillItemState extends State<BillItem> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() => isExpanded = !isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: width * 0.015,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.itemBackgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: toggleExpanded,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 40,
                    color: AppTheme.colors.hintColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bill.name ?? '',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                      const SizedBox(height: 6),
                      AnimatedCrossFade(
                        crossFadeState: isExpanded
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                        firstCurve: Curves.easeInOut,
                        secondCurve: Curves.easeInOut,
                        firstChild: const SizedBox.shrink(),
                        secondChild: Row(
                          children: [
                            _InfoText(
                                formatDate(widget.bill.paymentDate) ?? ''),
                            Flexible(
                              fit: FlexFit.tight,
                              child: _InfoText(
                                'R\$ ${formatPrice(widget.bill.price ?? 0)}',
                              ),
                            ),
                            _InfoText(
                                widget.bill.isPayed == 1 ? 'Pago' : 'Pendente'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _ExpandedContent(bill: widget.bill),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  final BillModel bill;

  const _ExpandedContent({required this.bill});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.detailCommonBillPage,
        );
        GetIt.I<BillCubit>().getBill(bill.id!, bill.monthId!);
      },
      child: Column(
        children: [
          _RowItem(
            icon: Icons.sell_outlined,
            label: 'Categoria:',
            value: bill.categoryName ?? '—',
          ),
          _RowItem(
            icon: Icons.wallet_rounded,
            label: 'Receita usada:',
            value: bill.paymentName ?? '—',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 1),
          ),
          _RowItem(
            icon: Icons.calendar_today_outlined,
            label: 'Data de pagamento:',
            value: formatDate(bill.paymentDate) ?? '',
          ),
          _RowItem(
            icon: Icons.attach_money,
            label: 'Valor:',
            value: 'R\$ ${formatPrice(bill.price ?? 0)}',
          ),
          _RowItem(
            icon: bill.isPayed == 1
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            label: 'Status:',
            value: bill.isPayed == 1 ? 'Pago' : 'Pendente',
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RowItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTheme.textStyles.subTileTextStyle,
          ),
          const Spacer(),
          Text(
            value,
            style: AppTheme.textStyles.subTileTextStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;

  const _InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        text,
        style: AppTheme.textStyles.subTileTextStyle,
      ),
    );
  }
}
