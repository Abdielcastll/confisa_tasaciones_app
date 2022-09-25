import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasaciones_app/core/api/alarmas.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/descripcion_foto_vehiculo.dart';
import 'package:tasaciones_app/core/models/ediciones_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_disponibles_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/tracciones_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';
import 'package:tasaciones_app/core/models/versiones_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/vin_decoder_response.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import 'package:tasaciones_app/widgets/escaner.dart';

import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../core/utils/create_file_from_string.dart';
import '../../auth/login/login_view.dart';

class SolicitudEstimacionViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final _authenticationAPI = locator<AuthenticationClient>();
  final _usuarioApi = locator<UserClient>();
  final _alarmasApi = locator<AlarmasApi>();
  final _adjuntosApi = locator<AdjuntosApi>();
  late DateTime fechaActual;
  String? _estado;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyFotos = GlobalKey<FormState>();
  TextEditingController tcNoSolicitud = TextEditingController();
  TextEditingController tcVIN = TextEditingController();
  TextEditingController tcFuerzaMotriz = TextEditingController();
  TextEditingController tcKilometraje = TextEditingController();
  TextEditingController tcPlaca = TextEditingController();
  int _currentForm = 1;
  List<AlarmasData> alarmas = [];
  SolicitudCreditoData? solicitud;

  VinDecoderData? _vinData;
  AlarmasResponse? alarmasResponse;
  TipoVehiculoData? _tipoVehiculos;
  EdicionVehiculo? _edicionVehiculos;
  TransmisionesData? _transmision;
  VersionVehiculoData? _versionVehiculo;
  TraccionesData? _traccion;
  int? _nPuertas;
  int? _nCilindros;
  ColorVehiculo? _colorVehiculo;
  late int _fotosPermitidas;
  late List<AdjuntoFoto> fotos;
  final _picker = ImagePicker();
  SolicitudesData? solicitudCola;
  SolicitudesData? solicitudCreada;

  SolicitudEstimacionViewModel() {
    fechaActual = DateTime.now();
  }

  VinDecoderData? get vinData => _vinData;
  set vinData(VinDecoderData? data) {
    _vinData = data;
    notifyListeners();
  }

  int get currentForm => _currentForm;
  set currentForm(int i) {
    _currentForm = i;
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

  EdicionVehiculo get edicionVehiculo => _edicionVehiculos!;

  set edicionVehiculo(EdicionVehiculo? value) {
    _edicionVehiculos = value;
    notifyListeners();
  }

  TransmisionesData get transmision => _transmision!;

  set transmision(TransmisionesData? value) {
    _transmision = value;
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

  Future<void> getAlarmas() async {
    var resp = await _alarmasApi.getAlarmas(idSolicitud: solicitudCreada!.id);
    if (resp is Success<AlarmasResponse>) {
      alarmasResponse = resp.response;
      alarmas = resp.response.data;
    } else if (resp is Failure) {
      Dialogs.error(msg: resp.messages.first);
    }
  }

  void onInit(SolicitudesData? arg) async {
    if (arg != null) {
      solicitudCola = arg;
      tcNoSolicitud.text = arg.noSolicitudCredito.toString();

      notifyListeners();
    }
  }

  late SolicitudesDisponibles _solicitudDisponible;
  SolicitudesDisponibles get solicitudDisponible => _solicitudDisponible;
  set solicitudDisponible(SolicitudesDisponibles v) {
    _solicitudDisponible = v;
    notifyListeners();
  }

  Future<void> solicitudCredito(BuildContext context) async {
    // if (solicitudCola == null) {
    if (formKey.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _solicitudesApi.getSolicitudCredito(
          idSolicitud: _solicitudDisponible.noSolicitud!);
      if (resp is Success) {
        var data = resp.response as SolicitudCreditoResponse;
        solicitud = data.data;
        // currentForm = 2;
        int currentYear = DateTime.now().year;
        if (data.data.ano != null) {
          int anio = int.tryParse(data.data.ano!)!;
          if (currentYear <= anio) {
            _estado = 'NUEVO';
            notifyListeners();
          } else {
            _estado = 'USADO';
            notifyListeners();
          }
        } else {
          _estado = '';
          notifyListeners();
        }
        ProgressDialog.dissmiss(context);
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
        ProgressDialog.dissmiss(context);
      }
      if (resp is TokenFail) {
        ProgressDialog.dissmiss(context);
        Dialogs.error(msg: 'su sesión a expirado');
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
    }
    // }
  }

  Future<void> consultarVIN(BuildContext context) async {
    if (formKey2.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _solicitudesApi.getVinDecoder(
          chasisCode: tcVIN.text,
          noSolicitud: solicitudCola != null
              ? solicitudCola!.noSolicitudCredito!
              : solicitud!.noSolicitud!);
      if (resp is Success) {
        var data = resp.response as VinDecoderResponse;
        vinData = data.data;

        int currentYear = DateTime.now().year;
        if (data.data.ano != null) {
          int anio = data.data.ano!;
          if (currentYear <= anio) {
            _estado = 'NUEVO';
            notifyListeners();
          } else {
            _estado = 'USADO';
            notifyListeners();
          }
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

  String? noSolicitudValidator(String? value) {
    if (value?.trim() == '') {
      return 'Ingrese el número de solicitud';
    } else {
      return null;
    }
  }

  String? noVINValidator(String? value) {
    if (value?.trim() == '') {
      return 'Ingrese el número VIN';
    } else {
      return null;
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

  Future<List<EdicionVehiculo>> getEdiciones(String text) async {
    var resp = await _solicitudesApi.getEdicionesVehiculos(
        modeloid: solicitud!.idModeloTasaciones!);
    if (resp is Success<List<EdicionVehiculo>>) {
      return resp.response;
    } else {
      return [];
    }
  }

  Future<List<TipoFotoVehiculos>> getDescripcionFotos(String text) async {
    var resp = await _solicitudesApi.getTipoFotosVehiculos();
    if (resp is Success<List<TipoFotoVehiculos>>) {
      return resp.response;
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

  Future<List<SolicitudesDisponibles>> getSolicitudes() async {
    var resp = await _solicitudesApi.getSolicitudesDisponibles();
    if (resp is Success<List<SolicitudesDisponibles>>) {
      return resp.response;
    } else {
      return [];
    }
  }

  void cargarFoto(int i) async {
    var img = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
    );
    if (img != null) {
      final foto = File(img.path);
      final fotoBase = base64Encode(foto.readAsBytesSync());
      fotos[i] = fotos[i].copyWith(adjunto: fotoBase);
      notifyListeners();
    }
  }

  void borrarFoto(int i) async {
    fotos[i] = AdjuntoFoto();
    notifyListeners();
  }

  Future<void> subirFotos(BuildContext context) async {
    if (formKeyFotos.currentState!.validate()) {
      ProgressDialog.show(context);

      List<Map<String, dynamic>> dataList = [];

      for (var e in fotos) {
        if (e.id == null && e.adjunto != null) {
          Map<String, dynamic> data = {
            "adjuntoInBytes": e.adjunto,
            "tipoAdjunto": e.tipoAdjunto,
            "descripcion": e.descripcion,
          };

          dataList.add(data);
        }
      }

      var resp = await _adjuntosApi.addFotosTasacion(
          noTasacion: solicitudCreada!.noTasacion!, adjuntos: dataList);

      if (resp is Success) {
        Dialogs.success(msg: 'Fotos guardadas');
        ProgressDialog.dissmiss(context);
        currentForm = 4;
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
        ProgressDialog.dissmiss(context);
      }
      if (resp is TokenFail) {
        ProgressDialog.dissmiss(context);
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'su sesión a expirado');
      }
      // }
    }
  }

  Future<void> cargarAlarmas() async {
    Session data = _authenticationAPI.loadSession;
    Profile perfil = _usuarioApi.loadProfile;
    Object respalarm;
    data.role.any((element) => element == "AprobadorTasaciones")
        ? respalarm = await _alarmasApi.getAlarmas()
        : respalarm = await _alarmasApi.getAlarmas(usuario: perfil.id!);
    if (respalarm is Success) {
      alarmasResponse = respalarm.response as AlarmasResponse;
      alarmas = alarmasResponse!.data;
    }
    if (respalarm is Failure) {
      Dialogs.error(msg: respalarm.messages[0]);
    }
    if (respalarm is TokenFail) {
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
  }

  Future<void> editarFoto(int i) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: await createFileFromString(fotos[i].adjunto!),
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
    if (croppedFile != null) {
      var fotoByte = File(croppedFile.path).readAsBytesSync();
      fotos[i] = fotos[i].copyWith(adjunto: base64Encode(fotoByte));

      notifyListeners();
    }
  }

  Future goToFotos(BuildContext context) async {
    if (vinData == null) {
      Dialogs.error(msg: 'Debe consultar el No. VIN');
    } else {
      if (formKey3.currentState!.validate()) {
        ProgressDialog.show(context);
        int? idSuplidor = await crearSolicitud(context);
        if (idSuplidor != null) {
          log.i('ID SUPLIDOR $idSuplidor');
          var resp =
              await _solicitudesApi.getCantidadFotos(idSuplidor: idSuplidor);
          if (resp is Success<EntidadResponse>) {
            int cantidad = int.parse(resp.response.data.descripcion ?? '0');
            fotos = List.generate(cantidad, (i) => AdjuntoFoto(nueva: true));
            fotosPermitidas = cantidad;
            await getAlarmas();
            currentForm = 3;
            ProgressDialog.dissmiss(context);
          }
        }
      }
    }
  }

  Future<int?> crearSolicitud(BuildContext context) async {
    var resp = await _solicitudesApi.createNewSolicitudEstimacion(
      ano: int.parse(solicitud!.ano!),
      chasis: solicitud!.chasis ?? tcVIN.text,
      color: colorVehiculo.id,
      edicion: edicionVehiculo.id,
      fuerzaMotriz: vinData?.fuerzaMotriz ?? int.parse(tcFuerzaMotriz.text),
      kilometraje: int.parse(tcKilometraje.text),
      marca: solicitud!.idMarcaTasaciones ?? vinData!.codigoMarca ?? 0,
      modelo: solicitud!.idModeloTasaciones ?? vinData!.codigoModelo ?? 0,
      noCilindros: vinData?.numeroCilindros ?? _nCilindros!,
      noPuertas: vinData?.numeroPuertas ?? _nPuertas!,
      noSolicitudCredito: solicitud!.noSolicitud!,
      nuevoUsado: _estado == 'Nuevo' ? 1 : 2,
      placa: tcPlaca.text,
      serie: vinData?.idSerie,
      sistemaTransmision: _transmision!.id,
      tipoTasacion: 21,
      tipoVehiculoLocal: tipoVehiculo.id,
      traccion: _traccion!.id,
      trim: vinData?.idTrim,
      versionLocal: versionVehiculo.id, /* INFO VEHICULOGET VERSIONES   */
    );
    if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages[0]);
      // resetData();

      // TODO::: Cambiar a false
      return null;
    }
    if (resp is TokenFail) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      return null;
    }
    if (resp is Success<SolicitudesData>) {
      Dialogs.success(msg: 'Solicitud creada correctamente');
      solicitudCreada = resp.response;
      var suplidor = resp.response.suplidorTasacion;
      getAlarmas();
      notifyListeners();
      return suplidor;
    }
    resetData();
    return null;
  }

  Future<void> escanearVIN() async {
    _navigatorService.navigateToPage(EscanerPage.routeName).then((value) {
      tcVIN.text = value;
      notifyListeners();
    });
  }

  void resetData() {
    tcVIN.clear();
    tcPlaca.clear();
    tcNoSolicitud.clear();
    tcFuerzaMotriz.clear();
    tcKilometraje.clear();
  }

  Future<void> enviarSolicitud(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _solicitudesApi.updateSentToProcess(
        noTasacion: solicitudCreada!.noTasacion!);
    if (resp is Success) {
      Dialogs.success(msg: 'Solicitud enviada');
      ProgressDialog.dissmiss(context);
      Navigator.of(context).pop(true);
    }
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

  @override
  void dispose() {
    tcVIN.dispose();
    tcPlaca.dispose();
    tcNoSolicitud.dispose();
    tcFuerzaMotriz.dispose();
    tcKilometraje.dispose();

    super.dispose();
  }

  void goToVehiculo(BuildContext context) {
    if (solicitud == null) {
      Dialogs.error(msg: 'Consulte No. de solicitud');
    } else {
      currentForm = 2;
    }
  }
}

// class FotoData {
//   File? file;
//   int? tipoAdjunto;
//   TipoFotoVehiculos? descripcion;
//   FotoData({
//     this.file,
//     this.tipoAdjunto,
//     this.descripcion,
//   });
// }
