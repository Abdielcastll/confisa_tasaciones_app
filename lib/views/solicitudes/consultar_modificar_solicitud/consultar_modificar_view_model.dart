import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasaciones_app/core/api/alarmas.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitud_credito_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/utils/create_file_from_string.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import '../../../core/api/personal_api.dart';
import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/cantidad_fotos_response.dart';
import '../../../core/models/colores_vehiculos_response.dart';
import '../../../core/models/descripcion_foto_vehiculo.dart';
import '../../../core/models/ediciones_vehiculo_response.dart';
import '../../../core/models/referencia_valoracion_response.dart';
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

class ConsultarModificarViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final _personalApi = locator<PersonalApi>();
  final _adjuntosApi = locator<AdjuntosApi>();
  final _authenticationAPI = locator<AuthenticationClient>();
  final _usuarioApi = locator<UserClient>();
  final _alarmasApi = locator<AlarmasApi>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyFotos = GlobalKey<FormState>();
  int _currentForm = 1;
  VinDecoderData? _vinData;

  // late SolicitudesData solicitudCola;
  late SolicitudesData solicitud;
  late bool isSalvage;
  late double tasacionPromedio;

  SolicitudCreditoData? solicitudCreditoData;

  TextEditingController tcFuerzaMotriz = TextEditingController();
  TextEditingController tcKilometraje = TextEditingController();
  TextEditingController tcPlaca = TextEditingController();
  TextEditingController tcVIN = TextEditingController();
  TipoVehiculoData? _tipoVehiculos;
  TransmisionesData? _transmision;
  AlarmasResponse? alarmasResponse;
  TraccionesData? _traccion;
  VersionVehiculoData? _versionVehiculo;
  EdicionVehiculo? _edicionVehiculos;
  String? _estado;
  int? _nPuertas;
  int? _nCilindros;
  ColorVehiculo? _colorVehiculo;
  late int _fotosPermitidas;
  late List<AdjuntoFoto> fotos;
  List<ReferenciaValoracion> referencias = [];

  List<AdjuntoFoto> fotosAdjuntos = [];
  List<AlarmasData> alarmas = [];
  final _picker = ImagePicker();

  ConsultarModificarViewModel();

  int get currentForm => _currentForm;
  set currentForm(int i) {
    _currentForm = i;
    getAlarmas();
    notifyListeners();
  }

  VinDecoderData? get vinData => _vinData;
  set vinData(VinDecoderData? data) {
    _vinData = data;
    notifyListeners();
  }

  VersionVehiculoData get versionVehiculo => _versionVehiculo!;

  set versionVehiculo(VersionVehiculoData? value) {
    _versionVehiculo = value;
    notifyListeners();
  }

  Future<void> getAlarmas() async {
    if (solicitud.id != null) {
      var resp = await _alarmasApi.getAlarmas(idSolicitud: solicitud.id);
      if (resp is Success<AlarmasResponse>) {
        alarmasResponse = resp.response;
        alarmas = resp.response.data;
      } else if (resp is Failure) {
        Dialogs.error(msg: resp.messages.first);
      }
    }
    notifyListeners();
  }

  void onInit(BuildContext context, SolicitudesData? data) async {
    solicitud = data!;
    tcVIN.text = solicitud.chasis ?? '';
    tcKilometraje.text = solicitud.kilometraje.toString();
    tcPlaca.text = solicitud.placa ?? '';
    tcFuerzaMotriz.text = solicitud.fuerzaMotriz.toString();
    await Future.delayed(const Duration(milliseconds: 150));
    solicitudCredito(context);

    if (solicitud.id != null) {
      var resp = await _alarmasApi.getAlarmas(idSolicitud: solicitud.id);
      if (resp is Success<AlarmasResponse>) {
        alarmasResponse = resp.response;
        alarmas = resp.response.data;
      } else if (resp is Failure) {
        Dialogs.error(msg: resp.messages.first);
      }
    }
    // var resp = await _solicitudesApi.getDescripcionFotosVehiculos();
    // if (resp is Success<List<DescripcionFotoVehiculos>>) {
    //   descripcionFotos = resp.response;
    // }
    notifyListeners();
  }

  Future<List<DescripcionFotoVehiculos>> getDescripcionFotos(
      String text) async {
    var resp = await _solicitudesApi.getDescripcionFotosVehiculos();
    if (resp is Success<List<DescripcionFotoVehiculos>>) {
      return resp.response;
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

  Future<void> solicitudCredito(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _solicitudesApi.getSolicitudCredito(
        idSolicitud: solicitud.noSolicitudCredito!);
    if (resp is Success<SolicitudCreditoResponse>) {
      solicitudCreditoData = resp.response.data;
      notifyListeners();
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

  Future<void> cargarAlarmas(int idSolicitud) async {
    Session data = _authenticationAPI.loadSession;
    Profile perfil = _usuarioApi.loadProfile;
    Object respalarm;
    data.role.any((element) => element == "AprobadorTasaciones")
        ? respalarm = await _alarmasApi.getAlarmas(idSolicitud: idSolicitud)
        : respalarm = await _alarmasApi.getAlarmas(
            usuario: perfil.id!, idSolicitud: idSolicitud);
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
    notifyListeners();
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

  TipoVehiculoData? get tipoVehiculo => _tipoVehiculos;

  set tipoVehiculo(TipoVehiculoData? value) {
    _tipoVehiculos = value;
    notifyListeners();
  }

  TransmisionesData? get transmision => _transmision;

  set transmision(TransmisionesData? value) {
    _transmision = value;
    notifyListeners();
  }

  TraccionesData? get traccion => _traccion;

  set traccion(TraccionesData? value) {
    _traccion = value;
    notifyListeners();
  }

  EdicionVehiculo get edicionVehiculo => _edicionVehiculos!;

  set edicionVehiculo(EdicionVehiculo? value) {
    _edicionVehiculos = value;
    notifyListeners();
  }

  ColorVehiculo? get colorVehiculo => _colorVehiculo;

  set colorVehiculo(ColorVehiculo? value) {
    _colorVehiculo = value;
    notifyListeners();
  }

  Future goToFotos(BuildContext context) async {
    if (formKey3.currentState!.validate()) {
      ProgressDialog.show(context);
      if (solicitud.estadoTasacion == 34) {
        var upResp = await _solicitudesApi.updateEstimacion(
          id: solicitud.id!,
          // TODO: => Cambiar SOLICITUD por VINDATA en Traccion y sistema de cambios
          sistemaTransmision: transmision?.id ??
              vinData?.idSistemaCambio ??
              solicitud.sistemaTransmision!,
          traccion: traccion?.id ?? vinData?.idTraccion ?? solicitud.traccion!,
          noPuertas: nPuertas ?? solicitud.noPuertas!,
          noCilindros: nCilindros ?? solicitud.noCilindros!,
          fuerzaMotriz: double.tryParse(tcFuerzaMotriz.text)!.round(),
          ano: solicitud.ano!,
          nuevoUsado: solicitud.nuevoUsado!,
          kilometraje: double.tryParse(tcKilometraje.text)!.round(),
          color: colorVehiculo?.id ?? 0,
          placa: tcPlaca.text == '' ? solicitud.placa! : tcPlaca.text,
        );
        if (upResp is Success) {
          Dialogs.success(msg: 'Datos actualizados');
        }
        if (upResp is Failure) {
          Dialogs.error(msg: upResp.messages[0]);
        }
        if (upResp is TokenFail) {
          Dialogs.error(msg: 'Su sesión a expirado');
          ProgressDialog.dissmiss(context);
          _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
        }
      }
      // CARGAR FOTOS
      var resp = await _adjuntosApi.getFotosTasacion(
          noTasacion: solicitud.noTasacion!);
      if (resp is Success<AdjuntosFotoResponse>) {
        fotosAdjuntos = resp.response.data;
        currentForm = 3;
        ProgressDialog.dissmiss(context);
      }
      if (resp is Failure) {
        // La solicitud no tiene fotos =>
        await fotosNuevas();
        ProgressDialog.dissmiss(context);
      }
    }
  }

  Future<void> fotosNuevas() async {
    var resp = await _solicitudesApi.getCantidadFotos(
      idSuplidor: solicitud.suplidorTasacion,
    );
    if (resp is Success) {
      var data = resp.response as EntidadResponse;
      // int cantidad = 1;
      int cantidad = int.parse(data.data.descripcion ?? '0');
      fotos = List.generate(cantidad, (i) => AdjuntoFoto());
      _fotosPermitidas = cantidad;
      currentForm = 3;
    }
  }

  /* void cargarFotoNuevas(int i) async {
    var img = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
    );
    if (img != null) {
      final fileTemp = await img.readAsBytes();
      fotos[i] = fotos[i].copyWith(adjunto: base64Encode(fileTemp));
      notifyListeners();
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
      fotosAdjuntos[i] = fotosAdjuntos[i].copyWith(adjunto: fotoBase);
      notifyListeners();
    }
  }
*/
  int get fotosPermitidas => _fotosPermitidas;
  set fotosPermitidas(int i) {
    _fotosPermitidas = i;
    notifyListeners();
  }

  // void cargarFotoNuevas(int i) async {
  //   if (solicitud.estadoTasacion == 34) {
  //     var img = await _picker.pickImage(
  //       source: ImageSource.camera,
  //       maxWidth: 720,
  //     );
  //     if (img != null) {
  //       fotos[i] = FotoData(file: File(img.path));
  //       notifyListeners();
  //     }
  //   }
  // }
  void cargarFotoNuevas(int i) async {
    var img = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
    );
    if (img != null) {
      final fileTemp = await img.readAsBytes();
      fotos[i] = fotos[i].copyWith(adjunto: base64Encode(fileTemp));
      notifyListeners();
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
      fotosAdjuntos[i] = fotosAdjuntos[i].copyWith(adjunto: fotoBase);
      notifyListeners();
    }
  }

  // void cargarFoto(int i) async {
  //   if (solicitud.estadoTasacion == 34) {
  //     var img = await _picker.pickImage(
  //       source: ImageSource.camera,
  //       maxWidth: 720,
  //     );
  //     if (img != null) {
  //       final foto = File(img.path);
  //       final fotoBase = base64Encode(foto.readAsBytesSync());
  //       fotosAdjuntos[i].adjunto = fotoBase;
  //       notifyListeners();
  //     }
  //   }
  // }

  Future<void> subirFotosNuevas(BuildContext context) async {
    if (solicitud.estadoTasacion == 34) {
      // if (fotos.any((e) => e.file!.path == '')) {
      // Dialogs.error(msg: 'Fotos incompletas');
      // } else {
      if (formKeyFotos.currentState!.validate()) {
        ProgressDialog.show(context);
        List<Map<String, dynamic>> dataList = [];
        for (var e in fotos) {
          // var fotoBase = base64Encode(e.file!.readAsBytesSync());
          if (e.adjunto != null) {
            Map<String, dynamic> data = {
              "adjuntoInBytes": e.adjunto,
              "tipoAdjunto": e.tipoAdjunto,
              "descripcion": e.descripcion,
            };
            dataList.add(data);
          }
        }
        var resp = await _adjuntosApi.addFotosTasacion(
            noTasacion: solicitud.noTasacion!, adjuntos: dataList);

        if (resp is Success) {
          ProgressDialog.dissmiss(context);
          Dialogs.success(msg: 'Fotos Guardadas');
          currentForm = 4;
        }
        if (resp is Failure) {
          ProgressDialog.dissmiss(context);
          Dialogs.error(msg: resp.messages[0]);
        }
        if (resp is TokenFail) {
          ProgressDialog.dissmiss(context);
          _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
          Dialogs.error(msg: 'su sesión a expirado');
        }
        // }
      }
    } else if (solicitud.estadoTasacion == 9 ||
        solicitud.estadoTasacion == 10) {
      Navigator.of(context).pop();
    } else {
      goToValorar(context);
    }
  }

  Future<void> editarFotoNueva(int i) async {
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
      final fileTemp = File(croppedFile.path);
      fotos[i] =
          fotos[i].copyWith(adjunto: base64Encode(fileTemp.readAsBytesSync()));
      notifyListeners();
    }
  }

  // Future<void> editarFotoNuevas(int i) async {
  //   var croppedFile = await ImageCropper().cropImage(
  //     sourcePath: fotos[i].file!.path,
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
  //   fotos[i] = FotoData(file: File(croppedFile!.path));
  //   notifyListeners();
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

  Future<List<EdicionVehiculo>> getEdiciones(String text) async {
    var resp = await _solicitudesApi.getEdicionesVehiculos(
        modeloid: solicitud.modelo!);
    if (resp is Success<List<EdicionVehiculo>>) {
      return resp.response;
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

  Future<void> editarFoto(int i) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: await createFileFromString(fotosAdjuntos[i].adjunto!),
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
      fotosAdjuntos[i] =
          fotosAdjuntos[i].copyWith(adjunto: base64Encode(fotoByte));
      notifyListeners();
    }
  }

  Future<void> subirFotos(BuildContext context) async {
    if (solicitud.estadoTasacion == 34) {
      if (fotosAdjuntos.any((e) => e.adjunto == '')) {
        Dialogs.error(msg: 'Fotos incompletas');
      } else {
        // if (formKeyFotos.currentState!.validate()) {
        ProgressDialog.show(context);
        List<Map<String, dynamic>> dataList = [];
        for (var e in fotosAdjuntos) {
          // var fotoBase = base64Decode(e.adjunto);
          Map<String, dynamic> data = {
            "adjuntoInBytes": e.adjunto,
            "tipoAdjunto": e.id,
            "descripcion": e.descripcion,
          };
          dataList.add(data);
        }
        var resp = await _adjuntosApi.addFotosTasacion(
            noTasacion: solicitud.noTasacion!, adjuntos: dataList);

        if (resp is Failure) {
          Dialogs.error(msg: resp.messages[0]);
          ProgressDialog.dissmiss(context);
        }
        if (resp is Success) {
          Dialogs.success(msg: 'Fotos Actualizadas');
          ProgressDialog.dissmiss(context);
          currentForm = 4;
        }
        if (resp is TokenFail) {
          Dialogs.error(msg: 'su sesión a expirado');
          ProgressDialog.dissmiss(context);
          _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
        }
        // }
      }
    } else if (solicitud.estadoTasacion == 9 ||
        solicitud.estadoTasacion == 10) {
      Navigator.of(context).pop();
    } else {
      goToValorar(context);
    }
  }

  Future<void> consultarVIN(BuildContext context) async {
    if (formKey2.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _solicitudesApi.getVinDecoder(
          chasisCode: tcVIN.text, noSolicitud: solicitud.noSolicitudCredito!);
      if (resp is Success) {
        var data = resp.response as VinDecoderResponse;
        vinData = data.data;
        if (vinData!.fuerzaMotriz != null) {
          tcFuerzaMotriz.text = vinData?.fuerzaMotriz?.toString() ?? '';
        }
        if (vinData!.numeroCilindros != null) {
          nCilindros = null;
        }
        if (vinData!.numeroPuertas != null) {
          nPuertas = null;
        }
        if (vinData!.sistemaCambio != null) {
          transmision = null;
        }
        if (vinData!.traccion != null) {
          traccion = null;
        }

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
        Dialogs.error(msg: 'su sesión a expirado');
        ProgressDialog.dissmiss(context);
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
    }
  }

  String? noVINValidator(String? value) {
    if (value?.trim() == '') {
      return 'Ingrese el número VIN';
    } else {
      return null;
    }
  }

  Future<void> escanearVIN() async {
    _navigatorService.navigateToPage(EscanerPage.routeName).then((value) {
      tcVIN.text = value;
      notifyListeners();
    });
  }

  void borrarFoto(int i) {
    fotosAdjuntos[i] = AdjuntoFoto();
    notifyListeners();
  }

  void borrarFotoNuevas(int i) {
    fotos[i] = AdjuntoFoto();
    notifyListeners();
  }

  Future<void> goToValorar(BuildContext context) async {
    if (solicitud.estadoTasacion == 11) {
      ProgressDialog.show(context);

      var salvamentoResp =
          // valorConsultaSalvamento
          await _solicitudesApi.getSalvamento(vin: solicitud.chasis ?? '');
      if (salvamentoResp is Success<Map<String, dynamic>>) {
        isSalvage = salvamentoResp.response['data']['is_salvage'];
      }
      if (salvamentoResp is Failure) {
        Dialogs.error(msg: salvamentoResp.messages[0]);
        isSalvage = false;
      }
      if (salvamentoResp is TokenFail) {
        Dialogs.error(msg: 'su sesión a expirado');
        ProgressDialog.dissmiss(context);
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
      ProgressDialog.dissmiss(context);
    }
    currentForm = 4;
  }

  Future<void> enviarSolicitud(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _solicitudesApi.updateSentToProcess(
        noTasacion: solicitud.noTasacion!);
    if (resp is Success) {
      Dialogs.success(msg: 'Solicitud enviada');
      ProgressDialog.dissmiss(context);
      Navigator.of(context).pop();
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
}
