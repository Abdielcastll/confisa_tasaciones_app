import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/accesorios_suplidor_response.dart';
import 'package:tasaciones_app/core/models/componente_tasacion_response.dart';
import 'package:tasaciones_app/core/models/descripcion_foto_vehiculo.dart';
import 'package:tasaciones_app/core/models/referencia_valoracion_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/adjuntos_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/adjunto_foto_response.dart';
import '../../../core/models/cantidad_fotos_response.dart';
import '../../../core/models/colores_vehiculos_response.dart';
import '../../../core/models/componente_condicion.dart';
import '../../../core/models/ediciones_vehiculo_response.dart';
import '../../../core/models/sign_in_response.dart';
import '../../../core/models/solicitudes/solicitud_credito_response.dart';
import '../../../core/models/tipo_vehiculo_response.dart';
import '../../../core/models/tracciones_response.dart';
import '../../../core/models/transmisiones_response.dart';
import '../../../core/models/versiones_vehiculo_response.dart';
import '../../../core/models/vin_decoder_response.dart';
import '../../../core/providers/accesorios_provider.dart';
import '../../../core/services/navigator_service.dart';
import '../../../core/utils/create_file_from_string.dart';
import '../../../theme/theme.dart';
import '../../../widgets/escaner.dart';
import '../../auth/login/login_view.dart';
import '../consultar_modificar_solicitud/consultar_modificar_view_model.dart';

class TrabajarViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final _adjuntosApi = locator<AdjuntosApi>();
  final _authenticationAPI = locator<AuthenticationClient>();
  late DateTime fechaActual;
  String? _estado;
  int? _estadoID;
  GlobalKey<FormState> formKeyValor = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyFotos = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCondiciones = GlobalKey<FormState>();
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
  MoneyMaskedTextController tcValor = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
    leftSymbol: 'RD\$ ',
  );
  TextEditingController tcObservacion = TextEditingController();
  // List<AdjuntoFoto> fotosAdjuntos = [];
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
  late List<AdjuntoFoto> fotos;
  final _picker = ImagePicker();
  List<TipoFotoVehiculos> descripcionFotos = [];
  SolicitudCreditoData? solicitudData;
  List<ComponenteTasacion> componentes = [];
  List<AccesoriosSuplidor> accesorios = [];
  List<ReferenciaValoracion> referencias = [];
  late bool isSalvage;
  late double tasacionPromedio;

  @override
  void dispose() {
    tcVIN.dispose();
    tcFuerzaMotriz.dispose();
    tcKilometraje.dispose();
    tcPlaca.dispose();
    tcValor.dispose();
    tcObservacion.dispose();
    super.dispose();
  }

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

  TransmisionesData? get transmision => _transmision;

  set transmision(TransmisionesData? value) {
    _transmision = value;
    notifyListeners();
  }

  EdicionVehiculo? get edicionVehiculo => _edicionVehiculos;

  set edicionVehiculo(EdicionVehiculo? value) {
    _edicionVehiculos = value;
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

  List<String> roles = [];

  void onInit(BuildContext context, SolicitudesData? arg) async {
    Session data = _authenticationAPI.loadSession;
    roles = data.role;
    if (arg != null) {
      solicitud = arg;
      // await Future.delayed(const Duration(milliseconds: 150));
      // solicitudCredito(context);
    }
  }

  Future<List<EdicionVehiculo>> getEdiciones(String text) async {
    var resp = await _solicitudesApi.getEdicionesVehiculos(
        modeloid: vinData?.codigoModelo ?? 0);
    // modeloid: 2016);
    if (resp is Success<List<EdicionVehiculo>>) {
      return resp.response;
    } else {
      return [];
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
            _estadoID = 1;
            notifyListeners();
          } else {
            _estadoID = 2;
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

  List<SegmentoCondiciones> segmentoComponente = [];
  List<SegmentoCond> segmentoAccesorio = [];

  Future goToCondiciones(BuildContext context) async {
    if (formKey3.currentState!.validate()) {
      if (vinData == null) {
        Dialogs.error(msg: 'Debe consultar el No. VIN');
      } else {
        ProgressDialog.show(context);
        var upResp = await _solicitudesApi.updateTasacion(
          id: solicitud.id!,
          ano: vinData?.ano ?? 0,
          chasis: tcVIN.text,
          color: colorVehiculo!.id,
          edicion: edicionVehiculo!.id!,
          fuerzaMotriz: tcFuerzaMotriz.numberValue.toInt(),
          kilometraje: tcKilometraje.numberValue.toInt(),
          marca: solicitudData?.idMarcaTasaciones ?? vinData?.codigoMarca ?? 0,
          modelo:
              solicitudData?.idModeloTasaciones ?? vinData?.codigoModelo ?? 0,
          noCilindros: nCilindros!,
          noPuertas: nPuertas!,
          nuevoUsado: _estadoID!,
          placa: tcPlaca.text.trim(),
          tipoVehiculoLocal: tipoVehiculo!.id,
          traccion: traccion?.id ?? vinData!.idTraccion!,
          versionLocal: versionVehiculo!.id,
          sistemaTransmision: transmision?.id ?? vinData!.idSistemaCambio!,
        );
        if (upResp is Success) {
          Dialogs.success(msg: 'Datos actualizados');
          var resp = await _solicitudesApi.getComponenteVehiculoSuplidor(
              idSuplidor: solicitud.suplidorTasacion!);
          if (resp is Success<List<ComponenteTasacion>>) {
            componentes = resp.response;
            for (var componente in componentes) {
              if (!segmentoComponente.any(
                  (e) => e.nombreSegmento == componente.descripcionSegmento)) {
                segmentoComponente.add(
                    SegmentoCondiciones(componente.descripcionSegmento!, []));
              }
              for (var c in componentes) {
                for (var s in segmentoComponente) {
                  if (c.descripcionSegmento == s.nombreSegmento) {
                    if (!s.componentes.any((e) =>
                        e.componenteDescripcion == c.componenteDescripcion)) {
                      s.componentes.add(c);
                    }
                  }
                }
              }
            }

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

  Future<void> goToAccesorios(BuildContext context) async {
    if (formKeyCondiciones.currentState!.validate()) {
      ProgressDialog.show(context);
      Map<String, dynamic> data = {
        "condicionesComponenteVehiculo": List.from(
          componentes.map((x) => {
                "idComponenteVehiculo": x.idComponente,
                "idCondicionComponenteVehiculo": x.idCondicion,
              }),
        ),
      };
      var updateResp = await _solicitudesApi.updateCondicionComponente(
        idSolicitud: solicitud.id!,
        data: data,
      );
      if (updateResp is Success) {
        await loadAccesorios(context);
      }
      if (updateResp is Failure) {
        var createResp = await _solicitudesApi.createCondicionComponente(data: {
          "idSolicitud": solicitud.id,
          ...data,
        });
        if (createResp is Success) {
          await loadAccesorios(context);
        }
        if (createResp is Failure) {
          Dialogs.error(msg: createResp.messages[0]);
          ProgressDialog.dissmiss(context);
        }
      }
      if (updateResp is TokenFail) {
        Dialogs.error(msg: 'su sesión a expirado');
        ProgressDialog.dissmiss(context);
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
    }
  }

  Future<void> loadAccesorios(BuildContext context) async {
    var resp = await _solicitudesApi.getAccesorioVehiculoSuplidor(
        idSuplidor: solicitud.suplidorTasacion!);
    if (resp is Success<List<AccesoriosSuplidor>>) {
      accesorios = resp.response;

      List<ComponentePorSegmento> accPorSeg = [];
      final accesoriosProv = AccesoriosProvider.instance;

      for (var e in accesorios) {
        var compTemp = ComponentePorSegmento(
          id: e.idAccesorio,
          componente: accesoriosProv.accesorios
              .firstWhere((d) => d.id == e.idAccesorio)
              .descripcion,
          condicion: '',
          segmento: accesoriosProv.accesorios
              .firstWhere((d) => d.id == e.idAccesorio)
              .segmentoDescripcion,
        );
        accPorSeg.add(compTemp);
      }

      for (var acc in accPorSeg) {
        if (!segmentoAccesorio.any((e) => e.nombreSegmento == acc.segmento)) {
          segmentoAccesorio.add(SegmentoCond(acc.segmento!, []));
        }
        for (var c in accPorSeg) {
          for (var s in segmentoAccesorio) {
            if (c.segmento == s.nombreSegmento) {
              if (!s.componentes.any((e) => e.componente == c.componente)) {
                s.componentes.add(c);
              }
            }
          }
        }
      }
      currentForm = 4;
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    ProgressDialog.dissmiss(context);
  }

  Future goToFotos(BuildContext context) async {
    ProgressDialog.show(context);
    var accesoriosSeleccionados =
        accesorios.where((e) => e.isSelected == true).toList();
    Map<String, dynamic> data = {
      "accesorios": List.from(
        accesoriosSeleccionados.map((x) => {"idAccesorio": x.idAccesorio}),
      ),
    };
    var updateResp = await _solicitudesApi.updateAccesoriosTasacion(
        idSolicitud: solicitud.id!, data: data);
    if (updateResp is Success) {
      await loadFotos(context);
      print('ACCESORIOS ACTUALIZADOS');
    }
    if (updateResp is Failure) {
      var createResp = await _solicitudesApi.createAccesoriosTasacion(data: {
        "idSolicitud": solicitud.id,
        ...data,
      });
      if (createResp is Success) {
        await loadFotos(context);
        print('ACCESORIOS CREADOS');
      }
      if (createResp is Failure) {
        Dialogs.error(msg: createResp.messages[0]);
        ProgressDialog.dissmiss(context);
      }
    }
    if (updateResp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      ProgressDialog.dissmiss(context);
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  Future<void> loadFotos(BuildContext context) async {
    var r = await _solicitudesApi.getCantidadFotos(
        idSuplidor: solicitud.suplidorTasacion!);
    if (r is Success<EntidadResponse>) {
      int cantidad = int.parse(r.response.data.descripcion ?? '0');
      fotos = List.generate(cantidad, (i) => AdjuntoFoto(nueva: true));
      fotosPermitidas = cantidad;
    }
    var resp =
        await _adjuntosApi.getFotosTasacion(noTasacion: solicitud.noTasacion!);

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
    ProgressDialog.dissmiss(context);
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

  Future<List<CondicionComponente>> getCondiciones({
    required int idComponente,
  }) async {
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
    if (fotos[i].adjunto == null) {
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
  }

  void borrarFoto(BuildContext context, int i) async {
    if (fotos[i].id != null) {
      ProgressDialog.show(context);
      await _adjuntosApi.deleteFotoTasacion(id: fotos[i].id!);
      ProgressDialog.dissmiss(context);
    }
    fotos[i] = AdjuntoFoto();
    notifyListeners();
  }

  Future<List<TipoFotoVehiculos>> getDescripcionFotos(String text) async {
    var resp = await _solicitudesApi.getTipoFotosVehiculos();
    if (resp is Success<List<TipoFotoVehiculos>>) {
      return resp.response;
    } else {
      return [];
    }
  }

  Future<void> editarFoto(BuildContext context, int i) async {
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
      if (fotos[i].id != null) {
        ProgressDialog.show(context);
        await _adjuntosApi.updateFotoTasacion(
            id: fotos[i].id!,
            adjunto: fotos[i].adjunto!,
            descripcion: fotos[i].descripcion!,
            tipoAdjunto: fotos[i].tipoAdjunto!);
        ProgressDialog.dissmiss(context);
      }

      notifyListeners();
    }
  }

  Future<void> subirFotos(BuildContext context) async {
    if (formKeyFotos.currentState!.validate()) {
      if (fotos.any((e) => e.nueva)) {
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
        if (dataList.isEmpty) {
          ProgressDialog.dissmiss(context);
          await goToValorar(context);
        } else {
          var resp = await _adjuntosApi.addFotosTasacion(
              noTasacion: solicitud.noTasacion!, adjuntos: dataList);

          if (resp is Failure) {
            Dialogs.error(msg: resp.messages[0]);
            ProgressDialog.dissmiss(context);
          }

          if (resp is Success) {
            Dialogs.success(msg: 'Fotos Actualizadas');
            ProgressDialog.dissmiss(context);
            await goToValorar(context);
          }

          if (resp is TokenFail) {
            Dialogs.error(msg: 'su sesión a expirado');
            ProgressDialog.dissmiss(context);
            _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
          }
        }
      } else {
        await goToValorar(context);
      }
    }
  }

  Future<void> goToValorar(BuildContext context) async {
    ProgressDialog.show(context);
    var salvamentoResp =
        // valorConsultaSalvamento
        await _solicitudesApi.getSalvamento(
            vin: solicitud.chasis ?? tcVIN.text);
    if (salvamentoResp is Success<Map<String, dynamic>>) {
      isSalvage = salvamentoResp.response['data']['is_salvage'];
      // notifyListeners();
    }
    if (salvamentoResp is Failure) {
      Dialogs.error(msg: salvamentoResp.messages[0]);
      isSalvage = false;
      // notifyListeners();
    }
    if (salvamentoResp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      ProgressDialog.dissmiss(context);
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
    // valorUltimas3Tasaciones
    print('chasis: ${solicitud.chasis}');
    print('tcVIN: ${tcVIN.text}');
    var tasacionPromedioResp = await _solicitudesApi.getTasacionCreditoAverage(
      chasis: solicitud.chasis ?? tcVIN.text,
      periodoMeses: 3,
    );
    if (tasacionPromedioResp is Success<Map<String, dynamic>>) {
      tasacionPromedio = tasacionPromedioResp.response['data'];
      // notifyListeners();
    }
    if (tasacionPromedioResp is Failure) {
      Dialogs.error(msg: tasacionPromedioResp.messages[0]);
      tasacionPromedio = 0.0;
      // notifyListeners();
    }

    var referenceResp = await _solicitudesApi.getReference(
        chasis: solicitud.chasis ?? tcVIN.text,
        noTasacion: solicitud.noTasacion!);
    if (referenceResp is Success<List<ReferenciaValoracion>>) {
      referencias = referenceResp.response;
      // notifyListeners();
    }
    notifyListeners();
    ProgressDialog.dissmiss(context);
    currentForm = 6;
  }

  Future<void> guardarValoracion(BuildContext context) async {
    if (formKeyValor.currentState!.validate()) {
      ProgressDialog.show(context);

      var resp = await _solicitudesApi.updateValoracion(
        noTasacion: solicitud.noTasacion!,
        valorizacion: tcValor.numberValue.toString(),
        valorConsultaSalvamento: isSalvage,
        valorUltimas3Tasaciones: referencias[0].valor!.round(),
        valorUltimaEstimacion: referencias[1].valor!.round(),
        valorCarrosRD: referencias[2].valor!.round(),
        observacion: tcObservacion.text.trim(),
      );

      if (resp is Success) {
        Dialogs.success(msg: 'Valor Actualizado');
        ProgressDialog.dissmiss(context);
        Navigator.of(context).pop(true);
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
      // }

    }
  }
}

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

class SegmentoCondiciones {
  String nombreSegmento;
  List<ComponenteTasacion> componentes;

  SegmentoCondiciones(this.nombreSegmento, this.componentes);
}
