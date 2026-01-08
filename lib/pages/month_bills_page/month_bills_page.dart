import 'package:Fluxx/blocs/bills_cubit/bill_cubit.dart';
import 'package:Fluxx/blocs/bills_cubit/bill_state.dart';
import 'package:Fluxx/blocs/bills_cubit/bill_form_cubit.dart' as billform;
import 'package:Fluxx/blocs/bills_cubit/bill_list_cubit.dart';
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_form_cubit.dart' as cardform;
import 'package:Fluxx/blocs/invoices_cubits/invoices_list_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/pages/month_bills_page/commons_bills_page.dart';
import 'package:Fluxx/pages/month_bills_page/invoices_list_page.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MonthBillsPage extends StatefulWidget {
  const MonthBillsPage({super.key});

  @override
  State<MonthBillsPage> createState() => _MonthBillsPageState();
}

class _MonthBillsPageState extends State<MonthBillsPage> {
  late final MonthModel? monthInFocus;
  @override
  void initState() {
    monthInFocus = GetIt.I<ResumeCubit>().state.monthInFocus;
    GetIt.I<BillListCubit>().getAllBills(
      monthInFocus!.id!,
    );
    GetIt.I<InvoicesListCubit>().getInvoices(monthInFocus!.id!);
    super.initState();
  }

  @override
  void dispose() {
    GetIt.I<BillListCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: _ListenerWrapper(
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: AppTheme.colors.appBackgroundColor,
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(title: monthInFocus!.name ?? ''),
            body: SafeArea(
                child: Column(
              children: [
                const SizedBox(height: Constants.topMargin),
                TabBar(
                  tabs: const [
                    Tab(text: 'Faturas'),
                    Tab(text: 'Contas comuns'),
                  ],
                  labelColor: AppTheme.colors.white,
                  unselectedLabelColor: AppTheme.colors.white,
                  indicatorColor: AppTheme.colors.hintColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: AppTheme.textStyles.subTileTextStyle,
                  unselectedLabelStyle: AppTheme.textStyles.descTextStyle,
                  dividerColor: AppTheme.colors.appBackgroundColor,
                  overlayColor:
                      WidgetStatePropertyAll(AppTheme.colors.hintColor),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      InvoicesListPage(),
                      CommonsBillsPage(),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

class _ListenerWrapper extends StatelessWidget {
  final Widget child;
  const _ListenerWrapper({required this.child});

  void _getBills() {
    var monthInFocus = GetIt.I<ResumeCubit>().state.monthInFocus;
    GetIt.I<BillListCubit>().getAllBills(
      monthInFocus!.id!,
    );
  }

  void _getInvoices() {
    var monthInFocus = GetIt.I<ResumeCubit>().state.monthInFocus;
    GetIt.I<InvoicesListCubit>().getInvoices(
      monthInFocus!.id!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BillCubit, BillState>(
          listenWhen: (previous, current) =>
              previous.editBillsResponse != current.editBillsResponse,
          bloc: GetIt.I(),
          listener: (context, state) {
            if (state.editBillsResponse == EditBillsResponse.success) {
              _getBills();
            }
          },
        ),
        BlocListener<billform.BillFormCubit, billform.BillFormState>(
          listenWhen: (previous, current) =>
              previous.responseStatus != current.responseStatus,
          bloc: GetIt.I(),
          listener: (context, state) {
            if (state.responseStatus == billform.ResponseStatus.success) {
              _getBills();
            }
          },
        ),
        BlocListener<cardform.CreditCardFormCubit, cardform.CreditCardFormState>(
          listenWhen: (previous, current) => previous.responseStatus != current.responseStatus,
          bloc: GetIt.I(),
          listener: (context, state) {
            if (state.responseStatus == cardform.ResponseStatus.success) {
              _getInvoices();
            }
          },
        ),
      ],
      child: child,
    );
  }
}
