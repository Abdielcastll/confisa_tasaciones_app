import 'package:flutter/cupertino.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/personal_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../core/base/base_view_model.dart';
import '../../core/locator.dart';
import '../../core/models/profile_response.dart';
import '../../core/services/navigator_service.dart';
import '../auth/login/login_view.dart';

class PerfilViewModel extends BaseViewModel {
  final _personalApi = locator<PersonalApi>();
  final _authenticationClient = locator<AuthenticationClient>();
  final _navigatorService = locator<NavigatorService>();
  bool _loading = false;
  Profile? profile;
  int _currentPage = 0;
  bool _editName = false;
  bool _editEmail = false;
  bool _editPhone = false;
  TextEditingController tcCurrentPass = TextEditingController();
  TextEditingController tcNewPass = TextEditingController();
  TextEditingController tcConfirmNewPass = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscurePassCurrent = true;
  bool obscurePassNew = true;
  bool obscurePassConfirmNew = true;
  late Session session;

  void changeObscureCurrent() {
    obscurePassCurrent = !obscurePassCurrent;
    notifyListeners();
  }

  void changeObscureNew() {
    obscurePassNew = !obscurePassNew;
    notifyListeners();
  }

  void changeObscureConfirmNew() {
    obscurePassConfirmNew = !obscurePassConfirmNew;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get editName => _editName;
  set editName(bool value) {
    _editName = value;
    notifyListeners();
  }

  bool get editEmail => _editEmail;
  set editEmail(bool value) {
    _editEmail = value;
    notifyListeners();
  }

  bool get editPhone => _editPhone;
  set editPhone(bool value) {
    _editPhone = value;
    notifyListeners();
  }

  int get currentPage => _currentPage;
  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  Future<void> onInit(BuildContext context) async {
    loading = true;
    session = _authenticationClient.loadSession;
    var resp = await _personalApi.getProfile();
    if (resp is Success) {
      var d = resp.response as ProfileResponse;
      profile = d.data;
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
    loading = false;
  }

  bool editable() {
    return (session.typeRol == 67);
  }

  void onChangedName(String value) {
    profile?.nombreCompleto = value;
    notifyListeners();
  }

  void onChangedEmail(String value) {
    profile?.email = value;
    notifyListeners();
  }

  void onChangedPhone(String value) {
    profile?.phoneNumber = value;
    notifyListeners();
  }

  void guardarPerfil(BuildContext context) async {
    if (profile != null) {
      editEmail = false;
      editName = false;
      editPhone = false;
      ProgressDialog.show(context);
      var resp = await _personalApi.updateProfile(
        id: profile?.id ?? '',
        fullName: profile?.nombreCompleto ?? '',
        phoneNumber: profile?.phoneNumber ?? '',
        email: profile?.email ?? '',
      );
      ProgressDialog.dissmiss(context);
      if (resp is Success) {
        Dialogs.success(msg: 'Datos actualizados');
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        Dialogs.error(msg: 'su sesión a expirado');
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
    }
  }

  void updatePassword(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _personalApi.changePasswordProfile(
        passWord: tcCurrentPass.text.trim(),
        newPassword: tcNewPass.text.trim(),
        confirmNewPassword: tcConfirmNewPass.text.trim(),
      );
      ProgressDialog.dissmiss(context);
      if (resp is Success) {
        Dialogs.success(msg: 'Contraseña actualizada');
        tcCurrentPass.clear();
        tcConfirmNewPass.clear();
        tcNewPass.clear();
        currentPage = 0;
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        Dialogs.error(msg: 'su sesión a expirado');
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
    }
  }

  @override
  void dispose() {
    tcCurrentPass.dispose();
    tcNewPass.dispose();
    tcConfirmNewPass.dispose();
    super.dispose();
  }
}
