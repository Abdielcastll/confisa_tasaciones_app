import 'package:flutter/widgets.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/autentication_api.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/services/navigator_service.dart';

class ConfirmPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _authenticationAPI = locator<AuthenticationAPI>();
  TextEditingController tcPassword = TextEditingController();
  TextEditingController tcPasswordConfirm = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool obscurePassword = true;
  bool obscurePasswordConfirm = true;
  bool _isValidPassword = false;
  String? username;
  String? token;
  late bool activateUser;

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

  void onInit(bool act, String? u, String? t) {
    token = t;
    username = u;
    activateUser = act;
    notifyListeners();
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

  Future<void> resetPassword(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _authenticationAPI.resetPassword(
      email: username ?? '',
      token: token ?? '',
      password: tcPassword.text.trim(),
      confirmPassword: tcPasswordConfirm.text.trim(),
    );
    if (resp is Success) {
      ProgressDialog.dissmiss(context);
      _navigationService.navigateToPageWithReplacement(LoginView.routeName);
    }
    if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages[0]);
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
