
import 'package:Fluxx/blocs/credit_card_form_cubit/credit_card_form_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/bank_model.dart';
import 'package:Fluxx/models/card_network_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get_it/get_it.dart';

part 'name_credit_card_page.dart';
part 'limit_credit_card_page.dart';
part 'closing_credit_card_page.dart';
part 'due_credit_card_page.dart';
part 'bank_credit_card_page.dart';
part 'network_credit_card_page.dart';
part 'check_credit_card_page.dart';
part 'last_digits_credit_card_page.dart';

class CreditCardFormPageview extends StatefulWidget {
  const CreditCardFormPageview({super.key});

  @override
  State<CreditCardFormPageview> createState() => _CreditCardFormPageviewState();
}

class _CreditCardFormPageviewState extends State<CreditCardFormPageview> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Future<bool> Function()? _currentValidator;
  late final CreditCardFormMode creditCardFormMode;
  late final bool shouldShowRepeatPage;
  late final bool isDecember;

  @override
  void initState() {
    _pageController = PageController();
    creditCardFormMode = GetIt.I<CreditCardFormCubit>().state.creditCardFormMode;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    GetIt.I<CreditCardFormCubit>().resetState();
    super.dispose();
  }

  List<Widget> get _listPageWidgets {
    List<Widget> pages = [
      NameCreditCardPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      LimitCreditCardPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      BankCreditCardPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      NetworkCreditCardPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      LastDigitsCreditCardPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      ClosingCreditCardPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      DueCreditCardPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
       CheckCreditCardPage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
    ];
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<CreditCardFormCubit, CreditCardFormState>(
        bloc: GetIt.I(),
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            showFlushbar(context, state.responseMessage, false);
            Navigator.pop(context);
          }else if (state.responseStatus == ResponseStatus.error){
            showFlushbar(context, state.responseMessage, true);
          }
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: BlocBuilder<CreditCardFormCubit, CreditCardFormState>(
              bloc: GetIt.I(),
              buildWhen: (previous, current) =>
                  previous.creditCardFormMode != current.creditCardFormMode,
              builder: (context, state) {
                bool isEditing = state.creditCardFormMode == CreditCardFormMode.editing;
                return Scaffold(
                  backgroundColor: AppTheme.colors.appBackgroundColor,
                  resizeToAvoidBottomInset: true,
                  appBar: CustomAppBar(
                    title: isEditing ? 'Editar Cartão' : 'Adicionar Cartão',
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
                        BlocBuilder<CreditCardFormCubit, CreditCardFormState>(
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
                                          await GetIt.I<CreditCardFormCubit>()
                                              .submitCard();
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
