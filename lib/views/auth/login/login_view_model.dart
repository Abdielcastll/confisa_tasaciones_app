import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/autentication_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/auth/recover_password/recovery_password_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import 'package:tasaciones_app/views/home/home_view.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _authenticationAPI = locator<AuthenticationAPI>();
  final _autenticationClient = locator<AuthenticationClient>();
  bool _loading = false;
  TextEditingController tcEmail =
      TextEditingController(text: 'abdielcastll@gmail.com');
  TextEditingController tcPassword =
      TextEditingController(text: '123Pa\$\$word!');
  bool obscurePassword = true;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    loading = true;
    var resp = await _authenticationAPI.signIn(
      email: tcEmail.text,
      password: tcPassword.text,
    );
    if (resp is Success<SignInResponse>) {
      loading = false;
      _autenticationClient.saveSession(resp.response.data);
      _navigationService.navigateToPageWithReplacement(HomeView.routeName);
    } else if (resp is Failure) {
      loading = false;
      Dialogs.alert(
        context,
        tittle: 'Error',
        description: resp.messages,
      );
    }
  }

  void changeObscure() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void goToRecoveryPassword() {
    _navigationService.navigateToPage(RecoveryPasswordView.routeName);
  }

  @override
  void dispose() {
    tcEmail.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}