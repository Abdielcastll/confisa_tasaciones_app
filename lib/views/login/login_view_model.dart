import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/autentication_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/home/home_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _authenticationAPI = locator<AuthenticationAPI>();
  final _autenticationClient = locator<AuthenticationClient>();

  TextEditingController tcEmail = TextEditingController();
  TextEditingController tcPassword = TextEditingController();
  bool obscurePassword = true;

  Future<void> signIn(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _authenticationAPI.signIn(
      email: tcEmail.text,
      password: tcPassword.text,
    );
    if (resp is Success<SignInResponse>) {
      ProgressDialog.dissmiss(context);
      _autenticationClient.saveSession(resp.response.data);
      _navigationService.navigateToPageWithReplacement(HomeView.routeName);
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
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

  @override
  void dispose() {
    tcEmail.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
