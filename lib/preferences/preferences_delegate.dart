abstract class PreferencesDelegate {
  Future<String?> getPreference(String key);

  Future<void> setPreference(String key, String value);
}
