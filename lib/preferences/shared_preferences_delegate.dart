import 'package:firebase_local_config/preferences/preferences_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDelegate extends PreferencesDelegate {
  static const keyPrefix = 'shared_prefs_config_source:';

  @override
  Future<String?> getPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyPrefix + key);
  }

  @override
  Future<void> setPreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyPrefix + key, value);
  }
}
