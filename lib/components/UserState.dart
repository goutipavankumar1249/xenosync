import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState with ChangeNotifier {
  Map<String, dynamic>? userData;
  late String _userId;
  bool _isLoggedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get userId => _userId;
  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic> _selectedFilters = {}; // Store filters here
  Map<String, dynamic> get selectedFilters => _selectedFilters;

  void setUserId(String id) {
    _userId = id;
    _isLoggedIn = true;
    notifyListeners();
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

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userId = '';
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
}
