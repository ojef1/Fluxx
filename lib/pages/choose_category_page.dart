import 'package:Fluxx/blocs/category_bloc/category_cubit.dart';
import 'package:Fluxx/blocs/category_bloc/category_state.dart';
import 'package:Fluxx/components/animated_check_button.dart';
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width * .05,
            ),
            child: Column(
              children: [
                //AppBar
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: Constants.topMargin),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.colors.grayD4,
                        child: IconButton(
                            color: Colors.black,
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_rounded)),
                      ),
                      SizedBox(width: mediaQuery.width * .1),
                      Text(
                        'Escolher Categoria',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                    ],
                  ),
                ),

                BlocBuilder<CategoryCubit, CategoryState>(
                  bloc: GetIt.I(),
                  buildWhen: (previous, current) =>
                      previous.categories != current.categories,
                  builder: (context, state) {
                    if (state.categories.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                'Você ainda não possui Categorias Cadastradas!',
                                style: AppTheme.textStyles.subTileTextStyle,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.addCategoryPage);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.colors.accentColor,
                                  minimumSize: const Size(50, 50),
                                ),
                                child: Text('Adicionar Nova Categoria',
                                    style: AppTheme.textStyles.bodyTextStyle),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            return PrimaryButton(
                              width: mediaQuery.width * .85,
                              text: state.categories[index].categoryName ?? '',
                              onPressed: () => _showConfirmationDialog(
                                context,
                                state.categories[index].categoryName ?? '',
                                state.categories[index].id ?? '',
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
            style: AppTheme.textStyles.tileTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Não',
                style: AppTheme.textStyles.accentTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();//fecha dialog
                var category = CategoryModel(id: categoryId, categoryName: categoryName); 
                GetIt.I<CategoryCubit>().updateSelectedCategory(category);
                Navigator.of(context).pop();//volta para a página de add conta

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.accentColor,
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
