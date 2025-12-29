
import 'package:Fluxx/blocs/category_form_cubit/category_form_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/bottom_sheets/category_delete_warning_bottomsheet.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'name_category_page.dart';

class CategoryFormPageview extends StatefulWidget {
  const CategoryFormPageview({super.key});

  @override
  State<CategoryFormPageview> createState() => _CategoryFormPageviewState();
}

class _CategoryFormPageviewState extends State<CategoryFormPageview> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Future<bool> Function()? _currentValidator;
  late final MonthModel _currentMonth;
  late final CategoryFormMode categoryFormMode;
  late final bool isEditingMode;

  @override
  void initState() {
    _pageController = PageController();
    _currentMonth = GetIt.I<ResumeCubit>().state.monthInFocus!;
    categoryFormMode = GetIt.I<CategoryFormCubit>().state.categoryFormMode;
    isEditingMode = categoryFormMode == CategoryFormMode.editing;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    GetIt.I<CategoryFormCubit>().resetState();
    super.dispose();
  }

  List<Widget> get _listPageWidgets {
    List<Widget> pages = [
      NameRevenuePage(
        registerValidator: _registerValidator,
        onError: (p0) => _showError(p0),
      ),
    ];
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<CategoryFormCubit, CategoryFormState>(
        bloc: GetIt.I(),
        listener: (context, state) {
          if (state.responseStatus == ResponseStatus.success) {
            showFlushbar(context, state.responseMessage, false);
            Navigator.pop(context);
          } else if (state.responseStatus == ResponseStatus.error) {
            showFlushbar(context, state.responseMessage, true);
          }
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: BlocBuilder<CategoryFormCubit, CategoryFormState>(
              bloc: GetIt.I(),
              buildWhen: (previous, current) =>
                  previous.categoryFormMode != current.categoryFormMode,
              builder: (context, state) {
                bool isEditing =
                    state.categoryFormMode == CategoryFormMode.editing;
                return Scaffold(
                  backgroundColor: AppTheme.colors.appBackgroundColor,
                  resizeToAvoidBottomInset: true,
                  appBar: CustomAppBar(
                    title: isEditing ? 'Editar Categoria' : 'Adicionar Categoria',
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
                        if (isEditingMode)
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(3),
                            width: mediaQuery.width * .85,
                            child: ElevatedButton(
                              onPressed: () => _showCategoryWarning(state.id),
                              
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                minimumSize: const Size(50, 50),
                              ),
                              child: Text('Excluir',
                                  style: AppTheme.textStyles.bodyTextStyle),
                            ),
                          ),
                        BlocBuilder<CategoryFormCubit, CategoryFormState>(
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
                                          await GetIt.I<CategoryFormCubit>()
                                              .submitCategory(_currentMonth.id!);
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

  void _showCategoryWarning(String categoryId) {
    showModalBottomSheet(
        context: context,
        builder: (context) => CategoryDeleteWarningBottomsheet(categoryId: categoryId,));
  }
}
