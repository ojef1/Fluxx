import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  Future<void> getCategorys() async {
    updateGetCategorysResponse(GetCategoriesResponse.loading);
    try {
      final result = await Db.getCategories();
      final categorys = result
          .map((item) => CategoryModel(
                id: item['id'],
                categoryName: item['name'],
              ))
          .toList();
      emit(state.copyWith(categories: categorys));
      updateGetCategorysResponse(GetCategoriesResponse.success);
    } catch (e) {
      updateErrorMessage(e.toString());
      updateGetCategorysResponse(GetCategoriesResponse.error);
    }
  }

  void updateAddCategorysResponse(AddCategoriesResponse addCategorysResponse) {
    emit(state.copyWith(addCategoriesResponse: addCategorysResponse));
  }

  void updateEditCategorysResponse(
      EditCategoriesResponse editCategorysResponse) {
    emit(state.copyWith(editCategoriesResponse: editCategorysResponse));
  }

  void updateRemoveCategorysResponse(
      RemoveCategoriesResponse removeCategorysResponse) {
    emit(state.copyWith(removeCategoriesResponse: removeCategorysResponse));
  }

  void updateGetCategorysResponse(GetCategoriesResponse getCategorysResponse) {
    emit(state.copyWith(getCategoriesResponse: getCategorysResponse));
  }

  void updateGetTotalByCategoryResponse(
      GetTotalResponse getTotalByCategoryResponse) {
    emit(
        state.copyWith(getTotalByCategoryResponse: getTotalByCategoryResponse));
  }

  void updateSelectedCategory(CategoryModel category) {
    emit(state.copyWith(selectedCategory: category));
  }

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }

  Future<void> getTotalByCategory(int monthId) async {
    updateGetTotalByCategoryResponse(GetTotalResponse.loading);
    try {
      final totalSpent = await Db.getTotalByCategory(monthId);
      List<CategoryModel> total = totalSpent.map((item) {
        return CategoryModel(
          categoryName: item['category_name'],
          price: item['total'],
        );
      }).toList();
      emit(state.copyWith(totalByCategory: total));
      updateGetTotalByCategoryResponse(GetTotalResponse.success);
    } catch (error) {
      debugPrint('$error');
      updateGetTotalByCategoryResponse(GetTotalResponse.error);
    }
  }

  Future<int> addCategory(CategoryModel category) async {
    updateAddCategorysResponse(AddCategoriesResponse.loading);
    try {
      var result = await Db.insertCategory(category);
      if (result != -1) {
        await updateSuccessMessage('Categoria adicionada com sucesso.');
        updateAddCategorysResponse(AddCategoriesResponse.success);
        return result;
      } else {
        await updateErrorMessage('Falha ao adicionar a categoria.');
        updateAddCategorysResponse(AddCategoriesResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateAddCategorysResponse(AddCategoriesResponse.error);
      return -1;
    }
  }

  Future<int> editCategory(CategoryModel category) async {
    updateEditCategorysResponse(EditCategoriesResponse.loading);
    try {
      var result = await Db.updateCategory(category);
      if (result > 0) {
        await updateSuccessMessage('Categoria editada com sucesso.');
        updateEditCategorysResponse(EditCategoriesResponse.success);
        return result;
      } else {
        await updateErrorMessage('Falha ao editar a categoria.');
        updateEditCategorysResponse(EditCategoriesResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      updateEditCategorysResponse(EditCategoriesResponse.error);
      return 0;
    }
  }

  Future<int> removeCategory(String categoryId) async {
    updateRemoveCategorysResponse(RemoveCategoriesResponse.loading);
    try {
      var result = await Db.deleteCategory(categoryId);
      if (result > 0) {
        await updateSuccessMessage('Categoria removida com sucesso.');
        updateRemoveCategorysResponse(RemoveCategoriesResponse.success);
        return result;
      } else {
        await updateErrorMessage('Falha ao remover a categoria.');
        updateRemoveCategorysResponse(RemoveCategoriesResponse.error);
        return result;
      }
    } catch (error) {
      debugPrint('$error');
      if (error.toString().contains('FOREIGN KEY constraint failed')) {
        await updateErrorMessage(
            'Não é possível excluir esta categoria porque existem contas vinculadas a ela.');
      }
      updateRemoveCategorysResponse(RemoveCategoriesResponse.error);
      return 0;
    }
  }

  void resetState() {
    emit(const CategoryState());
  }
}
