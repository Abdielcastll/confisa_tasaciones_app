import 'package:flutter/widgets.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/services/navigator_service.dart';

class ConfirmPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  TextEditingController tcPassword = TextEditingController();
  TextEditingController tcPasswordConfirm = TextEditingController();
  bool obscurePassword = true;
  bool obscurePasswordConfirm = true;

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
}
