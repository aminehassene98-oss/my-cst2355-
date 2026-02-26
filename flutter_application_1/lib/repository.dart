import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

// repository class is used to manage all user data in one place
class Repository {
  // create encrypted shared pref instance
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  // variables to store user information
  String loginName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String email = "";

  // function to load data from encrypted shared pref
  // gets saved values when app start
  Future<void> loadData() async {
    // if value exist load it if not return empty string
    loginName = await _prefs.getString("loginName") ?? "";
    firstName = await _prefs.getString("firstName") ?? "";
    lastName = await _prefs.getString("lastName") ?? "";
    phone = await _prefs.getString("phone") ?? "";
    email = await _prefs.getString("email") ?? "";
  }

  // saves data into encrypted shared pref
  // everytime user update something we call this
  Future<void> saveData() async {
    // store each value using a key
    await _prefs.setString("loginName", loginName);
    await _prefs.setString("firstName", firstName);
    await _prefs.setString("lastName", lastName);
    await _prefs.setString("phone", phone);
    await _prefs.setString("email", email);
  }
}