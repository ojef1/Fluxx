part of 'update_cubit.dart';

enum UpdateStatus {
  initial, // ainda não checou a Play Store
  none, // app atualizado, ou checagem falhou (sem internet, build fora da Play...)
  available, // há versão nova para baixar
  downloading,
  downloaded, // baixada, falta o usuário confirmar o reinício
}

class UpdateState extends Equatable {
  final UpdateStatus status;

  const UpdateState({this.status = UpdateStatus.initial});

  UpdateState copyWith({UpdateStatus? status}) {
    return UpdateState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
