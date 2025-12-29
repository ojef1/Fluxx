import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_category_list.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
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
        appBar: const CustomAppBar(title: 'Lista de Categoria'),
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
                          AppRoutes.categoryFormPage,
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
                                    state.categories[index].categoryName ?? '',
                                    style: AppTheme.textStyles.bodyTextStyle),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: AppTheme.colors.hintColor,
                                ),
                                onTap: () => goToCategoryForm(context: context,category: state.categories[index]),
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
}
