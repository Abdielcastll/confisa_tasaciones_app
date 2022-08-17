import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/views/solicitudes/solicitud_estimacion/solicitud_estimacion_view.dart';

import '../../../core/api/api_status.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/services/navigator_service.dart';
import '../../../widgets/app_dialogs.dart';

class ColaSolicitudesViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final listController = ScrollController();
  late GetSolicitudesResponse solicitudesResponse;
  List<SolicitudesData> solicitudes = [];
  bool _loading = true;
  int pageNumber = 1;
  int _currentForm = 0;
  bool hasNextPage = false;

  ColaSolicitudesViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMas();
        }
      }
    });
  }

  int get currentForm => _currentForm;
  set currentForm(int value) {
    _currentForm = value;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> onInit(BuildContext context) async {
    var resp = await _solicitudesApi.getColaSolicitudes();
    if (resp is Success) {
      solicitudesResponse = resp.response as GetSolicitudesResponse;
      solicitudes = solicitudesResponse.data;
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    loading = false;
  }

  Future<void> cargarMas() async {
    pageNumber += 1;
    var resp = await _solicitudesApi.getColaSolicitudes(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as GetSolicitudesResponse;
      solicitudesResponse.data.addAll(temp.data);
      solicitudes.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  void ordenar() {
    solicitudes.sort((a, b) {
      return a.noSolicitudCredito
          .toString()
          .toLowerCase()
          .compareTo(b.noSolicitudCredito.toString().toLowerCase());
    });
  }

  goToSolicitud(SolicitudesData s) {
    _navigatorService.navigateToPage(
      SolicitudEstimacionView.routeName,
      arguments: s,
    );
  }
}
