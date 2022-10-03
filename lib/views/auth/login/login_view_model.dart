import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/autentication_api.dart';
import 'package:tasaciones_app/core/api/personal_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/menu_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/providers/menu_provider.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/utils/cuentas.dart';
import 'package:tasaciones_app/views/auth/recover_password/recovery_password_view.dart';
import 'package:tasaciones_app/views/solicitudes/cola_solicitudes/cola_solicitudes_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import 'package:tasaciones_app/views/home/home_view.dart';

import '../../../core/api/recursos_api.dart';
import '../../../core/user_client.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _authenticationAPI = locator<AuthenticationAPI>();
  final _recursosAPI = locator<RecursosAPI>();
  final _personalApi = locator<PersonalApi>();
  final _autenticationClient = locator<AuthenticationClient>();
  final _userClient = locator<UserClient>();
  final GlobalKey<FormState> formKey = GlobalKey();
  bool _loading = false;
  TextEditingController tcEmail =
      TextEditingController(text: AppCuentas().usuarioAprobadorTasacionesid);
  TextEditingController tcPassword =
      TextEditingController(text: AppCuentas().claveExterna);
  bool obscurePassword = true;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      loading = true;
      var resp = await _authenticationAPI.signIn(
        email: tcEmail.text,
        password: tcPassword.text,
      );
      if (resp is Success<SignInResponse>) {
        _autenticationClient.saveSession(resp.response.data);
        var resp1 = await _recursosAPI.getMenu();
        if (resp1 is Success<MenuResponse>) {
          Provider.of<MenuProvider>(context, listen: false).menu =
              resp1.response;
          var resp2 = await _personalApi.getProfile();
          if (resp2 is Success<ProfileResponse>) {
            loading = false;
            _userClient.saveProfile(resp2.response.data);
            _navigationService
                .navigateToPageWithReplacement(ColaSolicitudesView.routeName);
          } else if (resp2 is Failure) {
            if (resp2.messages.first != "No Internet") {
              loading = false;
              _navigationService
                  .navigateToPageWithReplacement(ColaSolicitudesView.routeName);
            } else {
              loading = false;
              Dialogs.error(msg: resp2.messages[0]);
            }
          }
        } else if (resp1 is Failure) {
          if (resp1.messages.first != "No Internet") {
            loading = false;
            _navigationService
                .navigateToPageWithReplacement(ColaSolicitudesView.routeName);
          } else {
            loading = false;
            Dialogs.error(
              msg: resp1.messages[0],
            );
          }
        }
      } else if (resp is Failure) {
        loading = false;
        Dialogs.error(
          msg: resp.messages[0],
        );
      }
    }
  }

  Future<void> getMenu(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _recursosAPI.getMenu();
    if (resp is Success<MenuResponse>) {
      ProgressDialog.dissmiss(context);
      Provider.of<MenuProvider>(context, listen: false).menu = resp.response;
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages.first);
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

  // goToConfigPassword() {
  //   // _navigationService.navigateToPage(ConfirmPasswordView.routeName);
  //   _navigationService.navigatorKey.currentState
  //       ?.pushReplacement(MaterialPageRoute(builder: (context) {
  //     return const ConfirmPasswordView(
  //       activateUser: false,
  //       token: 'token',
  //       email: 'abdielcastll@gmail.com',
  //     );
  //   }));
  // }
}
