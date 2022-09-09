import 'package:provider/single_child_widget.dart';
import 'package:tasaciones_app/core/providers/menu_provider.dart';
import 'package:tasaciones_app/core/providers/permisos_provider.dart';
import 'package:tasaciones_app/core/providers/profile_permisos_provider.dart';

import '../core/locator.dart';
import '../core/services/navigator_service.dart';
import 'package:provider/provider.dart';

class ProviderInjector {
  static List<SingleChildWidget> providers = [
    ..._independentServices,
    ..._dependentServices,
    ..._consumableServices,
  ];

  static final List<SingleChildWidget> _independentServices = [
    Provider.value(value: locator<NavigatorService>()),
  ];

  static final List<SingleChildWidget> _dependentServices = [];

  static final List<SingleChildWidget> _consumableServices = [
    ChangeNotifierProvider(create: (_) => PermisosUserProvider()),
    ChangeNotifierProvider(create: (_) => MenuProvider()),
    ChangeNotifierProvider(create: (_) => ProfilePermisosProvider()),
    // ChangeNotifierProvider(create: (_) => RolesProvider.instance),
  ];
}
