import 'package:Fluxx/models/bank_model.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';

class InvoiceItem extends StatefulWidget {
  final InvoiceModel invoice;
  final CreditCardModel card;
  const InvoiceItem({super.key, required this.invoice, required this.card});

  @override
  State<InvoiceItem> createState() => _InvoiceItemState();
}

class _InvoiceItemState extends State<InvoiceItem> {
  late final BankModel bank;
  late final bool hasOnlyOneBill;

  @override
  void initState() {
    bank = getBank(widget.card.bankId ?? 0);
    hasOnlyOneBill = (widget.invoice.invoiceBillsLength ?? 0) <= 1;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    double boxHeight = mediaQuery.height * .15;
    return GestureDetector(
      onTap: () =>
          goToInvoiceBillPage(context: context, invoice: widget.invoice),
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: EdgeInsets.symmetric(
          horizontal: mediaQuery.width * 0.05,
          vertical: mediaQuery.width * 0.015,
        ),
        height: boxHeight,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppTheme.colors.itemBackgroundColor,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    bank.name,
                    style: AppTheme.textStyles.bodyTextStyle,
                  ),
                ),
                Text(
                  getInvoiceStatus(
                    endDate: widget.invoice.endDate ?? '',
                    dueDay: int.parse(widget.invoice.dueDate ?? '0'),
                    isPaid: widget.invoice.isPaid == 1,
                  ),
                  style: AppTheme.textStyles.secondaryTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$${formatPrice(
                    widget.invoice.price ?? 0.0,
                  )}',
                  style: AppTheme.textStyles.titleTextStyle,
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.colors.white,
                  size: 15,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.invoice.invoiceBillsLength} ${(hasOnlyOneBill ? 'compra' : 'compras')} nessa fatura',
                  style: AppTheme.textStyles.secondaryTextStyle,
                ),
                Text(
                  'final ${widget.card.lastFourDigits}',
                  style: AppTheme.textStyles.secondaryTextStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
