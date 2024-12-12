import 'package:Fluxx/blocs/user_bloc/user_state.dart';
import 'package:Fluxx/data/database.dart';
import 'package:Fluxx/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  Future<void> getUserInfos() async {
    try {
      final List<Map<String, dynamic>> userData = await Db.getUser();

      UserModel? userModel;
      if (userData.isNotEmpty) {
        userModel = UserModel.fromJson(userData.first);
      }

      emit(state.copyWith(user: userModel));
    } catch (e) {
      print('Erro ao buscar informações do usuário: $e');
    }
  }

  Future<int> saveEdits() async {
    var result = await Db.updateUser(state.user!);
    return result;
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
}
