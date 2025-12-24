import 'package:Fluxx/blocs/user_cubit/user_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  void updateGetUserResponse(GetUserResponse getUserResponse) {
    emit(state.copyWith(getUserResponse: getUserResponse));
  }

  Future<void> getUserInfos() async {
    updateGetUserResponse(GetUserResponse.loading);
    try {
      final List<Map<String, dynamic>> userData = await Db.getUser();

      UserModel? userModel;
      if (userData.isNotEmpty) {
        userModel = UserModel.fromJson(userData.first);
      }

      emit(state.copyWith(user: userModel));
      updateGetUserResponse(GetUserResponse.success);
    } catch (e) {
      updateErrorMessage(e.toString());
      updateGetUserResponse(GetUserResponse.error);
    }
  }

  void udpateVersionApp(String version) {
    emit(state.copyWith(versionApp: version));
  }

  Future<int> saveEdits() async {
    try {
      var result = await Db.updateUser(state.user!);
      updateSuccessMessage('Dados Salvos com sucesso');
      return result;
    } catch (e) {
      debugPrint(e.toString());
      updateErrorMessage(e.toString());
      return 0;
    }
  }

  void editName(String name) {
    if (state.user != null) {
      var userInfos = UserModel(
        name: name,
        salary: state.user!.salary,
        picture: state.user!.picture,
      );
      emit(state.copyWith(user: userInfos));
    }
  }

  void editSalary(double salary) {
    if (state.user != null) {
      var userInfos = UserModel(
        name: state.user!.name,
        salary: salary,
        picture: state.user!.picture,
      );
      emit(state.copyWith(user: userInfos));
    }
  }

  void editPicture(String picture) {
    if (state.user != null) {
      var userInfos = UserModel(
        name: state.user!.name,
        salary: state.user!.salary,
        picture: picture,
      );
      emit(state.copyWith(user: userInfos));
    }
  }

  Future<void> updateErrorMessage(String errorMessage) async {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  Future<void> updateSuccessMessage(String successMessage) async {
    emit(state.copyWith(successMessage: successMessage));
  }
}
