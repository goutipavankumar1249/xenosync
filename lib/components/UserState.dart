import 'package:flutter/foundation.dart';

class UserState with ChangeNotifier {
  Map<String, dynamic>? userData;

  late String _userId;

  String get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners(); // Notify listeners of the change
  }

  void setUserData(Map<String, dynamic> data) {
    userData = data;
    notifyListeners();
  }
}
