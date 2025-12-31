import 'dart:developer';

import 'package:Fluxx/blocs/bill_form_cubit/bill_form_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/bottom_sheets/revenue_missing_warning_bottomsheet.dart';
import 'package:Fluxx/components/custom_big_text_field.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_category_list.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_revenue_list.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

part 'name_bill_page.dart';
part 'price_bill_page.dart';
part 'date_bill_page.dart';
part 'desc_bill_page.dart';
part 'category_bill_page.dart';
part 'payment_bill_page.dart';
part 'repeat_bill_page.dart.dart';
part 'check_bill_page.dart';

class BillFormPageview extends StatefulWidget {
  const BillFormPageview({super.key});

  @override
  State<BillFormPageview> createState() => _BillFormPageviewState();
}

class _BillFormPageviewState extends State<BillFormPageview> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Future<bool> Function()? _currentValidator;
  late final MonthModel _currentMonth;
  late final BillFormMode billFormMode;
  late final bool shouldShowRepeatPage;
  late final bool isDecember;

  @override
  void initState() {
    _pageController = PageController();
    _currentMonth = GetIt.I<ResumeCubit>().state.monthInFocus!;
    //TODO trocar string por variável constante
    isDecember = _currentMonth.name == 'Dezembro';
    billFormMode = GetIt.I<BillFormCubit>().state.billFormMode;
    shouldShowRepeatPage = !isDecember && billFormMode != BillFormMode.editing;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    GetIt.I<BillFormCubit>().resetState();
    super.dispose();
  }

  List<Widget> get _listPageWidgets {
    List<Widget> pages = [
      NameBillPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      PriceBillPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      DateBillPage(
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
      PaymentBillPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
    ];

    //o limite de meses para repetição é até dezembro do ano corrente
    //a repetição não pode ser editada
    //portanto se o mês atual for dezembro ou o fomulário estiver em modo de edição, não faz sentido mostrar a página de repetição
    if (shouldShowRepeatPage) {
      pages.add(
        RepeatBillPage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
        ),
      );
    }

    pages.add(
      CheckBillPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
    );

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<BillFormCubit, BillFormState>(
        bloc: GetIt.I(),
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            showFlushbar(context, state.responseMessage, false);
            Navigator.pop(context);
          }
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: BlocBuilder<BillFormCubit, BillFormState>(
              bloc: GetIt.I(),
              buildWhen: (previous, current) =>
                  previous.billFormMode != current.billFormMode,
              builder: (context, state) {
                bool isEditing = state.billFormMode == BillFormMode.editing;
                return Scaffold(
                  backgroundColor: AppTheme.colors.appBackgroundColor,
                  resizeToAvoidBottomInset: true,
                  appBar: CustomAppBar(
                    title: isEditing ? 'Editar Conta' : 'Adicionar Conta',
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
                        BlocBuilder<BillFormCubit, BillFormState>(
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
                                          await GetIt.I<BillFormCubit>()
                                              .submitBill();
                                        } else {
                                          _pageController.nextPage(
                                            duration: Durations.medium2,
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                width: mediaQuery.width * .85,
                                color: AppTheme.colors.itemBackgroundColor,
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
