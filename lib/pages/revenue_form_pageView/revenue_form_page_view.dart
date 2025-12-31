import 'package:Fluxx/blocs/bill_form_cubit/bill_form_cubit.dart' as bill_cubit;
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_form_cubit/revenue_form_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/bottom_sheets/revenue_desactive_warning_bottomsheet.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get_it/get_it.dart';

part 'name_revenue_page.dart';
part 'price_revenue_page.dart';
part 'recurrence_revenue_page.dart';

class RevenueFormPageview extends StatefulWidget {
  const RevenueFormPageview({super.key});

  @override
  State<RevenueFormPageview> createState() => _RevenueFormPageviewState();
}

class _RevenueFormPageviewState extends State<RevenueFormPageview> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Future<bool> Function()? _currentValidator;
  late final MonthModel _currentMonth;
  late final RevenueFormMode revenueFormMode;
  late final bool isEditingMode;
  //variavel de contexto existente apenas no modo edição
  //é referente a receita que está sendo editada
  late final bool canDesactive;

  @override
  void initState() {
    _pageController = PageController();
    //Nos casos em que esse formulário é chamado por meio da criação de conta
    //deve-se usar a data do mês selecionado no formulário de conta
    //se for null é porque veio de outro fluxo, então pega o mês em foco do resumo
    _currentMonth = GetIt.I<bill_cubit.BillFormCubit>().state.selectedMonth ??
        GetIt.I<ResumeCubit>().state.monthInFocus!;
    revenueFormMode = GetIt.I<RevenueFormCubit>().state.revenueFormMode;
    isEditingMode = revenueFormMode == RevenueFormMode.editing;
    canDesactive = GetIt.I<RevenueFormCubit>().canDesactive;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    GetIt.I<RevenueFormCubit>().resetState();
    super.dispose();
  }

  List<Widget> get _listPageWidgets {
    List<Widget> pages = [
      NameRevenuePage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
      PriceRevenuePage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
    ];

    //Não é possível alterar se a receita é mensal ou única na edição
    if (!isEditingMode) {
      pages.add(
        RecurrenceRevenuePage(
          registerValidator: _registerValidator,
          onError: (p0) => _showError(p0),
          currentMonth: _currentMonth,
        ),
      );
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<RevenueFormCubit, RevenueFormState>(
        bloc: GetIt.I(),
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            showFlushbar(context, state.responseMessage, false);
            Navigator.pop(context);
          }
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: BlocBuilder<RevenueFormCubit, RevenueFormState>(
              bloc: GetIt.I(),
              buildWhen: (previous, current) =>
                  previous.revenueFormMode != current.revenueFormMode,
              builder: (context, state) {
                bool isEditing =
                    state.revenueFormMode == RevenueFormMode.editing;
                return Scaffold(
                  backgroundColor: AppTheme.colors.appBackgroundColor,
                  resizeToAvoidBottomInset: true,
                  appBar: CustomAppBar(
                    title: isEditing ? 'Editar Receita' : 'Adicionar Receita',
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
                        if (canDesactive)
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(3),
                            width: mediaQuery.width * .85,
                            child: ElevatedButton(
                              onPressed: () => _showRevenueWarning(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                minimumSize: const Size(50, 50),
                              ),
                              child: Text('Desativar',
                                  style: AppTheme.textStyles.bodyTextStyle),
                            ),
                          ),
                        BlocBuilder<RevenueFormCubit, RevenueFormState>(
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
                                          await GetIt.I<RevenueFormCubit>()
                                              .submitRevenue(_currentMonth.id!);
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

  void _showRevenueWarning() {
    showModalBottomSheet(
        context: context,
        builder: (context) => const RevenueDesactiveWarningBottomsheet());
  }
}
