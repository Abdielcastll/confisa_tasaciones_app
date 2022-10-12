import 'package:flutter/cupertino.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/facturacion/detalle_aprobacion_factura.dart';
import 'package:tasaciones_app/core/models/facturacion/detalle_factura.dart';
import 'package:tasaciones_app/core/models/facturacion/factura_response.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/views/facturacion/cola_facturacion/widgets/detalle_factura.dart';

import '../../../core/api/api_status.dart';
import '../../../core/api/facturaciones_api/facturacion_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/sign_in_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../widgets/app_dialogs.dart';

class ColaFacturacionViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _facturacionApi = locator<FacturacionApi>();
  final _authenticationAPI = locator<AuthenticationClient>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Factura> facturas = [];
  List<Factura> facturasData = [];
  TextEditingController tcBuscar = TextEditingController();
  TextEditingController tcNCf = TextEditingController();
  bool isAprobTasacion = false;
  bool isAprobFacturas = false;
  bool _loading = true;
  bool _busqueda = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  MoneyFormatter fmf = MoneyFormatter(
      amount: 12345678.9012345,
      settings: MoneyFormatterSettings(
          symbol: 'RD\$',
          thousandSeparator: ',',
          decimalSeparator: '.',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 2,
          compactFormatType: CompactFormatType.short));

  Future<void> onInit() async {
    var resp = await _facturacionApi.getFacturas();
    if (resp is Success<List<Factura>>) {
      facturas = resp.response;
      facturasData = resp.response;
      Session session = _authenticationAPI.loadSession;
      isAprobTasacion = session.role.contains("AprobadorTasaciones");
      isAprobFacturas = session.role.contains("AprobadorFacturas");
      print(isAprobTasacion);
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

  Future<void> buscar(String query) async {
    loading = true;
    var resp = await _facturacionApi.getFacturas(
      pageSize: 0,
      noFactura: int.parse(query),
    );
    if (resp is Success<List<Factura>>) {
      facturas = resp.response;
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
    loading = false;
  }

  void limpiarBusqueda() {
    _busqueda = false;
    facturas = facturasData;
    notifyListeners();
    tcBuscar.clear();
  }

  void goToFactura(Factura f) async {
    loading = true;
    late DetalleFactura detalleFactura;
    late List<DetalleAprobacionFactura> detalleAprobacionFactura;
    var r = await _facturacionApi.getDetalleFactura(noFactura: f.noFactura!);
    if (r is Success<DetalleFactura>) {
      detalleFactura = r.response;
      var d =
          await _facturacionApi.getDetalleAprobacionFactura(idFactura: f.id!);
      if (d is Success<List<DetalleAprobacionFactura>>) {
        detalleAprobacionFactura = d.response;
        _navigatorService.navigatorKey.currentState!
            .push(CupertinoPageRoute(builder: (_) {
          return DetalleFacturaPage(
            detalleAprobacionFactura: detalleAprobacionFactura,
            detalleFactura: detalleFactura,
            vm: this,
            estado: f.idEstado!,
          );
        }));
        loading = false;
      }
      if (d is Failure) {
        loading = false;
        Dialogs.error(msg: d.messages[0]);
      }
      if (d is TokenFail) {
        Dialogs.error(msg: 'su sesión a expirado');
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
    }
    if (r is Failure) {
      loading = false;
      Dialogs.error(msg: r.messages[0]);
    }
    if (r is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  void actualizarNCF(BuildContext context, {required int noFactura}) async {
    if (formKey.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _facturacionApi.updateNCF(
          noFactura: noFactura, ncf: tcNCf.text.trim());
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      } else {
        Dialogs.success(msg: 'NCF Actualizado');
      }
      Navigator.of(context).pop();
    }
  }

  void aprobarFactura(BuildContext context, {required int noFactura}) async {
    ProgressDialog.show(context);
    var resp = await _facturacionApi.aprobar(noFactura: noFactura);
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    } else {
      Dialogs.success(msg: 'Factura Aprobada');
    }
    Navigator.of(context).pop();
  }

  void rechazarFactura(BuildContext context, {required int noFactura}) async {
    ProgressDialog.show(context);
    var resp = await _facturacionApi.rechazar(noFactura: noFactura);
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    } else {
      Dialogs.success(msg: 'Factura Rechazada');
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    tcBuscar.dispose();
    tcNCf.dispose();
    super.dispose();
  }
}
