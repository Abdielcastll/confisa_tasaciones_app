import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/providers.dart';
import 'package:tasaciones_app/core/router.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/login/login_view.dart';

void main() async {
  await LocatorInjector.setupLocator();
  runApp(const MainApplication());
}

class MainApplication extends StatelessWidget {
  const MainApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderInjector.providers,
      child: MaterialApp(
        navigatorKey: locator<NavigatorService>().navigatorKey,
        onGenerateRoute: generateRoute,
        initialRoute: LoginView.routeName,
      ),
    );
  }
}
