import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/acciones_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';

class AccionesViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _accionesApi = locator<AccionesApi>();
  final listController = ScrollController();

  List<AccionesData> acciones = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool hasNextPage = false;

  AccionesViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasAcciones();
        }
      }
    });
  }

  bool get cargando => _cargando;
  set cargando(bool value) {
    _cargando = value;
    notifyListeners();
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _accionesApi.getAcciones(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AccionesResponse;
      acciones = temp.data;
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasAcciones() async {
    pageNumber += 1;
    var resp = await _accionesApi.getAcciones(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as AccionesResponse;
      acciones.addAll(temp.data);
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  @override
  void dispose() {
    listController.dispose();
    super.dispose();
  }
}
