import 'package:flutter/cupertino.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/personal_api.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../core/base/base_view_model.dart';
import '../../core/locator.dart';
import '../../core/models/profile_response.dart';

class PerfilViewModel extends BaseViewModel {
  final _personalApi = locator<PersonalApi>();
  bool _loading = false;
  Profile? profile;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> onInit(BuildContext context) async {
    loading = true;
    var resp = await _personalApi.getProfile();
    if (resp is Success) {
      var d = resp.response as ProfileResponse;
      profile = d.data;
    }
    if (resp is Failure) {
      Dialogs.alert(context, tittle: 'error', description: resp.messages);
    }
    loading = false;
  }
}
