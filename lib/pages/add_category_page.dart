// import 'package:Fluxx/blocs/bill_cubit/bill_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({
    super.key,
  });

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late TextEditingController nameController;
  late final CategoryModel? categoryModel;
  bool isEditing = false;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    categoryModel =
        ModalRoute.of(context)!.settings.arguments as CategoryModel?;
    _hasData(categoryModel);
  }

  @override
  void dispose() {
    nameController.dispose();
    // GetIt.I<BillCubit>().resetState();
    super.dispose();
  }

  void _hasData(CategoryModel? categoryModel) {
    if (categoryModel != null) {
      setState(() {
        nameController.text = categoryModel.categoryName ?? '';
        isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title: isEditing ? 'Editar Categoria' : 'Adicionar Categoria',
          // backButton: () => isEditing
          //     ? Navigator.pop(context)
          //     : Navigator.pushReplacementNamed(
          //         context,
          //         AppRoutes.home,
          //       ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: Constants.topMargin),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewInsets.top),
                  child: Container(
                    width: mediaQuery.width,
                    height: mediaQuery.height * .8,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextField(
                          hint: 'Nome da Categoria',
                          controller: nameController,
                          icon: Icons.text_fields_sharp,
                        ),
                        Column(
                          children: [
                            if (isEditing)
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(3),
                                width: mediaQuery.width * .85,
                                child: ElevatedButton(
                                  onPressed: () => _showDeleteDialog(
                                      context, categoryModel!.id!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    minimumSize: const Size(50, 50),
                                  ),
                                  child: Text('Excluir',
                                      style: AppTheme.textStyles.bodyTextStyle),
                                ),
                              ),
                            BlocBuilder<CategoryCubit, CategoryState>(
                              bloc: GetIt.I(),
                              buildWhen: (previous, current) =>
                                  previous.addCategoriesResponse !=
                                      current.addCategoriesResponse ||
                                  previous.editCategoriesResponse !=
                                      current.editCategoriesResponse,
                              builder: (context, state) {
                                bool isLoading = state.addCategoriesResponse ==
                                        AddCategoriesResponse.loading ||
                                    state.editCategoriesResponse ==
                                        EditCategoriesResponse.loading;
                                return PrimaryButton(
                                  text: isEditing ? 'Editar' : 'Adicionar',
                                  onPressed: () => isLoading
                                      ? null
                                      : _verifyData(
                                          categoryId: categoryModel?.id),
                                  width: mediaQuery.width * .85,
                                  color: AppTheme.colors.itemBackgroundColor,
                                  textStyle: AppTheme.textStyles.bodyTextStyle,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppTheme.colors.appBackgroundColor,
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            maxLines: 4,
            textAlign: TextAlign.center,
            'Tem certeza de que deseja excluir este item?',
            style: AppTheme.textStyles.tileTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: AppTheme.textStyles.secondaryTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCategory(categoryId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Excluir',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  void _verifyData({String? categoryId}) {
    if (nameController.text.isEmpty) {
      showFlushbar(context, 'preencha o campo do nome', true);
      return;
    }
    if (isEditing) {
      _editCategory(categoryId!);
    } else {
      _addCategory();
    }
  }

  Future<void> _addCategory() async {
    var category = CategoryModel(
      id: codeGenerate(),
      categoryName: nameController.text,
    );
    var result = await GetIt.I<CategoryCubit>().addCategory(category);
    var state = GetIt.I<CategoryCubit>().state;
    if (result != -1) {
      showFlushbar(context, state.successMessage, false);
      _clearInput();

      Navigator.pop(context);
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }

  Future<void> _editCategory(
    String categoryId,
  ) async {
    var newCategory = CategoryModel(
      id: categoryId,
      categoryName: nameController.text,
    );
    var result = await GetIt.I<CategoryCubit>().editCategory(newCategory);
    var state = GetIt.I<CategoryCubit>().state;
    if (result != -1) {
      showFlushbar(context, state.successMessage, false);

      await GetIt.I<CategoryCubit>().getCategorys();
      Navigator.pop(context);
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }

  Future<void> _deleteCategory(String categoryId) async {
    var result = await GetIt.I<CategoryCubit>().removeCategory(categoryId);
    var state = GetIt.I<CategoryCubit>().state;
    if (result > 0) {
      await showFlushbar(context, state.successMessage, false);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }

  void _clearInput() {
    setState(() {
      nameController.clear();
    });
  }
}
