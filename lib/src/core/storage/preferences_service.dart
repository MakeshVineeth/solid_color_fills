import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';

/// Abstract storage contract for test mockability (LSP, DIP).
abstract class PreferencesService {
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchCompleted();
  Future<int> getTabIndex();
  Future<void> setTabIndex(int index);
}

/// SharedPreferences concrete implementation.
class SharedPreferencesServiceImpl implements PreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesServiceImpl(this._prefs);

  @override
  Future<bool> isFirstLaunch() async {
    return _prefs.getBool(AppConstants.keyFirstLaunch) ?? true;
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    await _prefs.setBool(AppConstants.keyFirstLaunch, false);
  }

  @override
  Future<int> getTabIndex() async {
    return _prefs.getInt(AppConstants.keyTabIndex) ?? 0;
  }

  @override
  Future<void> setTabIndex(int index) async {
    await _prefs.setInt(AppConstants.keyTabIndex, index);
  }
}
