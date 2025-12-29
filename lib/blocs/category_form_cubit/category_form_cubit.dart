import 'dart:developer';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_form_state.dart';

class CategoryFormCubit extends Cubit<CategoryFormState> {
  CategoryFormCubit() : super(const CategoryFormState());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateResponseStatus(ResponseStatus responseStatus) {
    emit(state.copyWith(responseStatus: responseStatus));
  }

  Future<void> updateResponseMessage(String responseMessage) async {
    emit(state.copyWith(responseMessage: responseMessage));
  }

  void updateCategoryFormMode(CategoryFormMode categoryFormMode) {
    emit(state.copyWith(categoryFormMode: categoryFormMode));
  }

  void loadCategoryToEdit(CategoryModel category) {
    emit(state.copyWith(
      id: category.id,
      name: category.categoryName,
    ));
  }

  Future<void> submitCategory(int currentMonthId) async {
    switch (state.categoryFormMode) {
      case CategoryFormMode.adding:
        await _addNewCategory();
      case CategoryFormMode.editing:
        await _editCategory();
    }
  }

  Future<void> _addNewCategory() async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      CategoryModel newCategory = CategoryModel(
        id: codeGenerate(),
        categoryName: state.name,
      );
      await Db.insertCategory(newCategory);
      await updateResponseMessage('Categoria adicionada com sucesso!');
      updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      log(e.toString());
      await updateResponseMessage(
          'Erro ao adicionar categoria: ${e.toString()}');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  Future<void> _editCategory() async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      CategoryModel editedCategory = CategoryModel(
        id: state.id,
        categoryName: state.name,
      );
      await Db.updateCategory(editedCategory);
      await updateResponseMessage('Categoria editada com sucesso!');
      updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      log(e.toString());
      await updateResponseMessage('Erro ao editar categoria: ${e.toString()}');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      await Db.deleteCategory(categoryId);
      await updateResponseMessage('Categoria excluída com sucesso!');
      updateResponseStatus(ResponseStatus.success);
    } catch (e) {
      log(e.toString());
      if (e.toString().contains('FOREIGN KEY constraint failed')) {
        await updateResponseMessage(
            'Não é possível excluir esta categoria porque existem contas vinculadas a ela.');
      } else {
        await updateResponseMessage(
            'Erro ao excluir categoria: ${e.toString()}');
      }
      updateResponseStatus(ResponseStatus.error);
    }
  }

  resetState() {
    emit(const CategoryFormState());
  }
}
