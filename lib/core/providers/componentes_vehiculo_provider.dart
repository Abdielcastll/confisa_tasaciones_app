import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/componentes_vehiculo_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/componentes_vehiculo_response.dart';

import '../api/api_status.dart';
import '../api/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo_api.dart';
import '../models/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo_response.dart';

class ComponentesVehiculosProvider with ChangeNotifier {
  static ComponentesVehiculosProvider instance = ComponentesVehiculosProvider();
  final _condicionesComponentesApi =
      locator<CondicionesComponentesVehiculoApi>();
  final _componentesApi = locator<ComponentesVehiculoApi>();
  List<AsociadosCondicionesComponentesVehiculoData> componentes = [];
  List<ComponentesVehiculoData> componentesSeg = [];

  Future<void> getComponentes() async {
    var resp = await _condicionesComponentesApi
        .getCondicionesAsociadosComponentesVehiculo();
    if (resp is Success<AsociadosCondicionesComponentesVehiculoResponse>) {
      componentes = resp.response.data;
      notifyListeners();
    }
  }

  Future<void> getComponentesSeg() async {
    var resp = await _componentesApi.getComponentesVehiculo();
    if (resp is Success<ComponentesVehiculoResponse>) {
      componentesSeg = resp.response.data;
      notifyListeners();
    }
  }
}
