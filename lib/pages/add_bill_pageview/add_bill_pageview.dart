import 'dart:developer';

import 'package:Fluxx/blocs/add_bill_cubit/add_bill_cubit.dart';
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

class AddBillPageview extends StatefulWidget {
  const AddBillPageview({super.key});

  @override
  State<AddBillPageview> createState() => _AddBillPageviewState();
}

class _AddBillPageviewState extends State<AddBillPageview> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Future<bool> Function()? _currentValidator;
  late final MonthModel _currentMonth;
  late final List<DateTime> nextMonthsList;

  @override
  void initState() {
    _pageController = PageController();
    _currentMonth = GetIt.I<ResumeCubit>().state.monthInFocus!;
    log('Mês atual: ${_currentMonth.name}', name: '_AddBillPageviewState.initState');
    nextMonthsList = getNextMonthsUntilDecember(_currentMonth);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    GetIt.I<AddBillCubit>().resetState();
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
    //portanto se o mês atual for dezembro, não faz sentido mostrar a página de repetição
    if (nextMonthsList.isNotEmpty) {
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
    return BlocListener<AddBillCubit, AddBillState>(
        bloc: GetIt.I(),
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            showFlushbar(context, 'Conta adicionada com sucesso!', false);
            Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
          }
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: AppTheme.colors.appBackgroundColor,
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(
              title: 'Adicionar Conta',
              backButton: () {
                if (_currentIndex == 0) {
                  Navigator.pop(context);
                } else {
                  _pageController.previousPage(
                      duration: Durations.medium2, curve: Curves.bounceInOut);
                }
              },
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
                  BlocBuilder<AddBillCubit, AddBillState>(
                      bloc: GetIt.I(),
                      buildWhen: (previous, current) =>
                          previous.responseStatus != current.responseStatus,
                      builder: (context, state) {
                        bool isLoading =
                            state.responseStatus == ResponseStatus.loading;
                        return PrimaryButton(
                          text: 'Continuar',
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? () {}
                              : () async {
                                  if (_currentValidator == null) return;

                                  final ok = await _currentValidator!();

                                  if (!ok) return;

                                  if (_currentIndex == _listPageWidgets.length - 1) {
                                    //se for a ultima página, salva a conta
                                    await GetIt.I<AddBillCubit>()
                                        .addNewBill(_currentMonth.id!);
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
          ),
        ));
  }

  void _showError(String msg) {
    showFlushbar(context, msg, true);
  }

  void _registerValidator(Future<bool> Function() fn) {
    _currentValidator = fn;
  }
}
