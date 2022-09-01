import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/componente_tasacion_response.dart';
import 'package:tasaciones_app/core/models/descripcion_foto_vehiculo.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/adjunto_foto_response.dart';
import '../../../core/models/cantidad_fotos_response.dart';
import '../../../core/models/colores_vehiculos_response.dart';
import '../../../core/models/componente_condicion.dart';
import '../../../core/models/ediciones_vehiculo_response.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/models/tipo_vehiculo_response.dart';
import '../../../core/models/tracciones_response.dart';
import '../../../core/models/transmisiones_response.dart';
import '../../../core/models/versiones_vehiculo_response.dart';
import '../../../core/models/vin_decoder_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/escaner.dart';
import '../../auth/login/login_view.dart';
import '../solicitud_estimacion/solicitud_estimacion_view_model.dart';

class TrabajarViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final _adjuntosApi = locator<AdjuntosApi>();
  late DateTime fechaActual;
  String? _estado;
  int? _estadoID;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyFotos = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCondiciones = GlobalKey<FormState>();
  TextEditingController tcVIN = TextEditingController();
  TextEditingController tcFuerzaMotriz = TextEditingController();
  TextEditingController tcKilometraje = TextEditingController();
  TextEditingController tcPlaca = TextEditingController();
  List<AdjuntoFoto> fotosAdjuntos = [];
  int _currentForm = 1;
  late SolicitudesData solicitud;
  VinDecoderData? _vinData;
  TipoVehiculoData? _tipoVehiculos;
  TransmisionesData? _transmision;
  VersionVehiculoData? _versionVehiculo;
  TraccionesData? _traccion;
  int? _nPuertas;
  EdicionVehiculo? _edicionVehiculos;
  int? _nCilindros;
  ColorVehiculo? _colorVehiculo;
  late int _fotosPermitidas;
  late List<FotoData> fotos;
  final _picker = ImagePicker();
  List<DescripcionFotoVehiculos> descripcionFotos = [];
  SolicitudCreditoData? solicitudData;
  List<ComponenteTasacion> componentes = [];
  List<CondicionComponenteVehiculoCreate> condicionesData = [];

  int get currentForm => _currentForm;
  set currentForm(int i) {
    _currentForm = i;
    notifyListeners();
  }

  VinDecoderData? get vinData => _vinData;
  set vinData(VinDecoderData? data) {
    _vinData = data;
    notifyListeners();
  }

  int? get nPuertas => _nPuertas;
  set nPuertas(int? i) {
    _nPuertas = i;
    notifyListeners();
  }

  int? get nCilindros => _nCilindros;
  set nCilindros(int? i) {
    _nCilindros = i;
    notifyListeners();
  }

  String? get estado => _estado;

  TipoVehiculoData get tipoVehiculo => _tipoVehiculos!;

  set tipoVehiculo(TipoVehiculoData? value) {
    _tipoVehiculos = value;
    notifyListeners();
  }

  VersionVehiculoData get versionVehiculo => _versionVehiculo!;

  set versionVehiculo(VersionVehiculoData? value) {
    _versionVehiculo = value;
    notifyListeners();
  }

  TransmisionesData get transmision => _transmision!;

  set transmision(TransmisionesData? value) {
    _transmision = value;
    notifyListeners();
  }

  EdicionVehiculo get edicionVehiculo => _edicionVehiculos!;

  set edicionVehiculo(EdicionVehiculo? value) {
    _edicionVehiculos = value;
    notifyListeners();
  }

  TraccionesData get traccion => _traccion!;

  set traccion(TraccionesData? value) {
    _traccion = value;
    notifyListeners();
  }

  ColorVehiculo get colorVehiculo => _colorVehiculo!;

  set colorVehiculo(ColorVehiculo? value) {
    _colorVehiculo = value;
    notifyListeners();
  }

  int get fotosPermitidas => _fotosPermitidas;
  set fotosPermitidas(int i) {
    _fotosPermitidas = i;
    notifyListeners();
  }

  void onInit(BuildContext context, SolicitudesData? arg) async {
    if (arg != null) {
      solicitud = arg;
      // tcVIN.text = solicitud.chasis ?? '';
      // tcFuerzaMotriz.text = solicitud.fuerzaMotriz?.toString() ?? '';
      // tcKilometraje.text = solicitud.kilometraje?.toString() ?? '';
      // tcPlaca.text = solicitud.placa ?? '';
      // notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));
      solicitudCredito(context);
    }
  }

  Future<List<EdicionVehiculo>> getEdiciones(String text) async {
    var resp = await _solicitudesApi.getEdicionesVehiculos(
        modeloid: solicitudData?.idModeloTasaciones ?? 0);
    if (resp is Success<List<EdicionVehiculo>>) {
      return resp.response;
    } else {
      return [];
    }
  }

  Future<void> solicitudCredito(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _solicitudesApi.getSolicitudCredito(
      idSolicitud: solicitud.noSolicitudCredito!,
    );
    if (resp is Success<SolicitudCreditoResponse>) {
      solicitudData = resp.response.data;
      tcVIN.text = solicitudData?.chasis ?? '';
      notifyListeners();
      // currentForm = 2;
      ProgressDialog.dissmiss(context);
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

  Future<void> consultarVIN(BuildContext context) async {
    if (formKey2.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _solicitudesApi.getVinDecoder(
        chasisCode: tcVIN.text,
        noSolicitud: solicitud.noSolicitudCredito!,
      );
      if (resp is Success) {
        var data = resp.response as VinDecoderResponse;
        vinData = data.data;
        int currentYear = DateTime.now().year;
        if (data.data.ano != null) {
          int anio = data.data.ano!;
          if (currentYear <= anio) {
            _estado = 'NUEVO';
            _estadoID = 0;
            notifyListeners();
          } else {
            _estadoID = 1;
            _estado = 'USADO';
            notifyListeners();
          }
        } else {
          _estado = '';
          notifyListeners();
        }
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        _navigatorService.pop();
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'su sesión a expirado');
      }
      ProgressDialog.dissmiss(context);
    }
  }

  Future<void> escanearVIN() async {
    _navigatorService.navigateToPage(EscanerPage.routeName).then((value) {
      tcVIN.text = value;
      notifyListeners();
    });
  }

  Future goToCondiciones(BuildContext context) async {
    if (formKey3.currentState!.validate()) {
      if (vinData == null) {
        Dialogs.error(msg: 'Debe consultar el No. VIN');
      } else {
        ProgressDialog.show(context);
        var upResp = await _solicitudesApi.updateEstimacion(
          id: solicitud.id!,
          sistemaTransmision: transmision.id,
          traccion: traccion.id,
          noPuertas: nPuertas!,
          noCilindros: nCilindros!,
          fuerzaMotriz: double.tryParse(tcFuerzaMotriz.text)!.round(),
          ano: solicitud.ano ?? vinData?.ano ?? 0,
          nuevoUsado: _estadoID ?? 0,
          kilometraje: double.tryParse(tcKilometraje.text)!.round(),
          // kilometraje: double.tryParse(tcKilometraje.text)!.round(),
          color: colorVehiculo.id,
          placa: tcPlaca.text,
        );
        if (upResp is Success) {
          Dialogs.success(msg: 'Datos actualizados');
          var resp = await _solicitudesApi.getComponentesTasacion();
          if (resp is Success<List<ComponenteTasacion>>) {
            componentes = resp.response;
            currentForm = 3;
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
        if (upResp is Failure) {
          Dialogs.error(msg: upResp.messages[0]);
          ProgressDialog.dissmiss(context);
        }
      }
    }
  }

  void addCondicion(CondicionComponente? c) {
    condicionesData.add(CondicionComponenteVehiculoCreate(
        c!.idComponente!, c.idCondicionParametroG!));
  }

  Future<void> goToAccesorios(BuildContext context) async {
    if (formKeyCondiciones.currentState!.validate()) {
      ProgressDialog.show(context);
      Map<String, dynamic> data = {
        "idSolicitud": solicitud.noSolicitudCredito,
        "condicionesComponenteVehiculo": List.from(
          condicionesData.map((x) => x.toJson()),
        ),
      };
      log.d(jsonEncode(data));
      var resp = await _solicitudesApi.createCondicionComponente(data: data);
      if (resp is Success) {
        currentForm = 4;
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        Dialogs.error(msg: 'su sesión a expirado');
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
      ProgressDialog.dissmiss(context);
    }
  }

  Future goToFotos(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _adjuntosApi.getFotosTasacion(noTasacion: 100013);
    if (resp is Success<AdjuntosFotoResponse>) {
      fotosAdjuntos = resp.response.data;
      currentForm = 4;
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    ProgressDialog.dissmiss(context);
  }

  Future goToFotosTasacion(BuildContext context) async {
    if (vinData == null) {
      Dialogs.error(msg: 'Debe consultar el No. VIN');
    } else {
      var resp = await _solicitudesApi.getCantidadFotos();
      if (resp is Success) {
        var data = resp.response as EntidadResponse;
        int cantidad = int.parse(data.data.descripcion ?? '0');
        fotos = List.generate(cantidad, (i) => FotoData(file: File('')));
        fotosPermitidas = cantidad;
        currentForm = 3;
        ProgressDialog.dissmiss(context);
      }
    }
  }

  String? noSolicitudValidator(String? value) {
    if (value?.trim() == '') {
      return 'Ingrese el número de solicitud';
    } else {
      return null;
    }
  }

  Future<void> editarFoto(int i) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: fotos[i].file!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar foto',
          toolbarColor: AppColors.orange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Editar foto',
        ),
      ],
    );
    fotos[i] = FotoData(file: File(croppedFile!.path));
    notifyListeners();
  }

  String? noVINValidator(String? value) {
    if (value?.trim() == '') {
      return 'Ingrese el número VIN';
    } else {
      return null;
    }
  }

  Future<List<CondicionComponente>> getCondiciones(
      {required int idComponente}) async {
    var resp = await _solicitudesApi.getCondicionComponente(
        idComponente: idComponente);
    if (resp is Success<List<CondicionComponente>>) {
      return resp.response;
    } else {
      return [];
    }
  }

  Future<List<TipoVehiculoData>> getTipoVehiculo(String text) async {
    var resp = await _solicitudesApi.getTipoVehiculo(text);
    if (resp is Success) {
      var data = resp.response as TipoVehiculoResponse;
      return data.data;
    } else {
      return [];
    }
  }

  Future<List<VersionVehiculoData>> getversionVehiculo(String text) async {
    var resp = await _solicitudesApi.getVersionVehiculo();
    if (resp is Success) {
      var data = resp.response as VersionesVehiculoResponse;
      return data.data;
    } else {
      return [];
    }
  }

  Future<List<TransmisionesData>> getTransmisiones(String text) async {
    var resp = await _solicitudesApi.getSistemaDeCambios();
    if (resp is Success) {
      var data = resp.response as TransmisionesResponse;
      return data.data;
    } else {
      return [];
    }
  }

  Future<List<TraccionesData>> getTracciones(String text) async {
    var resp = await _solicitudesApi.getTraccion();
    if (resp is Success) {
      var data = resp.response as TraccionesResponse;
      return data.data;
    } else {
      return [];
    }
  }

  Future<List<ColorVehiculo>> getColores(String text) async {
    var resp = await _solicitudesApi.getColores(text);
    if (resp is Success) {
      var data = resp.response as ColoresVehiculosResponse;
      return data.data;
    } else {
      return [];
    }
  }

  void cargarFoto(int i) async {
    var img = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (img != null) {
      fotos[i] = FotoData(file: File(img.path));

      // fotoBase = base64Encode(foto.readAsBytesSync());
      // log(fotoBase);
      // bytesImage = const Base64Decoder().convert(fotoBase);
      // data.img = fotoBase;
      notifyListeners();
    }
  }

  void borrarFoto(int i) {
    fotos[i] = FotoData(
      file: File(''),
      tipoAdjunto: null,
      descripcion: null,
    );
    notifyListeners();
  }

  Future<void> subirFotos(BuildContext context) async {
    if (fotos.any((e) => e.file!.path == '')) {
      Dialogs.error(msg: 'Fotos incompletas');
    } else {
      if (formKeyFotos.currentState!.validate()) {
        ProgressDialog.show(context);
        List<Map<String, dynamic>> dataList = [];
        for (var e in fotos) {
          var fotoBase = e.file!.readAsBytesSync();
          Map<String, dynamic> data = {
            "adjuntoInBytes": fotoBase,
            "tipoAdjunto": e.descripcion!.id,
            "descripcion": e.descripcion!.descripcion,
          };
          dataList.add(data);
        }
        var resp = await _adjuntosApi.addFotosTasacion(
            noTasacion: solicitud.noSolicitudCredito!, adjuntos: dataList);

        if (resp is Failure) {
          Dialogs.error(msg: resp.messages[0]);
          ProgressDialog.dissmiss(context);
        }
        if (resp is TokenFail) {
          ProgressDialog.dissmiss(context);
          _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
          Dialogs.error(msg: 'su sesión a expirado');
        }
      }
    }
  }
}

// class FotoData {
//   File? file;
//   int? tipoAdjunto;
//   DescripcionFotoVehiculos? descripcion;
//   FotoData({
//     this.file,
//     this.tipoAdjunto,
//     this.descripcion,
//   });
// }

class CondicionComponenteVehiculoCreate {
  int idComponenteVehiculo;
  int idCondicionComponenteVehiculo;

  CondicionComponenteVehiculoCreate(
      this.idComponenteVehiculo, this.idCondicionComponenteVehiculo);

  Map<String, dynamic> toJson() {
    return {
      "idComponenteVehiculo": idComponenteVehiculo,
      "idCondicionComponenteVehiculo": idCondicionComponenteVehiculo,
    };
  }
}
