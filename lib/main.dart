import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/providers.dart';
import 'package:tasaciones_app/core/router.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/confirm_password/confirm_password_view.dart';
import 'package:tasaciones_app/views/auth/recover_password/recovery_password_view.dart';
import 'package:tasaciones_app/views/splash/splash_view.dart';
import 'package:tasaciones_app/widgets/no_scale_widget.dart';

import 'dart:async';
import 'dart:io';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'views/auth/login/login_view.dart';

void main() async {
  /* Quitar barra de notificaciones */
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  await LocatorInjector.setupLocator();
  await DependencyInjection.initialize();
  runApp(const MainApplication());
}

class MainApplication extends StatefulWidget {
  const MainApplication({Key? key}) : super(key: key);

  @override
  State<MainApplication> createState() => _MainApplicationState();
}

class _MainApplicationState extends State<MainApplication> {
// ...
  final _navigationService = locator<NavigatorService>();
  StreamSubscription? _sub;
  bool _initialURILinkHandled = false;
  final l = Logger();

  Future<void> _initUniLinks() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final uriCod = await getInitialUri();

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
      } on PlatformException {
        // Handle exception by warning the user their action did not succeed
        // return?
      }
    }
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

  @override
  void initState() {
    _initUniLinks();
    _incomingLinkHandler();
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderInjector.providers,
      child: MaterialApp(
        title: 'Tasaciones',
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigatorService>().navigatorKey,
        onGenerateRoute: generateRoute,
        initialRoute: SplashView.routeName,
        theme: myTheme,
        builder: (context, child) {
          return NoScaleTextWidget(
            child: child!,
          );
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('en', 'US'),
        ],
        locale: const Locale('es'),
      ),
    );
  }
}
