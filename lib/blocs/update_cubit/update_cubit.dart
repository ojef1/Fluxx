import 'dart:async';
import 'dart:developer';

import 'package:Fluxx/services/app_update_service.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit() : super(const UpdateState());

  final AppUpdateService _service = AppUpdateService();
  StreamSubscription<InstallStatus>? _installSubscription;

  //o popup é mostrado no máximo uma vez por abertura do app
  bool _popupHandled = false;

  /// Checa a Play Store. Qualquer falha é silenciosa: o usuário não vê nada.
  Future<void> checkForUpdate() async {
    try {
      final availability = await _service.checkForUpdate();
      switch (availability) {
        case AppUpdateAvailability.none:
          emit(state.copyWith(status: UpdateStatus.none));
        case AppUpdateAvailability.available:
          emit(state.copyWith(status: UpdateStatus.available));
        case AppUpdateAvailability.downloaded:
          emit(state.copyWith(status: UpdateStatus.downloaded));
      }
    } catch (e) {
      log('$e', name: 'checkForUpdate');
      emit(state.copyWith(status: UpdateStatus.none));
    }
  }

  /// O popup só aparece se há versão nova, ainda não foi tratado nesta abertura
  /// e o usuário não o dispensou nos últimos [Constants.updateReminderDays] dias.
  Future<bool> shouldShowPopup() async {
    if (_popupHandled || state.status != UpdateStatus.available) return false;
    try {
      final dismissedAt = await _service.getDismissedAt();
      if (dismissedAt == null) return true;
      final daysSinceDismissed = DateTime.now().difference(dismissedAt).inDays;
      return daysSinceDismissed >= Constants.updateReminderDays;
    } catch (e) {
      log('$e', name: 'shouldShowPopup');
      return false;
    }
  }

  /// "Agora não": o botão do drawer continua disponível.
  Future<void> dismissPopup() async {
    _popupHandled = true;
    try {
      await _service.saveDismissedAt(DateTime.now());
    } catch (e) {
      log('$e', name: 'dismissPopup');
    }
  }

  Future<void> startUpdate() async {
    if (state.status != UpdateStatus.available) return;
    emit(state.copyWith(status: UpdateStatus.downloading));

    try {
      _listenInstallStatus();
      final result = await _service.startFlexibleUpdate();
      //o usuário negou na confirmação da Play ou ela falhou, o download não começou
      if (result != AppUpdateResult.success) {
        emit(state.copyWith(status: UpdateStatus.available));
      }
    } catch (e) {
      log('$e', name: 'startUpdate');
      emit(state.copyWith(status: UpdateStatus.available));
    }
  }

  void _listenInstallStatus() {
    _installSubscription?.cancel();
    _installSubscription = _service.installStatusStream.listen((status) {
      switch (status) {
        case InstallStatus.downloaded:
          emit(state.copyWith(status: UpdateStatus.downloaded));
        case InstallStatus.failed || InstallStatus.canceled:
          emit(state.copyWith(status: UpdateStatus.available));
        default:
          break;
      }
    });
  }

  /// Só deve ser chamado depois da confirmação do usuário, pois reinicia o app.
  Future<void> completeUpdate() async {
    try {
      await _service.completeUpdate();
    } catch (e) {
      log('$e', name: 'completeUpdate');
    }
  }

  @override
  Future<void> close() {
    _installSubscription?.cancel();
    return super.close();
  }
}
