import 'dart:io';

import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppUpdateAvailability { none, available, downloaded }

/// Camada sobre a Play Core (via in_app_update) e sobre a data de dispensa do popup.
/// A atualização in-app só existe no Android e em builds instalados pela Play Store.
class AppUpdateService {
  static const _dismissedAtKey = 'update_popup_dismissed_at';

  /// Consulta a Play Store. Lança exceção se a checagem falhar (sem internet, build fora da Play, etc).
  Future<AppUpdateAvailability> checkForUpdate() async {
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
      InAppUpdate.installUpdateListener;

  Future<AppUpdateResult> startFlexibleUpdate() {
    return InAppUpdate.startFlexibleUpdate();
  }

  /// Instala a atualização baixada e reinicia o app.
  Future<void> completeUpdate() {
    return InAppUpdate.completeFlexibleUpdate();
  }

  Future<DateTime?> getDismissedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_dismissedAtKey);
    return value == null ? null : DateTime.tryParse(value);
  }

  Future<void> saveDismissedAt(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dismissedAtKey, date.toIso8601String());
  }
}
