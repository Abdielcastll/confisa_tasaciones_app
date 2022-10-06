import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/api/alarmas.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitud_credito_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/providers/alarmas_provider.dart';
import 'package:tasaciones_app/core/utils/create_file_from_string.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';
import '../../../core/api/seguridad_entidades_generales/adjuntos.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/cantidad_fotos_response.dart';
import '../../../core/models/colores_vehiculos_response.dart';
import '../../../core/models/componente_tasacion_response.dart';
import '../../../core/models/descripcion_foto_vehiculo.dart';
import '../../../core/models/ediciones_vehiculo_response.dart';
import '../../../core/models/referencia_valoracion_response.dart';
import '../../../core/models/seguridad_entidades_generales/adjuntos_response.dart';
import '../../../core/models/tipo_vehiculo_response.dart';
import '../../../core/models/tracciones_response.dart';
import '../../../core/models/transmisiones_response.dart';
import '../../../core/models/versiones_vehiculo_response.dart';
import '../../../core/models/vin_decoder_response.dart';
import '../../../core/providers/accesorios_provider.dart';
import '../../../core/providers/componentes_vehiculo_provider.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/escaner.dart';
import '../../auth/login/login_view.dart';

class ConsultarModificarViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final _adjuntosApi = locator<AdjuntosApi>();
  final _authenticationAPI = locator<AuthenticationClient>();
  final _alarmasApi = locator<AlarmasApi>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyFotos = GlobalKey<FormState>();
  int _currentForm = 1;
  VinDecoderData? _vinData;

  late SolicitudesData solicitud;
  bool isSalvage = false;
  double tasacionPromedio = 0;

  SolicitudCreditoData? solicitudCreditoData;

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
  List<AdjuntoFoto> fotos = [];
  List<ReferenciaValoracion> referencias = [];
  bool isAprobador = false;
  bool isTasador = false;
  bool isOficial = false;
  bool mostrarAccComp = false;
  List<ComponentePorSegmento> componentes = [];
  List<ComponentePorSegmento> accesorios = [];
  List<SegmentoCond> segmentoComponente = [];
  List<SegmentoCond> segmentoAccesorio = [];

  // List<AdjuntoFoto> fotosAdjuntos = [];
  List<AlarmasData> alarmas = [];
  final _picker = ImagePicker();

  ConsultarModificarViewModel();

  MoneyFormatter fmf = MoneyFormatter(
      amount: 12345678.9012345,
      settings: MoneyFormatterSettings(
          symbol: 'RD\$',
          thousandSeparator: ',',
          decimalSeparator: '.',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 2,
          compactFormatType: CompactFormatType.short));

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

  VersionVehiculoData? get versionVehiculo => _versionVehiculo;

  set versionVehiculo(VersionVehiculoData? value) {
    _versionVehiculo = value;
    notifyListeners();
  }

  Future<void> getAlarmas(BuildContext context) async {
    if (Provider.of<AlarmasProvider>(context, listen: false).alarmas !=
        alarmas) {
      if (solicitud.id != null) {
        var resp = await _alarmasApi.getAlarmas(idSolicitud: solicitud.id);
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

  List<ComponenteTasacion> listaComponentes = [];

  void onInit(BuildContext context, SolicitudesData? data) async {
    solicitud = data!;
    tcVIN.text = solicitud.chasis ?? 'No disponible';
    tcKilometraje.updateValue(solicitud.kilometraje ?? 0);
    tcPlaca.text = solicitud.placa ?? 'No disponible';
    tcFuerzaMotriz.updateValue(solicitud.fuerzaMotriz?.toDouble() ?? 0);
    Session session = _authenticationAPI.loadSession;
    session.role.forEach((e) => print(e));
    isAprobador = session.role.contains("AprobadorTasaciones");
    isTasador = session.role.contains("Tasador") && session.role.length == 1;
    isOficial =
        session.role.contains("OficialNegocios") && session.role.length == 1;

    mostrarAccComp = solicitud.estadoTasacion! >= 10 &&
        solicitud.estadoTasacion! <= 13 &&
        solicitud.tipoTasacion != 21;

    getAlarmas(context);
    loadCondiconesComponentes();
    loadAccesorios();
    notifyListeners();
  }

  void loadCondiconesComponentes() {
    final componentesProv = ComponentesVehiculosProvider.instance;

    if (solicitud.condicionComponenteTasacion!.isNotEmpty) {
      for (var e in solicitud.condicionComponenteTasacion!) {
        var compTemp = ComponentePorSegmento(
          componente: componentesProv.componentes
              .firstWhere((d) => d.idComponente == e.idComponenteVehiculo)
              .componenteDescripcion,
          condicion: componentesProv.componentes
              .firstWhere(
                (d) => d.id == e.idCondicionComponenteVehiculo,
              )
              .condicionDescripcion,
          segmento: componentesProv.componentesSeg
              .firstWhere((d) => d.id == e.idComponenteVehiculo)
              .segmentoDescripcion,
        );
        componentes.add(compTemp);
      }
    }
    for (var componente in componentes) {
      if (!segmentoComponente
          .any((e) => e.nombreSegmento == componente.segmento)) {
        segmentoComponente.add(SegmentoCond(componente.segmento!, []));
      }
      for (var c in componentes) {
        for (var s in segmentoComponente) {
          if (c.segmento == s.nombreSegmento) {
            if (!s.componentes.any((e) => e.componente == c.componente)) {
              s.componentes.add(c);
            }
          }
        }
      }
    }
  }

  void loadAccesorios() {
    final accesoriosProv = AccesoriosProvider.instance;
    if (solicitud.accesoriosTasacion!.isNotEmpty) {
      for (var e in solicitud.accesoriosTasacion!) {
        var compTemp = ComponentePorSegmento(
          componente: accesoriosProv.accesorios
              .firstWhere((d) => d.id == e.idAccesorio)
              .descripcion,
          condicion: '',
          segmento: accesoriosProv.accesorios
              .firstWhere((d) => d.id == e.idAccesorio)
              .segmentoDescripcion,
        );
        accesorios.add(compTemp);
      }
    }
    for (var acc in accesorios) {
      if (!segmentoAccesorio.any((e) => e.nombreSegmento == acc.segmento)) {
        segmentoAccesorio.add(SegmentoCond(acc.segmento!, []));
      }
      for (var c in accesorios) {
        for (var s in segmentoAccesorio) {
          if (c.segmento == s.nombreSegmento) {
            if (!s.componentes.any((e) => e.componente == c.componente)) {
              s.componentes.add(c);
            }
          }
        }
      }
    }
  }

  Future<List<TipoFotoVehiculos>> getTipoFotos(String text) async {
    var resp = await _solicitudesApi.getTipoFotosVehiculos();
    if (resp is Success<List<TipoFotoVehiculos>>) {
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

  EdicionVehiculo? get edicionVehiculo => _edicionVehiculos;

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
    if (mostrarAccComp) {
      ProgressDialog.show(context);
      loadFotos(context);
    } else if (formKey3.currentState!.validate()) {
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
          fuerzaMotriz: tcFuerzaMotriz.numberValue.toInt(),
          ano: solicitud.ano!,
          nuevoUsado: solicitud.nuevoUsado!,
          kilometraje: tcKilometraje.numberValue.toInt(),
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
      loadFotos(context);
    }
  }

  Future<void> loadFotos(BuildContext context) async {
    var r = await _solicitudesApi.getCantidadFotos(
        idSuplidor: solicitud.suplidorTasacion!);
    if (r is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: r.messages[0]);
    }
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
    mostrarAccComp ? currentForm = 5 : currentForm = 3;
    ProgressDialog.dissmiss(context);
  }

  int get fotosPermitidas => _fotosPermitidas;
  set fotosPermitidas(int i) {
    _fotosPermitidas = i;
    notifyListeners();
  }

  void cargarFoto(int i) async {
    // Si esta en estado INICIADA puede modificar la foto
    if (solicitud.estadoTasacion == 34 && fotos[i].adjunto == null) {
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
        IOSUiSettings(title: 'Editar foto'),
      ],
    );
    if (croppedFile != null) {
      var fotoByte = File(croppedFile.path).readAsBytesSync();
      fotos[i] = fotos[i].copyWith(adjunto: base64Encode(fotoByte));
      if (fotos[i].id != null) {
        ProgressDialog.show(context);
        var r = await _adjuntosApi.deleteFotoTasacion(id: fotos[i].id!);
        if (r is Success) {
          var d = await _adjuntosApi
              .addFotosTasacion(noTasacion: solicitud.noTasacion!, adjuntos: [
            {
              "adjuntoInBytes": fotos[i].adjunto,
              "tipoAdjunto": fotos[i].tipoAdjunto,
              "descripcion": fotos[i].descripcion,
            }
          ]);
          if (d is Failure) {
            Dialogs.error(msg: d.messages[0]);
          }
        } else if (r is Failure) {
          Dialogs.error(msg: r.messages[0]);
        }
        ProgressDialog.dissmiss(context);
      }
      notifyListeners();
    }
  }

  Future<void> subirFotos(BuildContext context) async {
    if (solicitud.estadoTasacion == 34) {
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
              _navigatorService
                  .navigateToPageAndRemoveUntil(LoginView.routeName);
            }
          }
        } else {
          await goToValorar(context);
        }
      }
    } else if (solicitud.estadoTasacion == 9) {
      Navigator.of(context).pop();
    } else if (mostrarAccComp) {
      if (isAprobador) {
        goToAprobar(context);
      } else if (isTasador) {
        currentForm = 6;
      } else {
        currentForm = 6;
        // goToValorar(context);
        // Navigator.of(context).pop();
      }
    } else {
      goToValorar(context);
    }
  }

  Future<void> goToAprobar(BuildContext context) async {
    ProgressDialog.show(context);

    var salvamentoResp =
        // valorConsultaSalvamento
        await _solicitudesApi.getSalvamento(vin: solicitud.chasis ?? '');
    if (salvamentoResp is Success<Map<String, dynamic>>) {
      isSalvage = salvamentoResp.response['data']['is_salvage'];
    }
    if (salvamentoResp is Failure) {
      // Dialogs.error(msg: salvamentoResp.messages[0]);
      isSalvage = false;
    }
    if (salvamentoResp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      ProgressDialog.dissmiss(context);
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
    // ProgressDialog.dissmiss(context);
    // }
    var tasacionPromedioResp = await _solicitudesApi.getTasacionCreditoAverage(
      chasis: solicitud.chasis ?? tcVIN.text,
      periodoMeses: 3,
    );
    if (tasacionPromedioResp is Success<Map<String, dynamic>>) {
      tasacionPromedio = tasacionPromedioResp.response['data'];
      // notifyListeners();
    }
    if (tasacionPromedioResp is Failure) {
      // Dialogs.error(msg: tasacionPromedioResp.messages[0]);
      tasacionPromedio = 0;
      // notifyListeners();
    }
    // valorUltimaEstimacion
    // var resp =
    //     await _solicitudesApi.getTasacionCreditoLast(chasis: solicitud.chasis!);
    // valorCarrosRD
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

  Future<void> consultarVIN(BuildContext context) async {
    if (formKey2.currentState!.validate()) {
      ProgressDialog.show(context);
      var resp = await _solicitudesApi.getVinDecoder(
          chasisCode: tcVIN.text, noSolicitud: solicitud.noSolicitudCredito!);
      if (resp is Success) {
        var data = resp.response as VinDecoderResponse;
        vinData = data.data;

        // if (vinData!.message != null) {
        //   Dialogs.vinMessage(msg: vinData!.message!);
        // }

        if (vinData!.fuerzaMotriz != null) {
          tcFuerzaMotriz.text = vinData?.fuerzaMotriz?.toString() ?? '';
        }
        if (vinData!.numeroCilindros != null) {
          _nCilindros = null;
        }
        if (vinData!.numeroPuertas != null) {
          _nPuertas = null;
        }
        if (vinData!.sistemaCambio != null) {
          _transmision = null;
        }
        if (vinData!.traccion != null) {
          _traccion = null;
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

  void borrarFoto(BuildContext context, int i) async {
    if (fotos[i].id != null) {
      ProgressDialog.show(context);
      await _adjuntosApi.deleteFotoTasacion(id: fotos[i].id!);
      ProgressDialog.dissmiss(context);
    }
    fotos[i] = AdjuntoFoto();
    notifyListeners();
  }

  Future<void> goToValorar(BuildContext context) async {
    currentForm = 4;
  }

  Future<void> enviarSolicitud(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _solicitudesApi.updateSentToProcess(
        noTasacion: solicitud.noTasacion!);
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

  Future<void> aprobar(BuildContext context) async {
    ProgressDialog.show(context);
    print(solicitud.noSolicitudCredito ?? '');
    print(solicitud.noTasacion ?? '');
    var aprobarResp = await _solicitudesApi.aprobarSolicitud(
        noSolicitud: solicitud.noSolicitudCredito!,
        noTasacion: solicitud.noTasacion!);
    if (aprobarResp is Success) {
      Dialogs.success(msg: 'Solicitud Aprobada');
      ProgressDialog.dissmiss(context);
      Navigator.of(context).pop(true);
    }
    if (aprobarResp is Failure) {
      Dialogs.error(msg: aprobarResp.messages[0]);
      ProgressDialog.dissmiss(context);
    }
    if (aprobarResp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      ProgressDialog.dissmiss(context);
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }
}

class ComponentePorSegmento {
  String? segmento;
  String? componente;
  String? condicion;
  bool isSelected;
  int? id;

  ComponentePorSegmento({
    this.isSelected = false,
    this.segmento,
    this.componente,
    this.condicion,
    this.id,
  });
}

class SegmentoCond {
  String nombreSegmento;
  List<ComponentePorSegmento> componentes;

  SegmentoCond(this.nombreSegmento, this.componentes);
}
