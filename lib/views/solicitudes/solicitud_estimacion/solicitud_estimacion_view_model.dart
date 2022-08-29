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
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/tracciones_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';
import 'package:tasaciones_app/core/models/versiones_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/vin_decoder_response.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/solicitudes/cola_solicitudes/cola_solicitudes_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import 'package:tasaciones_app/widgets/escaner.dart';

import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../auth/login/login_view.dart';
import '../../home/home_view.dart';

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
  TextEditingController tcNoSolicitud = TextEditingController();
  TextEditingController tcVIN =
      TextEditingController(text: '1GNFK13047R140555');
  TextEditingController tcFuerzaMotriz = TextEditingController();
  TextEditingController tcKilometraje = TextEditingController();
  TextEditingController tcPlaca = TextEditingController();
  int _currentForm = 1;
  List<AlarmasData> alarmas = [];
  SolicitudCreditoData? solicitud;

  VinDecoderData? _vinData;
  AlarmasResponse? alarmasResponse;
  TipoVehiculoData? _tipoVehiculos;
  TransmisionesData? _transmision;
  VersionVehiculoData? _versionVehiculo;
  TraccionesData? _traccion;
  int? _nPuertas;
  int? _nCilindros;
  ColorVehiculo? _colorVehiculo;
  late int _fotosPermitidas;
  // late List<File> fotos;
  late List<FotoData> fotos;
  final _picker = ImagePicker();
  SolicitudesData? solicitudCola;

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

  void onInit(SolicitudesData? arg) {
    if (arg != null) {
      solicitudCola = arg;
      tcNoSolicitud.text = arg.noSolicitudCredito.toString();
      tcVIN.text = arg.chasis!;
      notifyListeners();
    }
  }

  Future<void> solicitudCredito(BuildContext context) async {
    if (solicitudCola == null) {
      if (formKey.currentState!.validate()) {
        ProgressDialog.show(context);
        var resp = await _solicitudesApi.getSolicitudCredito(
            idSolicitud: int.parse(tcNoSolicitud.text));
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
    } else {
      currentForm = 2;
    }
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
        if (data.data.ano != '') {
          int anio = int.parse(data.data.ano!);
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

  Future<void> subirFotos() async {
    List<Map<String, dynamic>> dataList = [];
    for (var e in fotos) {
      var fotoBase = e.file!.readAsBytesSync().toList();
      Map<String, dynamic> data = {
        "adjuntoInBytes": fotoBase,
        "tipoAdjunto": 0,
        "descripcion": e.descripcion,
      };
      dataList.add(data);
    }
    var resp = await _adjuntosApi.addFotosTasacion(
        noTasacion: solicitud!.noSolicitud!, adjuntos: dataList);

    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'su sesión a expirado');
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

  Future goToFotos(BuildContext context) async {
    if (vinData == null) {
      Dialogs.error(msg: 'Debe consultar el No. VIN');
    } else {
      if (formKey3.currentState!.validate()) {
        // ProgressDialog.show(context);
        await crearSolicitud(context);
        var resp = await _solicitudesApi.getCantidadFotos();
        if (resp is Success) {
          var data = resp.response as EntidadResponse;
          int cantidad = int.parse(data.data.descripcion ?? '0');
          fotos = List.generate(cantidad, (i) => FotoData(file: File('')));
          fotosPermitidas = cantidad;
          currentForm = 3;
          // ProgressDialog.dissmiss(context);
        }
        print('VALIDO');
      }
    }
  }

  Future<bool> crearSolicitud(BuildContext context) async {
    // if (fotos.any((e) => e.file!.path == '') ||
    //     fotos.any((e) => e.descripcion == '')) {
    //   Dialogs.error(msg: 'Debe cargar todas las fotos');
    // } else {
    ProgressDialog.show(context);
    var resp = await _solicitudesApi.createNewSolicitudEstimacion(
      ano: int.parse(solicitud!.ano!),
      chasis: solicitud!.chasis ?? tcVIN.text,
      codigoEntidad: solicitud!.codEntidad!,
      codigoSucursal: solicitud!.codSucursal!,
      color: colorVehiculo.id,
      edicion: vinData?.idTrim ?? 0,
      fuerzaMotriz: vinData?.fuerzaMotriz != null && vinData?.fuerzaMotriz != ''
          ? int.parse(vinData?.fuerzaMotriz ?? '')
          : int.parse(tcFuerzaMotriz.text),
      idOficial: solicitud!.codOficialNegocios!,
      // idPromotor: 0,
      identificacion: solicitud!.noIdentificacion!,
      kilometraje: int.parse(tcKilometraje.text),
      marca: solicitud!.idMarcaTasaciones ?? vinData!.codigoMarca ?? 0,
      modelo: solicitud!.idModeloTasaciones ?? vinData!.codigoModelo ?? 0,
      noCilindros: _nCilindros!,
      noPuertas: _nPuertas!,
      noSolicitudCredito: solicitud!.noSolicitud!,
      nombreCliente: solicitud!.nombreCliente!,
      nuevoUsado: _estado == 'Nuevo' ? 0 : 1,
      placa: tcPlaca.text,
      serie: vinData?.idSerie!,
      sistemaTransmision: _transmision!.id,
      // suplidorTasacion: 0,
      tipoTasacion: 21,
      tipoVehiculoLocal: tipoVehiculo.id,
      traccion: _traccion!.id,
      trim: vinData?.idTrim,
      versionLocal: versionVehiculo.id, /* INFO VEHICULOGET VERSIONES   */
    );
    if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages[0]);
      return false;
    }
    if (resp is TokenFail) {
      ProgressDialog.dissmiss(context);
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'su sesión a expirado');
      return false;
    }
    if (resp is Success) {
      print('SUCCESS');
      // await subirFotos();
      ProgressDialog.dissmiss(context);
      Dialogs.success(msg: 'Solicitud creada correctamente');
      return true;
      // _navigatorService
      //     .navigateToPageAndRemoveUntil(ColaSolicitudesView.routeName);
    }
    return false;
  }

  Future<void> escanearVIN() async {
    _navigatorService.navigateToPage(EscanerPage.routeName).then((value) {
      tcVIN.text = value;
      notifyListeners();
    });
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
}

class FotoData {
  File? file;
  int? tipoAdjunto;
  String? descripcion;
  FotoData({
    this.file,
    this.tipoAdjunto,
    this.descripcion,
  });
}
