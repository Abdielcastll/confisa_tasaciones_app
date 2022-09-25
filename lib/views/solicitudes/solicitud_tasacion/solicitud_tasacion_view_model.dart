import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/personal_api.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/models/solicitudes/solicitudes_disponibles_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../auth/login/login_view.dart';

class SolicitudTasacionViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final _personalApi = locator<PersonalApi>();

  late DateTime fechaActual;
  String? _numeroSolicitud;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  int _currentForm = 1;
  late SolicitudCreditoData solicitud;
  late bool incautado;

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

  void onInit({bool t = false}) {
    incautado = t;
    notifyListeners();
  }

  late SolicitudesDisponibles _solicitudDisponible;
  SolicitudesDisponibles get solicitudDisponible => _solicitudDisponible;
  set solicitudDisponible(SolicitudesDisponibles v) {
    _solicitudDisponible = v;
    notifyListeners();
  }

  Future<List<SolicitudesDisponibles>> getSolicitudes() async {
    var resp = await _solicitudesApi.getSolicitudesDisponibles();
    if (resp is Success<List<SolicitudesDisponibles>>) {
      return resp.response;
    } else {
      return [];
    }
  }

  Future<void> solicitudCredito(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      ProgressDialog.show(context);

      var resp = await _solicitudesApi.getSolicitudCredito(
          idSolicitud: _solicitudDisponible.noSolicitud!);
      if (resp is Success) {
        var data = resp.response as SolicitudCreditoResponse;
        solicitud = data.data;
        currentForm = 2;
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        // ProgressDialog.dissmiss(context);
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
    // print('idOficial: ${solicitud.codOficialNegocios}');
    ProgressDialog.show(context);
    var user = await _personalApi.getProfile();
    if (user is Success<ProfileResponse>) {}
    var resp = await _solicitudesApi.createNewSolicitudTasacion(
      codigoEntidad: solicitud.codEntidad!,
      codigoSucursal: solicitud.codSucursal!,
      idOficial: solicitud.codOficialNegocios!,
      identificacion: solicitud.noIdentificacion!,
      noSolicitudCredito: solicitud.noSolicitud!,
      nombreCliente: solicitud.nombreCliente!,
      tipoTasacion: incautado ? 23 : 22,
      // suplidorTasacion: 0,
    );
    if (resp is Success) {
      ProgressDialog.dissmiss(context);
      Dialogs.success(msg: 'Solicitud de tasación creada');
      Navigator.of(context).pop(true);
    }
    if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: 'su sesión a expirado');
      Navigator.of(context).pop();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginView.routeName, (route) => false);
    }
  }
}
