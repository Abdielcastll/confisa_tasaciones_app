import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/tracciones_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';
import 'package:tasaciones_app/core/models/vin_decoder_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import 'package:tasaciones_app/widgets/escaner.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../auth/login/login_view.dart';

class SolicitudEstimacionViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  late DateTime fechaActual;
  // String? _numeroSolicitud;
  // String? _numeroVIN;
  String? _estado;
  String? _placa;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  TextEditingController tcNoSolicitud = TextEditingController();
  TextEditingController tcVIN =
      TextEditingController(text: '1FMCU9DG5CKA99352');
  int _currentForm = 1;
  SolicitudCreditoData? solicitud;
  VinDecoderData? _vinData;
  TipoVehiculoData? _tipoVehiculos;
  TransmisionesData? _transmision;
  TraccionesData? _traccion;
  int? _nPuertas;
  int? _nCilindros;
  int? _kilometraje;
  ColorVehiculo? _colorVehiculo;
  late int _fotosPermitidas;
  late List<File> fotos;
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

  // set numeroSolicitud(String value) {
  //   _numeroSolicitud = value;
  //   notifyListeners();
  // }

  // set numeroVIN(String value) {
  //   _numeroVIN = value;
  //   notifyListeners();
  // }

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

  String? get kilometraje => _kilometraje.toString();
  set kilometraje(String? i) {
    _kilometraje = int.parse(i!);
    notifyListeners();
  }

  String? get placa => _placa;
  set placa(String? i) {
    _placa = i!;
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

  int get fotosPermitidas => _fotosPermitidas;
  set fotosPermitidas(int i) {
    _fotosPermitidas = i;
    notifyListeners();
  }

  void onInit(SolicitudesData? arg) {
    if (arg != null) {
      /*solicitud = SolicitudCreditoData(
        ano: arg.ano.toString(),
        chasis: arg.chasis,
        codEntidad: arg.codigoEntidad,
        codOficialNegocios: arg.idOficial,
        codSucursal: arg.codigoSucursal,
        entidad: arg.codigoEntidad,
        estado: arg.estadoTasacion,
        marca: arg.descripcionMarca,
        modelo: arg.descripcionModelo,
        noIdentificacion: arg.identificacion,
        noSolicitud: arg.noSolicitudCredito,
        nombreCliente: arg.nombreCliente,
        nombreOficialNegocios: arg.
      );*/
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

  // void completarDatosVehiculo(VinDecoderData data){
  //   tipoVehiculo=data.
  // }

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
      fotos[i] = File(img.path);
      // fotoBase = base64Encode(foto.readAsBytesSync());
      // log(fotoBase);
      // bytesImage = const Base64Decoder().convert(fotoBase);
      // data.img = fotoBase;
      notifyListeners();
    }
  }

  void borrarFoto(int i) {
    fotos[i] = File('');
    notifyListeners();
  }

  Future<void> editarFoto(int i) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: fotos[i].path,
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
    fotos[i] = File(croppedFile?.path ?? fotos[i].path);
    notifyListeners();
  }

  Future goToFotos(BuildContext context) async {
    if (vinData == null) {
      Dialogs.error(msg: 'Debe consultar el No. VIN');
    } else {
      if (formKey3.currentState!.validate()) {
        ProgressDialog.show(context);
        var resp = await _solicitudesApi.getCantidadFotos();
        if (resp is Success) {
          var data = resp.response as EntidadResponse;
          int cantidad = int.parse(data.data.descripcion ?? '0');
          fotos = List.generate(cantidad, (i) => File(''));
          fotosPermitidas = cantidad;
          currentForm = 3;
          ProgressDialog.dissmiss(context);
        }
        print('VALIDO');
      }
    }
  }

  Future<void> crearSolicitud() async {
    var resp = await _solicitudesApi.createNewSolicitudEstimacion(
      ano: int.parse(solicitud!.ano!),
      chasis: solicitud!.chasis!,
      codigoEntidad: solicitud!.codEntidad!,
      codigoSucursal: solicitud!.codEntidad!,
      color: colorVehiculo.id,
      edicion: vinData?.idTrim ?? 0,
      fuerzaMotriz: int.parse(vinData?.fuerzaMotriz ?? ''),
      idOficial: solicitud!.codOficialNegocios!,
      idPromotor: 0,
      identificacion: solicitud!.noIdentificacion!,
      kilometraje: _kilometraje!,
      marca: 0,
      modelo: 0,
      noCilindros: _nCilindros!,
      noPuertas: _nPuertas!,
      noSolicitudCredito: solicitud!.noSolicitud!,
      nombreCliente: solicitud!.nombreCliente!,
      nuevoUsado: _estado == 'Nuevo' ? 0 : 1,
      placa: _placa!,
      serie: vinData?.idSerie ?? 0,
      sistemaTransmision: _transmision?.id ?? 0,
      suplidorTasacion: 0,
      tipoTasacion: 0,
      tipoVehiculoLocal: 0,
      traccion: _traccion?.id ?? 0,
      trim: vinData?.idTrim ?? 0,
      versionLocal: 0,
    );
  }

  bool isEditable() {
    if (solicitudCola != null) {
      return solicitudCola!.estadoTasacion == 9;
    } else {
      return true;
    }
  }

  Future<void> escanearVIN() async {
    _navigatorService.navigateToPage(EscanerPage.routeName).then((value) {
      tcVIN.text = value;
      notifyListeners();
    });
  }

/*
  String estadoVehiculo() {
    if (vinData == null) return '';
    if (int.parse(vinData?.ano ?? '2020') >= DateTime.now().year) {
      print('nuevo');
      return 'Nuevo';
    } else {
      print('USADO');
      return 'Usado';
    }
  }*/
}
