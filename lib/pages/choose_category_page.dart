import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_category_list.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChooseCategoryPage extends StatefulWidget {
  const ChooseCategoryPage({super.key});

  @override
  State<ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  @override
  void initState() {
    GetIt.I<CategoryCubit>().getCategorys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: const CustomAppBar(title: 'Escolher Categoria'),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width * .05,
            ),
            child: Column(
              children: [
                const SizedBox(height: Constants.topMargin),
                BlocBuilder<CategoryCubit, CategoryState>(
                  bloc: GetIt.I(),
                  buildWhen: (previous, current) =>
                      previous.categories != current.categories,
                  builder: (context, state) {
                    if (state.categories.isEmpty) {
                      return EmptyCategoryList(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.addCategoryPage,
                        ).then(
                          (value) => GetIt.I<CategoryCubit>().getCategorys(),
                        ),
                        title: 'Parece que você não possui categorias',
                        subTitle: 'Clique aqui para criar',
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                PrimaryButton(
                                  color: AppTheme.colors.itemBackgroundColor,
                                  textStyle: AppTheme.textStyles.bodyTextStyle,
                                  width: mediaQuery.width * .85,
                                  text: state.categories[index].categoryName ??
                                      '',
                                  onPressed: () => _showConfirmationDialog(
                                    context,
                                    state.categories[index].categoryName ?? '',
                                    state.categories[index].id ?? '',
                                  ),
                                ),
                                if (state.categories.length - 1 == index)
                                  const SizedBox(height: 24),
                                if (state.categories.length - 1 == index)
                                  PrimaryButton(
                                    color: AppTheme.colors.itemBackgroundColor,
                                    textStyle: AppTheme.textStyles.bodyTextStyle
                                        .copyWith(
                                            color: AppTheme.colors.hintColor),
                                    width: mediaQuery.width * .85,
                                    text: 'Adicionar mais categorias',
                                    onPressed: () => Navigator.pushNamed(
                                            context, AppRoutes.addCategoryPage)
                                        .then(
                                      (value) => GetIt.I<CategoryCubit>()
                                          .getCategorys(),
                                    ),
                                  ),
                              ],
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
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String categoryName, String categoryId) {
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
            'Escolher $categoryName?',
            style:
                AppTheme.textStyles.tileTextStyle.copyWith(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Não',
                style: AppTheme.textStyles.itemTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); //fecha dialog
                var category =
                    CategoryModel(id: categoryId, categoryName: categoryName);
                GetIt.I<CategoryCubit>().updateSelectedCategory(category);
                Navigator.of(context).pop(); //volta para a página de add conta
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.hintColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Sim',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
