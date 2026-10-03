import 'package:Fluxx/models/user_model.dart';
import 'package:equatable/equatable.dart';

enum GetUserResponse { initial, loading, success, error }

class UserState extends Equatable {
  final GetUserResponse getUserResponse;
  final UserModel? user;
  final String successMessage;
  final String errorMessage;

  const UserState({
    this.user,
    this.getUserResponse = GetUserResponse.initial,
    this.successMessage = '',
    this.errorMessage = '',
  });

  UserState copyWith({
    UserModel? user,
    GetUserResponse? getUserResponse,
    String? successMessage,
    String? errorMessage,
  }) {
    return UserState(
      user: user ?? this.user,
      getUserResponse: getUserResponse ?? this.getUserResponse,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        user,
        getUserResponse,
        successMessage,
        errorMessage,
      ];
}
