import 'package:confisa_tasaciones_app/core/providers.dart';
import 'package:confisa_tasaciones_app/core/routes.dart';
import 'package:confisa_tasaciones_app/core/shared_preferences.dart';
import 'package:confisa_tasaciones_app/core/theme.dart';
import 'package:confisa_tasaciones_app/views/lista_tasaciones/lista_tasaciones_view.dart';
import 'package:confisa_tasaciones_app/views/login/login_view.dart';
import 'package:confisa_tasaciones_app/views/reporte/reporte_view.dart';
import 'package:confisa_tasaciones_app/widgets/no_scale_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = Preferencias();
  await prefs.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderInjector.providers,
      child: MaterialApp(
        title: 'Confisa Tasaciones App',
        debugShowCheckedModeBanner: false,
        routes: router,
        initialRoute: ListaTasacionesView.routeName,
        theme: myTheme,
        builder: (context, child) {
          return NoScaleTextWidget(
            child: child!,
          );
        },
      ),
    );
  }
}
