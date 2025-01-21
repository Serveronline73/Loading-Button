import 'package:flutter/material.dart';

class RoleManager extends ChangeNotifier {
  bool isAdmin = false;
  bool get admin => isAdmin;
  void setAdmin({required bool isAdmin}) {
    this.isAdmin = isAdmin;
    notifyListeners();
  }
}
