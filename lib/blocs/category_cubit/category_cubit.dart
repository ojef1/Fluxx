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

  void resetState() {
    emit(const CategoryState());
  }
}
