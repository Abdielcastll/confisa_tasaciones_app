import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_solicitudes/accesorios_response.dart';

import '../api/api_status.dart';
import '../api/seguridad_entidades_solicitudes/accesorios_api.dart';

class AccesoriosProvider with ChangeNotifier {
  static AccesoriosProvider instance = AccesoriosProvider();
  final _accesorios = locator<AccesoriosApi>();
  List<AccesoriosData> accesorios = [];

  Future<void> getAccesorios() async {
    var resp = await _accesorios.getAccesorios();
    if (resp is Success<AccesoriosResponse>) {
      accesorios = resp.response.data;
      notifyListeners();
    }
  }
}
