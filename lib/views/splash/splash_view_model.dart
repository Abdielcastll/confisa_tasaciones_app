import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/views/solicitudes/cola_solicitudes/cola_solicitudes_view.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../core/api/api_status.dart';
import '../../core/api/recursos_api.dart';
import '../../core/authentication_client.dart';
import '../../core/models/menu_response.dart';
import '../../core/providers/menu_provider.dart';

class SplashViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _session = locator<AuthenticationClient>();
  final _recursosAPI = locator<RecursosAPI>();

  void init(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (_session.isLogged) {
      var token = await _session.accessToken;
      if (token == null) {
        _navigationService.navigatorKey.currentState!
            .pushReplacementNamed(LoginView.routeName);
      } else {
        await getMenu(context);
        _navigationService.navigatorKey.currentState!
            .pushReplacementNamed(ColaSolicitudesView.routeName);
      }
    } else {
      _navigationService.navigatorKey.currentState!
          .pushReplacementNamed(LoginView.routeName);
    }
  }

  Future<void> getMenu(BuildContext context) async {
    var resp = await _recursosAPI.getMenu();
    if (resp is Success<MenuResponse>) {
      Provider.of<MenuProvider>(context, listen: false).menu = resp.response;
    }
  }
}
