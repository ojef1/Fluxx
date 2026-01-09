import 'package:Fluxx/blocs/bills_cubit/bill_cubit.dart';
import 'package:Fluxx/blocs/bills_cubit/bill_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/auto_marquee_text.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class DetailCommonBillPage extends StatefulWidget {
  const DetailCommonBillPage({super.key});

  @override
  State<DetailCommonBillPage> createState() => _DetailCommonBillPageState();
}

class _DetailCommonBillPageState extends State<DetailCommonBillPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) => _exit(didPop),
        child: Scaffold(
          backgroundColor: AppTheme.colors.appBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            title: 'Detalhes',
            backButton: () => _exit(false),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width * .08,
                ),
                child: BlocBuilder<BillCubit, BillState>(
                  bloc: GetIt.I(),
                  buildWhen: (previous, current) =>
                      previous.detailBill != current.detailBill,
                  builder: (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton.filled(
                            onPressed: () => goToBillForm(
                                context: context, bill: state.detailBill),
                            icon: Icon(
                              Icons.mode_edit_rounded,
                              color: AppTheme.colors.white,
                            ),
                            style: IconButton.styleFrom(
                                minimumSize: const Size(55, 55),
                                backgroundColor: AppTheme.colors.hintColor),
                          ),
                          const SizedBox(width: 5),
                          IconButton.filled(
                            onPressed: () =>
                                _showDeleteDialog(context, state.detailBill!),
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: AppTheme.colors.white,
                            ),
                            style: IconButton.styleFrom(
                                minimumSize: const Size(55, 55),
                                backgroundColor: AppTheme.colors.hintColor),
                          ),
                          const SizedBox(width: 5),
                          AnimatedToggleSwitch<bool>.dual(
                            current: state.detailBill?.isPayed == 1,
                            first: false,
                            second: true,
                            spacing: 55.0,
                            style: const ToggleStyle(
                              borderColor: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1.5),
                                ),
                              ],
                            ),
                            borderWidth: 5.0,
                            height: 55,
                            onChanged: (b) {
                              GetIt.I<BillCubit>()
                                  .updateBillPaymentStatus(b ? 1 : 0);
                            },
                            styleBuilder: (b) => ToggleStyle(
                                backgroundColor: b
                                    ? AppTheme.colors.hintColor
                                    : AppTheme.colors.lightHintColor,
                                indicatorColor: AppTheme.colors.white),
                            iconBuilder: (value) => value
                                ? const Icon(Icons.check_rounded)
                                : const Icon(Icons.close_rounded),
                            textBuilder: (value) => value
                                ? Center(
                                    child: Text(
                                    'Pago',
                                    style: AppTheme.textStyles.bodyTextStyle,
                                  ))
                                : Center(
                                    child: Text(
                                    'Pendente',
                                    style: AppTheme.textStyles.bodyTextStyle,
                                  )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 65),
                      _DataItem(
                          title: 'Nome da conta',
                          subtitle: state.detailBill?.name ?? ''),
                      _DataItem(
                          title: 'Data de Pagamento',
                          subtitle:
                              formatDate(state.detailBill?.paymentDate) ?? ''),
                      _DataItem(
                          title: 'Valor',
                          subtitle:
                              'R\$${formatPrice(state.detailBill?.price ?? 0.0)}'),
                      _DataItem(
                          title: 'Receita usada',
                          subtitle: state.detailBill?.paymentName ?? ''),
                      _DataItem(
                          title: 'Categoria',
                          subtitle: state.detailBill?.categoryName ?? ''),
                      _DataItem(
                          title: 'Descrição',
                          subtitle: state.detailBill?.description ?? ''),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exit(bool fromPopInvoked) async {
    var isPayedStatus = GetIt.I<BillCubit>().state.detailBill?.isPayed;
    await GetIt.I<BillCubit>().submitPaymentStatus(isPayedStatus!);
    if (!fromPopInvoked) Navigator.pop(context);
  }

  void _showDeleteDialog(BuildContext context, BillModel bill) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppTheme.colors.appBackgroundColor,
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            maxLines: 4,
            textAlign: TextAlign.center,
            'Tem certeza de que deseja excluir este item?',
            style: AppTheme.textStyles.tileTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: AppTheme.textStyles.secondaryTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeBill(bill);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Excluir',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeBill(BillModel bill) async {
    var result = await GetIt.I<BillCubit>().removeBill(bill.id!, bill.monthId!);
    var state = GetIt.I<BillCubit>().state;
    if (result > 0) {
      Navigator.pop(context);
      showFlushbar(context, state.successMessage, false);
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }
}

class _DataItem extends StatelessWidget {
  final String title;
  final String subtitle;
  const _DataItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        AutoMarqueeText(
          text: title,
          style: AppTheme.textStyles.secondaryTextStyle
              .copyWith(color: AppTheme.colors.hintTextColor.withAlpha(100)),
          
        ),
        Text(
          subtitle.isNotEmpty
              ? subtitle
              : 'sem ${title.toLowerCase()} informado(a)',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        Divider(
          color: AppTheme.colors.hintTextColor,
          thickness: 1,
        ),
      ],
    );
  }
}
