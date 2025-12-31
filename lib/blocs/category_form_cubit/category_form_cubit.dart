import 'dart:developer';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_form_state.dart';

class CategoryFormCubit extends Cubit<CategoryFormState> {
  CategoryFormCubit() : super(const CategoryFormState());

  //variável necessária para pegar os dados que não são alterados na edição
  //como Id, recurrence e etc.
  CategoryModel? _loadedCategoryToEdit;

  bool canDesactive(int currentMonthId) {
    return _loadedCategoryToEdit?.isMonthly == 1 &&
      _loadedCategoryToEdit?.endMonthId != currentMonthId &&
      state.categoryFormMode == CategoryFormMode.editing;
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateRecurrenceMode(RecurrenceMode recurrenceMode) {
    emit(state.copyWith(recurrenceMode: recurrenceMode));
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
    _loadedCategoryToEdit = category;
    emit(state.copyWith(
      id: category.id,
      name: category.categoryName,
      
          
    ));
  }

  Future<void> submitCategory(int currentMonthId) async {
    switch (state.categoryFormMode) {
      case CategoryFormMode.adding:
        await _addNewCategory(currentMonthId);
      case CategoryFormMode.editing:
        await _editCategory();
    }
  }

  Future<void> _addNewCategory(int currentMonthId) async {
    updateResponseStatus(ResponseStatus.loading);
    bool isMonthly = state.recurrenceMode == RecurrenceMode.monthly;
    try {
      CategoryModel newCategory = CategoryModel(
        id: codeGenerate(),
        categoryName: state.name,
        startMonthId: currentMonthId,
        endMonthId: isMonthly ? null : currentMonthId,
        isMonthly: isMonthly ? 1 : 0, // 1 para true e 0 para false
      );
      log('inserindo categoria: ${newCategory.toJson()}');
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
        startMonthId: _loadedCategoryToEdit?.startMonthId,
        endMonthId: _loadedCategoryToEdit?.endMonthId,
        isMonthly:
            _loadedCategoryToEdit?.isMonthly ?? 0, // 1 para true e 0 para false
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

  Future<void> disableCategory(int currentMonthId) async {
    updateResponseStatus(ResponseStatus.loading);
    try {
      var result = await Db.disableCategory(state.id, currentMonthId);
      if (result > 0) {
        await updateResponseMessage('Receita desativada com sucesso.');
        updateResponseStatus(ResponseStatus.success);
        return;
      } else {
        await updateResponseMessage('Falha ao desativar a receita.');
        updateResponseStatus(ResponseStatus.error);
        return;
      }
    } catch (error) {
      log('$error', name: 'CategoryFormCubit.desactiveCategory');
      updateResponseStatus(ResponseStatus.error);
    }
  }

  resetState() {
    emit(const CategoryFormState());
  }
}
