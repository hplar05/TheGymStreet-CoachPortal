import 'package:flutter/material.dart';

class Client with ChangeNotifier {
  int _id = 0;

  int get id => _id;

  void setId(int newId) {
    _id = newId;
    notifyListeners();
  }
  void clearProfile() {
    
    _id = 0;
    notifyListeners(); // Notify listeners after clearing the values
  }

}
