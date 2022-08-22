import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/personal_api.dart';
import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/cantidad_fotos_response.dart';
import '../../../core/models/colores_vehiculos_response.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/models/tipo_vehiculo_response.dart';
import '../../../core/models/tracciones_response.dart';
import '../../../core/models/transmisiones_response.dart';
import '../../../core/models/vin_decoder_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../../auth/login/login_view.dart';

class ConsultarModificarViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final _personalApi = locator<PersonalApi>();
  final _adjuntosApi = locator<AdjuntosApi>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  int _currentForm = 1;
  VinDecoderData? _vinData;
  late SolicitudesData solicitudCola;
  late SolicitudCreditoData solicitud;

  TextEditingController tcFuerzaMotriz = TextEditingController();
  TextEditingController tcKilometraje = TextEditingController();
  TextEditingController tcPlaca = TextEditingController();
  TextEditingController tcVIN = TextEditingController();
  TipoVehiculoData? _tipoVehiculos;
  TransmisionesData? _transmision;
  TraccionesData? _traccion;
  String? _estado;
  int? _nPuertas;
  int? _nCilindros;
  ColorVehiculo? _colorVehiculo;
  // late List<File> fotos;
  List<AdjuntoFoto> fotosAdjuntos = [];
  final _picker = ImagePicker();

  ConsultarModificarViewModel();

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

  void onInit(SolicitudesData? data) {
    solicitudCola = data!;
    notifyListeners();
  }

  Future<void> solicitudCredito(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      ProgressDialog.show(context);

      var resp = await _solicitudesApi.getSolicitudCredito(
          idSolicitud: solicitudCola.noSolicitudCredito!);
      if (resp is Success<SolicitudCreditoResponse>) {
        solicitud = resp.response.data;
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

  Future<void> consultarVIN(BuildContext context) async {
    if (formKey2.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _solicitudesApi.getVinDecoder(
          chasisCode: tcVIN.text, noSolicitud: solicitud.noSolicitud!);
      if (resp is Success) {
        var data = resp.response as VinDecoderResponse;
        vinData = data.data;
        int currentYear = DateTime.now().year;
        int anio = int.parse(data.data.ano!);
        if (currentYear <= anio) {
          _estado = 'NUEVO';
          notifyListeners();
        } else {
          _estado = 'USADO';
          notifyListeners();
        }
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      if (resp is TokenFail) {
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'su sesión a expirado');
      }
      ProgressDialog.dissmiss(context);
    }
  }

  Future goToFotos(BuildContext context) async {
    if (vinData == null) {
      Dialogs.error(msg: 'Debe consultar el No. VIN');
    } else {
      ProgressDialog.show(context);
      var resp = await _adjuntosApi.getFotosTasacion(
          noTasacion: solicitudCola.noTasacion!);
      if (resp is Success<AdjuntosFotoResponse>) {
        fotosAdjuntos = resp.response.data;
        // fotos = List.generate(fotosAdjuntos.length, (i) => File(''));
        currentForm = 3;
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
      }
      // if (formKey3.currentState!.validate()) {
      //   ProgressDialog.show(context);
      //   var resp = await _solicitudesApi.getCantidadFotos();
      //   if (resp is Success<EntidadResponse>) {
      //     int cantidad = int.parse(resp.response.data.descripcion ?? '0');
      //     fotos = List.generate(cantidad, (i) => File(''));
      //     fotosPermitidas = cantidad;
      //     currentForm = 3;
      //     ProgressDialog.dissmiss(context);
      //   }
      //   print('VALIDO');
      // }
      ProgressDialog.dissmiss(context);
    }
  }

  // Future<void> guardarTasacion(BuildContext context) async {
  //   // print('idOficial: ${solicitud.codOficialNegocios}');
  //   ProgressDialog.show(context);
  //   var user = await _personalApi.getProfile();
  //   if (user is Success<ProfileResponse>) {}
  //   var resp = await _solicitudesApi.createNewSolicitudTasacion(
  //     codigoEntidad: solicitud.codEntidad!,
  //     codigoSucursal: solicitud.codSucursal!,
  //     idOficial: solicitud.codOficialNegocios!,
  //     identificacion: solicitud.noIdentificacion!,
  //     noSolicitudCredito: solicitud.noSolicitud!,
  //     nombreCliente: solicitud.nombreCliente!,
  //     tipoTasacion: 22,
  //     suplidorTasacion: 0,
  //   );
  //   if (resp is Success) {
  //     Dialogs.success(msg: 'Solicitud de tasación creada');
  //     currentForm = 1;
  //   }
  //   if (resp is Failure) {
  //     Dialogs.error(msg: resp.messages[0]);
  //   }
  //   if (resp is TokenFail) {
  //     ProgressDialog.dissmiss(context);
  //     Dialogs.error(msg: 'su sesión a expirado');
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, LoginView.routeName, (route) => false);
  //   }
  //   ProgressDialog.dissmiss(context);
  // }

  Future<List<TipoVehiculoData>> getTipoVehiculo(String text) async {
    var resp = await _solicitudesApi.getTipoVehiculo(text);
    if (resp is Success) {
      var data = resp.response as TipoVehiculoResponse;
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
      final foto = File(img.path);
      final fotoBase = base64Encode(foto.readAsBytesSync());
      fotosAdjuntos[i].adjunto = fotoBase;
      // log(fotoBase);
      // bytesImage = const Base64Decoder().convert(fotoBase);
      // data.img = fotoBase;
      notifyListeners();
    }
  }

  // Future<void> editarFoto(int i) async {
  //   var croppedFile = await ImageCropper().cropImage(
  //     sourcePath: fotos[i].path,
  //     aspectRatioPresets: [
  //       CropAspectRatioPreset.square,
  //       CropAspectRatioPreset.ratio3x2,
  //       CropAspectRatioPreset.original,
  //       CropAspectRatioPreset.ratio4x3,
  //       CropAspectRatioPreset.ratio16x9
  //     ],
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: 'Editar foto',
  //         toolbarColor: AppColors.orange,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.original,
  //         lockAspectRatio: false,
  //         showCropGrid: true,
  //       ),
  //       IOSUiSettings(
  //         title: 'Editar foto',
  //       ),
  //     ],
  //   );
  //   fotos[i] = File(croppedFile?.path ?? fotos[i].path);
  //   notifyListeners();
  // }

  void borrarFoto(int i) {
    fotosAdjuntos[i].adjunto = '';
    notifyListeners();
  }
}
