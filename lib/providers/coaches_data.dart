import 'package:flutter/material.dart';

class Coach with ChangeNotifier {
  String _token = '';
  int _id = 0;
  String _firstname = '';
  String _middlename = '';
  String _lastname = '';
  String _gender = '';
  String _phone = '';
  String _email = '';

  String get token => _token;
  int get id => _id;
  String get fname => _firstname;
  String get mname => _middlename;
  String get lname => _lastname;
  String get gender => _gender;
  String get phone => _phone;
  String get email => _email;

  void storeProfile(String token, int id, String firstName, String middleName, String lastName, String gender, String phone, String email) {
    _token = token;
    _id = id;
    _firstname = firstName;
    _middlename = middleName;
    _lastname = lastName;
    _gender = gender;
    _phone = phone;
    _email = email;
    notifyListeners(); // Notify listeners after updating the values
  }

  void clearProfile() {
    _token = '';
    _id = 0;
    _firstname = '';
    _middlename = '';
    _lastname = '';
    _gender = '';
    _phone = '';
    _email = '';
    notifyListeners(); // Notify listeners after clearing the values
  }

  void updateToken(String token) {
    _token = token;
    notifyListeners(); // Notify listeners after updating the token
  }
}
