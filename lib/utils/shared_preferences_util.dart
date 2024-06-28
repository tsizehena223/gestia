import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<void> storeUserName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", value);
  }

  static Future<void> storeBalance(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("userbalance", value);
  }

  static Future<String?> retrieveUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  static Future<int?> retrieveBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userbalance");
  }
}