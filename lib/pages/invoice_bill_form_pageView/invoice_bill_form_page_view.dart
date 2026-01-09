import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/blocs/credit_card_cubits/credit_card_form_cubit.dart'
    as cardform;
import 'package:Fluxx/blocs/invoices_cubits/invoice_bill_form_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/custom_big_text_field.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_category_list.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_revenue_list.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/bank_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

part 'name_invoice_bill_page.dart';
part 'price_invoice_bill_page.dart';
part 'date_invoice_bill_page.dart';
part 'desc_invoice_bill_page.dart';
part 'category_invoice_bill_page.dart';
part 'payment_invoice_bill_page.dart';
part 'repeat_invoice_bill_page.dart.dart';
part 'check_invoice_bill_page.dart';

class InvoiceBillFormPageview extends StatefulWidget {
  const InvoiceBillFormPageview({super.key});

  @override
  State<InvoiceBillFormPageview> createState() =>
      _InvoiceBillFormPageviewState();
}

class _InvoiceBillFormPageviewState extends State<InvoiceBillFormPageview> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Future<bool> Function()? _currentValidator;
  late final InvoiceBillFormMode billFormMode;
  late final bool shouldShowRepeatPage;
  late final bool isDecember;

  @override
  void initState() {
    _pageController = PageController();
    billFormMode = GetIt.I<InvoiceBillFormCubit>().state.billFormMode;
    if(billFormMode == InvoiceBillFormMode.editing){
      //no modo edição, não passamos pela página da data onde essa função é chamada
      //portante definimos ela aqui.
      GetIt.I<InvoiceBillFormCubit>().updateSelectedMonth(DateTime.now());
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    GetIt.I<InvoiceBillFormCubit>().resetState();
    super.dispose();
  }

  List<Widget> get _listPageWidgets {
    if (billFormMode == InvoiceBillFormMode.adding) {
      return [
        NameInvoiceBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        PriceInvoiceBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        //
        DateInvoiceBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        DescBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        CategoryBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        //
        PaymentInvoiceBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        //
        RepeatInvoiceBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        CheckBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
      ];
    } else {
      return [
        NameInvoiceBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        PriceInvoiceBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        DescBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        CategoryBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
        CheckBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<InvoiceBillFormCubit, InvoiceBillFormState>(
        bloc: GetIt.I(),
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            showFlushbar(context, state.responseMessage, false);
            Navigator.pop(context);
          }
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: BlocBuilder<InvoiceBillFormCubit, InvoiceBillFormState>(
              bloc: GetIt.I(),
              buildWhen: (previous, current) =>
                  previous.billFormMode != current.billFormMode,
              builder: (context, state) {
                bool isEditing =
                    state.billFormMode == InvoiceBillFormMode.editing;
                return Scaffold(
                  backgroundColor: AppTheme.colors.appBackgroundColor,
                  resizeToAvoidBottomInset: true,
                  appBar: CustomAppBar(
                    title: isEditing ? 'Editar Compra' : 'Adicionar Compra',
                    backButton: () {
                      if (_currentIndex == 0) {
                        Navigator.pop(context);
                      } else {
                        _pageController.previousPage(
                            duration: Durations.medium2,
                            curve: Curves.bounceInOut);
                      }
                    },
                    actions: [
                      if (_currentIndex != 0)
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 28,
                            color: AppTheme.colors.hintColor,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                    ],
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _listPageWidgets.length,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: index == _currentIndex
                                        ? AppTheme.colors.hintColor
                                        : AppTheme.colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() => _currentIndex = index);
                            },
                            children: _listPageWidgets,
                          ),
                        ),
                        BlocBuilder<InvoiceBillFormCubit, InvoiceBillFormState>(
                            bloc: GetIt.I(),
                            buildWhen: (previous, current) =>
                                previous.responseStatus !=
                                current.responseStatus,
                            builder: (context, state) {
                              bool isLoading = state.responseStatus ==
                                  ResponseStatus.loading;
                              return PrimaryButton(
                                text: 'Continuar',
                                isLoading: isLoading,
                                onPressed: isLoading
                                    ? () {}
                                    : () async {
                                        if (_currentValidator == null) return;

                                        final ok = await _currentValidator!();

                                        if (!ok) return;

                                        if (_currentIndex ==
                                            _listPageWidgets.length - 1) {
                                          //se for a ultima página, salva a conta
                                          await GetIt.I<InvoiceBillFormCubit>()
                                              .submitBill();
                                        } else {
                                          _pageController.nextPage(
                                            duration: Durations.medium2,
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                width: mediaQuery.width * .85,
                                color: AppTheme.colors.hintColor,
                                textStyle: AppTheme.textStyles.bodyTextStyle,
                              );
                            }),
                        SizedBox(height: mediaQuery.height * .03),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }

  void _showError(String msg) {
    showFlushbar(context, msg, true);
  }

  void _registerValidator(Future<bool> Function() fn) {
    _currentValidator = fn;
  }
}
