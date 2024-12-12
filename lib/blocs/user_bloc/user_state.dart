import 'package:Fluxx/models/user_model.dart';
import 'package:equatable/equatable.dart';

enum GetUserResponse { initial, loaging, success, error }

class UserState extends Equatable {
  final GetUserResponse getUserResponse;
  final UserModel? user;

  const UserState({
    this.user,
    this.getUserResponse = GetUserResponse.initial,
  });

  UserState copyWith({
    UserModel? user,
    GetUserResponse? getUserResponse,
  }) {
    return UserState(
      user: user ?? this.user,
      getUserResponse: getUserResponse ?? this.getUserResponse,
    );
  }

  @override
  List<Object?> get props => [
        user,
        getUserResponse,
      ];
}
