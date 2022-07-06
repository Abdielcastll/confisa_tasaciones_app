import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';

class HomeViewModel extends BaseViewModel {
  final _authenticationClient = locator<AuthenticationClient>();
  late Session _user;
  final logger = Logger();

  Session get user => _user;
  set user(Session value) {
    _user = value;
    notifyListeners();
  }

  void onInit() => user = _authenticationClient.loadSession;

  void accesToken() async =>
      logger.i(" TOKEN: ${await _authenticationClient.accessToken}");
}
