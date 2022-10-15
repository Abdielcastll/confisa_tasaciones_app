import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/facturacion/detalle_aprobacion_factura.dart';
import 'package:tasaciones_app/core/models/facturacion/detalle_factura.dart';
import 'package:tasaciones_app/core/models/facturacion/factura_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/views/facturacion/cola_facturacion/widgets/detalle_factura.dart';

import '../../../core/api/api_status.dart';
import '../../../core/api/facturaciones_api/facturacion_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/reporte_response.dart';
import '../../../core/models/sign_in_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../core/user_client.dart';
import '../../../widgets/app_dialogs.dart';
import '../../../widgets/view_pdf.dart';

class ColaFacturacionViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _facturacionApi = locator<FacturacionApi>();
  final _authenticationAPI = locator<AuthenticationClient>();
  final _userClient = locator<UserClient>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Factura> facturas = [];
  List<Factura> facturasData = [];
  TextEditingController tcBuscar = TextEditingController();
  // TextEditingController tcNCf = TextEditingController();
  MaskedTextController tcNCf = MaskedTextController(mask: 'A0000000000');
  bool isAprobTasacion = false;
  bool isAprobFacturas = false;
  bool _loading = true;
  bool _busqueda = false;
  Profile? profile;
  late int idFactura;
  late DetalleFactura detalleFactura;
  late List<DetalleAprobacionFactura> detalleAprobacionFactura;
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
    profile = _userClient.loadProfile;
    var resp = await _facturacionApi.getFacturas();
    if (resp is Success<List<Factura>>) {
      facturas = resp.response;
      facturasData = resp.response;
      Session session = _authenticationAPI.loadSession;
      isAprobTasacion = session.role.contains("AprobadorTasaciones");
      isAprobFacturas = session.role.contains("AprobadorFacturas");
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
    var r = await _facturacionApi.getDetalleFactura(noFactura: f.noFactura!);
    if (r is Success<DetalleFactura>) {
      detalleFactura = r.response;
      tcNCf.updateText(detalleFactura.ncf);
      var d =
          await _facturacionApi.getDetalleAprobacionFactura(idFactura: f.id!);
      if (d is Success<List<DetalleAprobacionFactura>>) {
        detalleAprobacionFactura = d.response;
        idFactura = f.id!;

        _navigatorService.navigatorKey.currentState!
            .push(CupertinoPageRoute(builder: (_) {
          return DetalleFacturaPage(
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
        ProgressDialog.dissmiss(context);
      } else {
        Dialogs.success(msg: 'NCF Actualizado');
        await onInit();
        ProgressDialog.dissmiss(context);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> aprobarFactura(BuildContext context,
      {required int noFactura}) async {
    ProgressDialog.show(context);
    var resp = await _facturacionApi.aprobar(noFactura: noFactura);
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
      ProgressDialog.dissmiss(context);
    } else {
      Dialogs.success(msg: 'Factura Aprobada');
      var d = await _facturacionApi.getDetalleAprobacionFactura(
          idFactura: idFactura);
      if (d is Success<List<DetalleAprobacionFactura>>) {
        detalleAprobacionFactura = d.response;
        notifyListeners();
      }
      ProgressDialog.dissmiss(context);
      // await onInit();
    }
  }

  Future<void> rechazarFactura(BuildContext context,
      {required int noFactura}) async {
    ProgressDialog.show(context);
    var resp = await _facturacionApi.rechazar(noFactura: noFactura);
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
      ProgressDialog.dissmiss(context);
    } else {
      Dialogs.success(msg: 'Factura Rechazada');
      var d = await _facturacionApi.getDetalleAprobacionFactura(
          idFactura: idFactura);
      if (d is Success<List<DetalleAprobacionFactura>>) {
        detalleAprobacionFactura = d.response;
        notifyListeners();
      }
      ProgressDialog.dissmiss(context);
      // await onInit();
    }
  }

  Future<void> goToReporte(BuildContext context, int idFactura) async {
    ProgressDialog.show(context);
    var resp = await _facturacionApi.reportesFactura(idFactura: idFactura);
    if (resp is Success<Reporte>) {
      ProgressDialog.dissmiss(context);
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return AppPdfViewer(resp.response);
      }));
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
      ProgressDialog.dissmiss(context);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      ProgressDialog.dissmiss(context);
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  @override
  void dispose() {
    tcBuscar.dispose();
    tcNCf.dispose();
    super.dispose();
  }
}
