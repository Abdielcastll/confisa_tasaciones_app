import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../auth/login/login_view.dart';

class SolicitudTasacionViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  late DateTime fechaActual;
  String? _numeroSolicitud;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  int _currentForm = 1;
  late SolicitudCreditoData solicitud;

  SolicitudTasacionViewModel() {
    fechaActual = DateTime.now();
  }

  set numeroSolicitud(String value) {
    _numeroSolicitud = value;
    notifyListeners();
  }

  int get currentForm => _currentForm;
  set currentForm(int i) {
    _currentForm = i;
    notifyListeners();
  }

  void onInit(BuildContext context) {}

  Future<void> solicitudCredito(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _solicitudesApi.getSolicitudCredito(
          idSolicitud: int.parse(_numeroSolicitud!));
      if (resp is Success) {
        var data = resp.response as SolicitudCreditoResponse;
        solicitud = data.data;
        currentForm = 2;
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        ProgressDialog.dissmiss(context);
        Dialogs.error(msg: 'su sesión a expirado');
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
      ProgressDialog.dissmiss(context);
    }
  }

  String? noSolicitudValidator(String? value) {
    if (value?.trim() == '') {
      return 'Ingrese el número de solicitud';
    } else {
      return null;
    }
  }

  Future<void> guardarTasacion(BuildContext context) async {
    print('idOficial: ${solicitud.codOficialNegocios}');
    ProgressDialog.show(context);
    var resp = await _solicitudesApi.createNewSolicitudTasacion(
      codigoEntidad: solicitud.codEntidad!,
      codigoSucursal: solicitud.codSucursal!,
      idOficial: solicitud.codOficialNegocios!,
      identificacion: solicitud.noIdentificacion!,
      noSolicitudCredito: solicitud.noSolicitud!,
      nombreCliente: solicitud.nombreCliente!,
      tipoTasacion: 0,
      suplidorTasacion: 0,
    );
    if (resp is Success) {
      Dialogs.success(msg: 'Solicitud de tasación creada');
      currentForm = 1;
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: 'su sesión a expirado');
      Navigator.pushNamedAndRemoveUntil(
          context, LoginView.routeName, (route) => false);
    }
    ProgressDialog.dissmiss(context);
  }
}
