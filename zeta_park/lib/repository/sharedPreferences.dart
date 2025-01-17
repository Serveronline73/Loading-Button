import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Speichert Nebenkosten unter dem angegebenen Schlüssel
  static Future<void> saveNebenkosten(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Lädt einen String-Wert unter dem angegebenen Schlüssel
  static Future<String?> loadString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Speichert einen booleschen Wert unter dem angegebenen Schlüssel
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Lädt einen booleschen Wert unter dem angegebenen Schlüssel
  static Future<bool?> loadBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Speichert einen Integer-Wert unter dem angegebenen Schlüssel
  static Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Lädt einen Integer-Wert unter dem angegebenen Schlüssel
  static Future<int?> loadInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Speichert einen Double-Wert unter dem angegebenen Schlüssel
  static Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // Lädt einen Double-Wert unter dem angegebenen Schlüssel
  static Future<double?> loadDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future<void> removeAusgaben(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
