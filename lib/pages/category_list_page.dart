import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/blocs/category_form_cubit/category_form_cubit.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/components/secondary_button.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_category_list.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var actualMonth = await GetIt.I<ResumeCubit>().getActualMonth();
    GetIt.I<CategoryCubit>().getCategorys(actualMonth.id!);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<CategoryFormCubit, CategoryFormState>(
      listenWhen: (previous, current) =>
          previous.responseStatus != current.responseStatus,
      bloc: GetIt.I(),
      listener: (context, state) {
        if (state.responseStatus == ResponseStatus.success) {
          init();
        }
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppTheme.colors.appBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: const CustomAppBar(title: 'Lista de Categoria'),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * .05,
              ),
              child: Column(
                children: [
                  const SizedBox(height: Constants.topMargin),
                  SecondaryButton(
                    title: 'Adicionar',
                    icon: Icons.add_rounded,
                    onPressed: () => goToCategoryForm(context: context),
                  ),
                  const SizedBox(height: Constants.topMargin),
                  BlocBuilder<CategoryCubit, CategoryState>(
                    bloc: GetIt.I(),
                    buildWhen: (previous, current) =>
                        previous.categories != current.categories,
                    builder: (context, state) {
                      if (state.categories.isEmpty) {
                        return EmptyCategoryList(
                          onPressed: () => goToCategoryForm(context: context),
                          title: 'Parece que você não possui categorias',
                          subTitle: 'Clique aqui para criar',
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.itemBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  title: Text(
                                      state.categories[index].categoryName ??
                                          '',
                                      style: AppTheme.textStyles.bodyTextStyle),
                                  subtitle: Text(
                                    state.categories[index].isMonthly == 1
                                        ? 'categoria mensal'
                                        : 'categoria única',
                                    style:
                                        AppTheme.textStyles.secondaryTextStyle,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: AppTheme.colors.hintColor,
                                  ),
                                  onTap: () => goToCategoryForm(
                                      context: context,
                                      category: state.categories[index]),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
