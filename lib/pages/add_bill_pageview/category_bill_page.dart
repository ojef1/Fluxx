part of 'add_bill_pageview.dart';

class CategoryBillPage extends StatefulWidget {
  final void Function(Future<bool> Function()) registerValidator;
  final void Function(String) onError;
  const CategoryBillPage(
      {super.key, required this.registerValidator, required this.onError});
  @override
  State<CategoryBillPage> createState() => _CategoryBillPageState();
}

class _CategoryBillPageState extends State<CategoryBillPage> {
  @override
  void initState() {
    GetIt.I<CategoryCubit>().getCategorys();
    widget.registerValidator(_validate);
    super.initState();
  }

  Future<bool> _validate() async {
    bool hasCategorySelected =
        GetIt.I<AddBillCubit>().state.categorySelected != null;
    if (hasCategorySelected) {
      return true;
    } else {
      widget.onError('É obrigatório a seleção de uma categoria');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Em qual categoria essa conta se\n enquadra?',
          style: AppTheme.textStyles.subTileTextStyle,
          softWrap: true,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: mediaQuery.height * .05),
        BlocBuilder<CategoryCubit, CategoryState>(
          bloc: GetIt.I(),
          buildWhen: (previous, current) =>
              previous.categories != current.categories ||
              previous.selectedCategory != current.selectedCategory,
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
              return BlocBuilder<AddBillCubit, AddBillState>(
                  bloc: GetIt.I(),
                  buildWhen: (previous, current) =>
                      previous.categorySelected != current.categorySelected,
                  builder: (context,addState) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              state.categories[index] == addState.categorySelected;
                          return Column(
                            children: [
                              PrimaryButton(
                                  color: isSelected
                                      ? AppTheme.colors.hintColor
                                      : AppTheme.colors.itemBackgroundColor,
                                  textStyle: AppTheme.textStyles.bodyTextStyle,
                                  width: mediaQuery.width * .85,
                                  text: state.categories[index].categoryName ??
                                      '',
                                  onPressed: () {
                                    String categoryName =
                                        state.categories[index].categoryName ??
                                            '';
                                    String categoryId =
                                        state.categories[index].id ?? '';
                                    var category = CategoryModel(
                                        id: categoryId,
                                        categoryName: categoryName);
                                    GetIt.I<AddBillCubit>()
                                        .updateCategory(category);
                                  }),
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
                                    (value) =>
                                        GetIt.I<CategoryCubit>().getCategorys(),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  });
            }
          },
        ),
      ],
    );
  }
}
