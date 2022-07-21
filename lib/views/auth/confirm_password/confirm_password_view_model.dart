import 'package:flutter/widgets.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/services/navigator_service.dart';

class ConfirmPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  TextEditingController tcPassword = TextEditingController();
  TextEditingController tcPasswordConfirm = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool obscurePassword = true;
  bool obscurePasswordConfirm = true;
  bool _isValidPassword = false;

  bool get isValidPassword => _isValidPassword;
  set isValidPassword(bool value) {
    _isValidPassword = value;
    notifyListeners();
  }

  void onChangeObscure() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void onChangeObscureConfirm() {
    obscurePasswordConfirm = !obscurePasswordConfirm;
    notifyListeners();
  }

  void goBack() {
    _navigationService.pop();
  }

  String? validator(String? value) {
    if (tcPassword.text.trim() != tcPasswordConfirm.text.trim()) {
      return 'Las contraseñas deben ser iguales';
    } else if (!_isValidPassword) {
      return 'Contraseña inválida';
    } else {
      return null;
    }
  }
}

class FrenchStrings implements FlutterPwValidatorStrings {
  @override
  final String atLeast = 'Al menos - caracteres';
  @override
  final String uppercaseLetters = '- letra mayúsculas';
  @override
  final String numericCharacters = '- número';
  @override
  final String specialCharacters = '- caracter especial';

  @override
  // TODO: implement normalLetters
  String get normalLetters => '';
}
