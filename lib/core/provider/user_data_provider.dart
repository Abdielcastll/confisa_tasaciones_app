import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';

class UserProvider with ChangeNotifier {
  late SignInResponse _user;

  SignInResponse get user => _user;
  set user(SignInResponse value) {
    _user = value;
    notifyListeners();
  }
}
