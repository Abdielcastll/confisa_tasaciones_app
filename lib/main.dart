import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/providers.dart';
import 'package:tasaciones_app/core/router.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/login/login_view.dart';
import 'package:tasaciones_app/widgets/no_scale_widget.dart';

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

class MainApplication extends StatelessWidget {
  const MainApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderInjector.providers,
      child: MaterialApp(
        title: 'Tasaciones',
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigatorService>().navigatorKey,
        onGenerateRoute: generateRoute,
        initialRoute: LoginView.routeName,
        builder: (context, child) {
          return NoScaleTextWidget(
            child: child!,
          );
        },
      ),
    );
  }
}
