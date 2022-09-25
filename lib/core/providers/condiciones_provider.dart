import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/locator.dart';

import '../api/api_status.dart';
import '../api/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo_api.dart';
import '../models/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo_response.dart';

class CondicionesComponentesVehiculosProvider with ChangeNotifier {
  static CondicionesComponentesVehiculosProvider instance =
      CondicionesComponentesVehiculosProvider();
  final _condiciones = locator<CondicionesComponentesVehiculoApi>();
  List<CondicionesComponentesVehiculoData> condiciones = [];

  Future<void> getCondiciones() async {
    var resp = await _condiciones.getCondicionesComponentesVehiculo();
    if (resp is Success<CondicionesComponentesVehiculoResponse>) {
      condiciones = resp.response.data;
      notifyListeners();
    }
  }
}
