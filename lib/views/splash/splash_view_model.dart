import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/views/solicitudes/cola_solicitudes/cola_solicitudes_view.dart';
import 'package:uni_links/uni_links.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../core/api/api_status.dart';
import '../../core/api/recursos_api.dart';
import '../../core/authentication_client.dart';
import '../../core/models/menu_response.dart';
import '../../core/providers/menu_provider.dart';
import '../auth/confirm_password/confirm_password_view.dart';

class SplashViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _session = locator<AuthenticationClient>();
  final _recursosAPI = locator<RecursosAPI>();

  StreamSubscription? _sub;
  bool _initialURILinkHandled = false;
  bool _initLink = false;
  final l = Logger();

  SplashViewModel();

  void init(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _incomingLinkHandler();
    await _initUniLinks();
    if (_initLink) return;
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

  Future<void> _initUniLinks() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final uriCod = await getInitialUri();

        if (uriCod != null) {
          _initLink = true;
          var path = Uri.decodeComponent(uriCod.path);
          Uri uri = Uri(path: path);
          var paths = uri.pathSegments;
          bool activate = paths[0] == 'reset-password' ? false : true;
          String? token = paths[1];
          String? username = paths[2];
          _navigationService.navigatorKey.currentState
              ?.pushReplacement(MaterialPageRoute(builder: (context) {
            return ConfirmPasswordView(
              activateUser: activate,
              token: token,
              email: username,
            );
          }));
        }
      } on PlatformException {
        // Handle exception by warning the user their action did not succeed
        // return?
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _incomingLinkHandler() {
    _sub = uriLinkStream.listen((Uri? uriCod) {
      if (uriCod != null) {
        var path = Uri.decodeComponent(uriCod.path);
        Uri uri = Uri(path: path);
        var paths = uri.pathSegments;
        bool activate = paths[0] == 'reset-password' ? false : true;
        String? token = paths[1];
        String? username = paths[2];
        _navigationService.navigatorKey.currentState
            ?.pushReplacement(MaterialPageRoute(builder: (context) {
          return ConfirmPasswordView(
            activateUser: activate,
            token: token,
            email: username,
          );
        }));
      }
    });
  }
}
