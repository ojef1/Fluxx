import 'package:Fluxx/blocs/bill_cubit/bill_cubit.dart';
import 'package:Fluxx/blocs/bill_cubit/bill_state.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PaymentDataPicker extends StatefulWidget {
  final IconData icon;
  final String hint;
  final Function(String) onDateChanged;
  const PaymentDataPicker(
      {super.key,
      required this.icon,
      required this.hint,
      required this.onDateChanged});

  @override
  State<PaymentDataPicker> createState() => _PaymentDataPickerState();
}

class _PaymentDataPickerState extends State<PaymentDataPicker> {
  late String? formattedDate;
  late MonthModel monthInFocus;

  @override
  void initState() {
    var paymentDate = GetIt.I<BillCubit>().state.paymentDate;
    _getCurrentMonth();
    var hasDate = paymentDate != '';
    formattedDate = hasDate ? paymentDate : null;
    super.initState();
  }

  Future<void> _getCurrentMonth() async {
    monthInFocus = GetIt.I<ResumeCubit>().state.monthInFocus!;
  }

  Future<void> selectDate(BuildContext context) async {
    debugPrint('Data > ${monthInFocus.toString()}');

    final int month = monthInFocus.id!;

    // Calcula o primeiro e último dia do mês especificado
    final DateTime firstDayOfMonth =
        DateTime(DateTime.now().year, month, 1); // Primeiro dia do mês

    final DateTime lastDayOfMonth = (month == 12)
        ? DateTime(DateTime.now().year + 1, 1,
            0) // Para dezembro, vai para janeiro do ano seguinte
        : DateTime(DateTime.now().year, month + 1,
            0); // Para outros meses, pega o último dia do mês

    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: firstDayOfMonth,
      lastDate: lastDayOfMonth,
      
    );
    if (picked != null) {
      setState(() {
        formattedDate = formatDate(picked.toString());
        widget.onDateChanged(picked.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<BillCubit, BillState>(
      bloc: GetIt.I(),
      listenWhen: (previous, current) =>
          previous.paymentDate != current.paymentDate,
      listener: (BuildContext context, BillState state) {
        setState(() {
          formattedDate = state.paymentDate;
        });
      },
      child: Container(
        width: mediaQuery.width * .85,
        height: mediaQuery.height * .07,
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
        decoration: BoxDecoration(
          color: AppTheme.colors.itemBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              readOnly: true,
              cursorColor: Colors.white,
              onTap: () => selectDate(context),
              style: AppTheme.textStyles.bodyTextStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: formattedDate ?? widget.hint,
                hintStyle: AppTheme.textStyles.bodyTextStyle,
              ),
            )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
              width: 1,
              color: AppTheme.colors.hintColor,
            ),
            Icon(
              widget.icon,
              color: AppTheme.colors.hintColor,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
