import 'package:Fluxx/blocs/bill_cubit/bill_cubit.dart';
import 'package:Fluxx/blocs/bill_cubit/bill_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class DetailBillPage extends StatefulWidget {
  const DetailBillPage({super.key});

  @override
  State<DetailBillPage> createState() => _DetailBillPageState();
}

class _DetailBillPageState extends State<DetailBillPage> {
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
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title: 'Detalhes',
          backButton: _exit,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * .05,
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
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.addBillPage,
                            arguments: state.detailBill,
                          ),
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
                          // onPressed: () => _removeBill(state.detailBill!),
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
                            setState(
                              () {
                                b
                                    ? state.detailBill?.isPayed = 1
                                    : state.detailBill?.isPayed = 0;
                              },
                            );
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
                    const SizedBox(height: 35),
                    Text(
                      state.detailBill?.name ?? 'Nome não encontrado',
                      style: AppTheme.textStyles.bodyTextStyle
                          .copyWith(fontSize: AppTheme.fontSizes.xlarge),
                    ),
                    const SizedBox(height: 30),
                    _DetailItem(
                        icon: Icons.date_range_rounded,
                        title: 'Data do pagamento',
                        subtitle: state.detailBill?.paymentDate ?? 'Sem data'),
                    const SizedBox(height: 15),
                    _DetailItem(
                        icon: Icons.monetization_on_outlined,
                        title: 'Valor',
                        subtitle:
                            'R\$${formatPrice(state.detailBill?.price ?? 0.0)}'),
                    const SizedBox(height: 15),
                    _DetailItem(
                        icon: Icons.wallet_rounded,
                        title: 'Renda Usada',
                        subtitle: state.detailBill?.paymentName ?? 'Sem Renda'),
                    const SizedBox(height: 15),
                    _DetailItem(
                        icon: Icons.category_rounded,
                        title: 'Categoria',
                        subtitle:
                            state.detailBill?.categoryName ?? 'Sem Categoria'),
                    const SizedBox(height: 30),
                    Text(
                      'Descrição',
                      style: AppTheme.textStyles.bodyTextStyle
                          .copyWith(fontSize: AppTheme.fontSizes.xlarge),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      state.detailBill?.description ?? '',
                      style: AppTheme.textStyles.subTileTextStyle,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exit() async {
    var state = GetIt.I<BillCubit>().state;
    await GetIt.I<BillCubit>().editBill(state.detailBill!);
    Navigator.pop(context);
  }

  void _showDeleteDialog(BuildContext context, BillModel bill) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
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

class _DetailItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const _DetailItem(
      {required this.subtitle, required this.title, required this.icon});

  @override
  State<_DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<_DetailItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.colors.hintColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                color: AppTheme.colors.white,
                size: 30,
                shadows: [
                  BoxShadow(
                    color: AppTheme.colors.black,
                    offset: const Offset(1, 1),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            title: Text(
              widget.title,
              style: AppTheme.textStyles.bodyTextStyle,
            ),
            subtitle: Text(
              widget.subtitle,
              style: AppTheme.textStyles.subTileTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
