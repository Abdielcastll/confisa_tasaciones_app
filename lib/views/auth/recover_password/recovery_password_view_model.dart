import 'package:flutter/widgets.dart';
import 'package:tasaciones_app/core/api/api_status.dart';

import '../../../core/api/autentication_api.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/services/navigator_service.dart';
import '../../../widgets/app_dialogs.dart';

class RecoveryPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _authenticationAPI = locator<AuthenticationAPI>();
  TextEditingController tcEmail = TextEditingController();
  bool _loading = false;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> forgotPassword(BuildContext context) async {
    loading = true;
    var resp =
        await _authenticationAPI.forgotPassword(email: tcEmail.text.trim());
    if (resp is Success) {
      Dialogs.alert(context, tittle: '', description: ['Email enviado']);
    }
    if (resp is Failure) {
      Dialogs.alert(context, tittle: 'error', description: resp.messages);
    }

    loading = false;
  }

  void goBack() {
    _navigationService.pop();
  }
}
