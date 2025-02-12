import 'package:flutter/foundation.dart';

class UserState with ChangeNotifier {
  Map<String, dynamic>? userData;
  late String _userId;
  String get userId => _userId;
  Map<String, dynamic> _selectedFilters = {}; // Store filters here
  Map<String, dynamic> get selectedFilters => _selectedFilters;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners(); // Notify listeners of the change
  }

  void setUserData(Map<String, dynamic> data) {
    userData = data;
    notifyListeners();
  }

  // Function to store selected filters
  void setSelectedFilters(Map<String, dynamic> filters) {
    _selectedFilters = filters;
    notifyListeners(); // Notify listeners that filters have changed
  }


}
