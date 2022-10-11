import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/api/alarmas.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/descripcion_foto_vehiculo.dart';
import 'package:tasaciones_app/core/models/ediciones_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_disponibles_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/tracciones_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';
import 'package:tasaciones_app/core/models/versiones_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/vin_decoder_response.dart';
import 'package:tasaciones_app/core/providers/alarmas_provider.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import 'package:tasaciones_app/widgets/escaner.dart';

import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/seguridad_entidades_generales/adjuntos_response.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../core/utils/create_file_from_string.dart';
import '../../auth/login/login_view.dart';

class SolicitudEstimacionViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
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
  MoneyMaskedTextController tcFuerzaMotriz = MoneyMaskedTextController(
      precision: 0,
      thousandSeparator: ',',
      decimalSeparator: '',
      initialValue: 0);
  MoneyMaskedTextController tcKilometraje = MoneyMaskedTextController(
      precision: 0,
      thousandSeparator: ',',
      decimalSeparator: '',
      initialValue: 0);
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

  TipoVehiculoData? get tipoVehiculo => _tipoVehiculos;

  set tipoVehiculo(TipoVehiculoData? value) {
    _tipoVehiculos = value;
    notifyListeners();
  }

  VersionVehiculoData? get versionVehiculo => _versionVehiculo;

  set versionVehiculo(VersionVehiculoData? value) {
    _versionVehiculo = value;
    notifyListeners();
  }

  EdicionVehiculo? get edicionVehiculo => _edicionVehiculos;

  set edicionVehiculo(EdicionVehiculo? value) {
    _edicionVehiculos = value;
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

  ColorVehiculo? get colorVehiculo => _colorVehiculo;

  set colorVehiculo(ColorVehiculo? value) {
    _colorVehiculo = value;
    notifyListeners();
  }

  int get fotosPermitidas => _fotosPermitidas;
  set fotosPermitidas(int i) {
    _fotosPermitidas = i;
    notifyListeners();
  }

  void onInit(SolicitudesData? arg) async {
    if (arg != null) {
      solicitudCola = arg;
      tcNoSolicitud.text = arg.noSolicitudCredito.toString();

      notifyListeners();
    }
  }

  SolicitudesDisponibles? _solicitudDisponible;
  SolicitudesDisponibles? get solicitudDisponible => _solicitudDisponible;
  void solicitudDisponibleOnChanged(
      BuildContext context, SolicitudesDisponibles? v) {
    _solicitudDisponible = v;
    solicitudCredito(context);
  }

  Future<void> getAlarmas(BuildContext context) async {
    if (Provider.of<AlarmasProvider>(context, listen: false).alarmas !=
        alarmas) {
      if (solicitudCreada!.id != null) {
        var resp =
            await _alarmasApi.getAlarmas(idSolicitud: solicitudCreada!.id);
        if (resp is Success<AlarmasResponse>) {
          alarmasResponse = resp.response;
          alarmas = resp.response.data;
          Provider.of<AlarmasProvider>(context, listen: false).alarmas =
              alarmas;
        } else if (resp is Failure) {
          Dialogs.error(msg: resp.messages.first);
        }
      }
      notifyListeners();
    }
  }

  Future<void> solicitudCredito(BuildContext context) async {
    // if (solicitudCola == null) {
    if (formKey.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _solicitudesApi.getSolicitudCredito(
          idSolicitud: _solicitudDisponible!.noSolicitud!);
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

        ProgressDialog.dissmiss(context);
      }
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages[0]);
        ProgressDialog.dissmiss(context);
      }
      if (resp is TokenFail) {
        _navigatorService.pop();
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'su sesión a expirado');
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
    } else if (resp is TokenFail) {
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'su sesión a expirado');
      return [];
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
    var resp =
        await _solicitudesApi.getSolicitudesDisponibles(idTipoTasacion: 21);
    if (resp is Success<List<SolicitudesDisponibles>>) {
      return resp.response;
    } else {
      return [];
    }
  }

  void cargarFoto(int i) async {
    if (fotos[i].adjunto == null) {
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
  }

  // void borrarFoto(int i) async {
  //   fotos[i] = AdjuntoFoto();
  //   notifyListeners();
  // }
  void borrarFoto(BuildContext context, int i) async {
    if (fotos[i].id != null) {
      ProgressDialog.show(context);
      await _adjuntosApi.deleteFotoTasacion(id: fotos[i].id!);
      ProgressDialog.dissmiss(context);
    }
    fotos[i] = AdjuntoFoto();
    notifyListeners();
  }

  Future<void> subirFotos(BuildContext context) async {
    // if (fotos.any((e) => e.id != null)) {
    //   currentForm = 4;
    // } else {
    final fotosCompletas =
        fotos.where((e) => e.adjunto != null).length == _fotosPermitidas;

    if (fotosCompletas &&
        !fotos.any((e) => e.id == null && e.adjunto != null)) {
      currentForm = 4;
      // Dialogs.error(msg: 'Debes enviar por lo menos 1 foto');
    } else {
      if (formKeyFotos.currentState!.validate()) {
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

        if (dataList.isEmpty) {
          Dialogs.error(msg: 'Debes capturar por lo menos 1 foto');
        } else {
          ProgressDialog.show(context);

          var resp = await _adjuntosApi.addFotosTasacion(
              noTasacion: solicitudCreada!.noTasacion!, adjuntos: dataList);

          if (resp is Success) {
            Dialogs.success(msg: 'Fotos guardadas');
            if (!fotos.any((e) => e.adjunto == null)) {
              ProgressDialog.dissmiss(context);
              currentForm = 4;
            } else {
              loadFotos(context);
            }
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
        // }
      }
      // }
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
      if (solicitudCreada == null) {
        if (formKey3.currentState!.validate()) {
          ProgressDialog.show(context);
          int? idSuplidor = await crearSolicitud(context);
          if (idSuplidor != null) {
            loadFotos(context);
          }
        }
      } else {
        ProgressDialog.show(context);
        loadFotos(context);
      }
    }
  }

  Future<void> loadFotos(BuildContext context) async {
    var r = await _solicitudesApi.getCantidadFotos(
        idSuplidor: solicitudCreada!.suplidorTasacion);
    if (r is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: r.messages[0]);
    }
    if (r is Success<EntidadResponse>) {
      int cantidad = int.parse(r.response.data.descripcion ?? '0');
      fotos = List.generate(cantidad, (i) => AdjuntoFoto(nueva: true));
      fotosPermitidas = cantidad;
    }
    var resp = await _adjuntosApi.getFotosTasacion(
        noTasacion: solicitudCreada!.noTasacion!);

    if (resp is Success<AdjuntosFotoResponse>) {
      var d = await _adjuntosApi.getAdjuntos(esFotoVehiculo: 1);
      if (d is Success<AdjuntosResponse>) {
        List<AdjuntosData> adjuntos = d.response.data;

        var f = resp.response.data;
        for (var i = 0; i < f.length; i++) {
          fotos[i] = fotos[i].copyWith(
            adjunto: f[i].adjunto,
            descripcion: f[i].descripcion,
            tipoAdjunto: f[i].tipoAdjunto,
            tipo: adjuntos
                .firstWhere((e) => e.id == f[i].tipoAdjunto)
                .descripcion,
            id: f[i].id,
            nueva: false,
          );
        }
        notifyListeners();
      }
    }
    if (resp is Failure) {
      print('NO HAY FOTOS GUARDADAS');
    }
    currentForm = 3;
    ProgressDialog.dissmiss(context);
  }

  Future<int?> crearSolicitud(BuildContext context) async {
    var resp = await _solicitudesApi.createNewSolicitudEstimacion(
      ano: int.parse(solicitud!.ano!),
      chasis: tcVIN.text,
      color: colorVehiculo!.id,
      edicion: edicionVehiculo!.id,
      fuerzaMotriz: vinData?.fuerzaMotriz ?? tcFuerzaMotriz.numberValue.toInt(),
      kilometraje: tcKilometraje.numberValue.toInt(),
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
      tipoVehiculoLocal: tipoVehiculo!.id,
      traccion: _traccion!.id,
      trim: vinData?.idTrim,
      versionLocal: versionVehiculo!.id, /* INFO VEHICULOGET VERSIONES   */
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
    vinData = null;
    tcVIN.clear();
    tcPlaca.clear();
    tcNoSolicitud.clear();
    tcFuerzaMotriz.updateValue(0);
    tcKilometraje.updateValue(0);
    versionVehiculo = null;
    edicionVehiculo = null;
    tipoVehiculo = null;
    transmision = null;
    traccion = null;
    nPuertas = null;
    nCilindros = null;
    colorVehiculo = null;
    notifyListeners();
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
