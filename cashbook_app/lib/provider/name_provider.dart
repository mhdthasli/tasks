// import 'package:flutter/cupertino.dart';
//
// class UserProvider with ChangeNotifier {
//   String _userName = ''; // Example of userName state
//
//   String get userName => _userName;
//
//   set userName(String name) {
//     _userName = name;
//     notifyListeners(); // Notify listeners whenever the username changes
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _userName = ''; // Example of userName state

  // Getter for userName
  String get userName => _userName;

  // Setter for userName with notification
  set userName(String name) {
    _userName = name;
    _saveUserNameToPrefs(name); // Save username to SharedPreferences
    notifyListeners(); // Notify listeners whenever the username changes
  }

  // Method to load the userName from SharedPreferences or other source
  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? ''; // Load saved userName
    notifyListeners();
  }

  // Method to save the userName to SharedPreferences
  Future<void> _saveUserNameToPrefs(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
  }

  // Method to clear user data during logout
  Future<void> clearUserName() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userName');
    _userName = ''; // Clear the in-memory value
    notifyListeners();
  }
}
