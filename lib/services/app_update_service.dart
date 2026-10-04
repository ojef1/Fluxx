import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppUpdateAvailability { none, available, downloaded }

/// Camada sobre a Play Core (via in_app_update) e sobre a data de dispensa do popup.
/// A atualização in-app só existe no Android e em builds instalados pela Play Store.
class AppUpdateService {
  static const _dismissedAtKey = 'update_popup_dismissed_at';

  // Simulação para testar a interface sem a Play Store. Só vale em debug:
  // flutter run --dart-define=SIMULATE_UPDATE=true
  static const _simulateFlag = bool.fromEnvironment('SIMULATE_UPDATE');
  static const bool _simulate = kDebugMode && _simulateFlag;
  final StreamController<InstallStatus> _simulatedStatus =
      StreamController<InstallStatus>.broadcast();

  /// Consulta a Play Store. Lança exceção se a checagem falhar (sem internet, build fora da Play, etc).
  Future<AppUpdateAvailability> checkForUpdate() async {
    if (_simulate) return AppUpdateAvailability.available;
    if (!Platform.isAndroid) return AppUpdateAvailability.none;

    final info = await InAppUpdate.checkForUpdate();

    //o download já terminou em uma sessão anterior e falta só reiniciar
    if (info.installStatus == InstallStatus.downloaded) {
      return AppUpdateAvailability.downloaded;
    }

    final hasUpdate =
        info.updateAvailability == UpdateAvailability.updateAvailable &&
            info.flexibleUpdateAllowed;
    return hasUpdate
        ? AppUpdateAvailability.available
        : AppUpdateAvailability.none;
  }

  /// Avisa quando o status da instalação muda (baixando, baixado, falha...).
  Stream<InstallStatus> get installStatusStream =>
      _simulate ? _simulatedStatus.stream : InAppUpdate.installUpdateListener;

  Future<AppUpdateResult> startFlexibleUpdate() async {
    if (_simulate) {
      _simulatedStatus.add(InstallStatus.downloading);
      Future.delayed(const Duration(seconds: 3), () {
        _simulatedStatus.add(InstallStatus.downloaded);
      });
      return AppUpdateResult.success;
    }
    return InAppUpdate.startFlexibleUpdate();
  }

  /// Instala a atualização baixada e reinicia o app.
  Future<void> completeUpdate() async {
    //na simulação o app não reinicia
    if (_simulate) return;
    return InAppUpdate.completeFlexibleUpdate();
  }

  Future<DateTime?> getDismissedAt() async {
    //na simulação o popup aparece a cada abertura, para poder repetir o teste
    if (_simulate) return null;
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_dismissedAtKey);
    return value == null ? null : DateTime.tryParse(value);
  }

  Future<void> saveDismissedAt(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dismissedAtKey, date.toIso8601String());
  }
}
