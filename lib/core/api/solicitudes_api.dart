import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/componente_condicion.dart';
import 'package:tasaciones_app/core/models/componente_tasacion_response.dart';
import 'package:tasaciones_app/core/models/ediciones_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/referencia_valoracion_response.dart';
import 'package:tasaciones_app/core/models/reporte_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitud_tipo_estado_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_disponibles_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/tracciones_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';
import 'package:tasaciones_app/core/models/versiones_vehiculo_response.dart';

import '../authentication_client.dart';
import '../models/accesorios_suplidor_response.dart';
import '../models/descripcion_foto_vehiculo.dart';
import '../models/solicitudes/solicitud_credito_response.dart';
import '../models/vin_decoder_response.dart';
import 'api_status.dart';
import 'http.dart';

class SolicitudesApi {
  SolicitudesApi(this._http, this._authenticationClient);
  final Http _http;
  final AuthenticationClient _authenticationClient;
  var l = Logger();

  Future<Object> getSolicitudCredito({required int idSolicitud}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudcredito/get/$idSolicitud',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return SolicitudCreditoResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getSolicitudesDisponibles(
      {required int idTipoTasacion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudcredito/get-list',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {'IdTipoTasacion': idTipoTasacion},
        parser: (data) {
          return solicitudesDisponiblesFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getVinDecoder(
      {required String chasisCode, required int noSolicitud}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/vins/vin-decoder',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "chasisCode": chasisCode,
          "noSolicitud": noSolicitud,
        },
        parser: (data) {
          return VinDecoderResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTipoVehiculo(String descripcion) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/infovehiculos/get-tipos-vehiculo/$descripcion',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return TipoVehiculoResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getVersionVehiculo() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/infovehiculos/get-versiones',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return VersionesVehiculoResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getSistemaDeCambios() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/infovehiculos/get-transmisiones',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return TransmisionesResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTraccion() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/infovehiculos/get-tracciones',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return TraccionesResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getColores(String desc) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/colores-vehiculo/get/$desc',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return ColoresVehiculosResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getCantidadFotos({int? idSuplidor}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      final body = {
        "IdSuplidor": idSuplidor,
      };
      l.d(body);
      return _http.request(
        '/api/fotos/get-cantidad?IdSuplidor=$idSuplidor',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        // data: body,
        parser: (data) {
          return EntidadResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTipoFotos() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/fotos/get-tipos',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return EntidadResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTipoFotosVehiculos() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tipos-adjuntos/get',
        method: 'GET',
        queryParameters: {
          'EsFotoVehiculo': '1',
        },
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return descripcionFotoVehiculosFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getComponenteVehiculoSuplidor(
      {required int idSuplidor}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/componentes-vehiculo-suplidor/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "IdSuplidor": idSuplidor,
        },
        parser: (data) {
          return componenteTasacionFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getAccesorioVehiculoSuplidor({required int idSuplidor}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/accesoriossuplidor/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "IdSuplidor": idSuplidor,
        },
        parser: (data) {
          return accesoriosSuplidorFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getCondicionComponente({int? idComponente}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/condiciones-componentes-vehiculo/get-asociados',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          'IdComponente': idComponente,
          'PageSize': 999,
        },
        parser: (data) {
          return condicionComponenteFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getEdicionesVehiculos({required int modeloid}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/infovehiculos/get-ediciones/$modeloid',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return edicionVehiculoFromJson(jsonEncode(data['data']));
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateCondicionComponente({
    required int idSolicitud,
    required Map<String, dynamic> data,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      l.d(idSolicitud);
      l.d(jsonEncode(data));
      return _http.request(
        '/api/condicioncomponentetasacion/update/$idSolicitud',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: data,
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createCondicionComponente({
    // required int idSolicitud,
    required Map<String, dynamic> data,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      // l.d(idSolicitud);
      l.d(jsonEncode(data));
      return _http.request(
        '/api/condicioncomponentetasacion/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: data,
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateAccesoriosTasacion({
    required int idSolicitud,
    required Map<String, dynamic> data,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      l.d(idSolicitud);
      l.d(jsonEncode(data));
      return _http.request(
        '/api/accesoriostasacion/update/$idSolicitud',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: data,
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createAccesoriosTasacion({
    // required int idSolicitud,
    required Map<String, dynamic> data,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      // l.d(idSolicitud);
      l.d(jsonEncode(data));
      return _http.request(
        '/api/accesoriostasacion/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: data,
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getReference({
    required int noTasacion,
    required String chasis,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      final body = {
        "NoTasacion": noTasacion,
        "Chasis": chasis,
      };
      l.d(body);
      return _http.request('/api/procesar-solicitudes/get-reference',
          method: 'GET',
          headers: {
            'Authorization': 'Bearer $_token',
          },
          queryParameters: body, parser: (data) {
        return referenciaValoracionFromJson(jsonEncode(data['data']));
      });
    } else {
      return TokenFail();
    }
  }

  Future<Object> getSalvamento({required String vin}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request('/api/procesar-solicitudes/get-salvamento',
          method: 'GET',
          headers: {
            'Authorization': 'Bearer $_token',
          },
          queryParameters: {
            "vin": vin,
          });
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTasacionCreditoLast({required String chasis}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/get-tasacion-credito-last/$chasis',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTasacionCreditoAverage({
    required String chasis,
    required int periodoMeses,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/get-tasacion-credito-average',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "Chasis": chasis,
          "PeriodoMeses": periodoMeses,
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> aprobarSolicitud({
    required int noSolicitud,
    required int noTasacion,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/aprobar',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "NoSolicitud": noSolicitud,
          "NoTasacion": noTasacion,
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateValoracion({
    required int noTasacion,
    required String valorizacion,
    required bool valorConsultaSalvamento,
    required int valorUltimas3Tasaciones,
    required int valorUltimaEstimacion,
    required int valorCarrosRD,
    required String observacion,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/procesarsolicitudes/update-valoracion',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "noTasacion": noTasacion.toString(),
          "valorizacion": valorizacion.toString(),
          "valorConsultaSalvamento": valorConsultaSalvamento.toString(),
          "valorUltimas3Tasaciones": valorUltimas3Tasaciones.toString(),
          "valorUltimaEstimacion": valorUltimaEstimacion.toString(),
          "valorCarrosRD": valorCarrosRD.toString(),
          "observacion": observacion,
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createNewSolicitudEstimacion({
    required int tipoTasacion,
    required int noSolicitudCredito,
    required String chasis,
    required int marca,
    required int modelo,
    required int ano,
    required int tipoVehiculoLocal,
    required int versionLocal,
    int? serie,
    int? trim,
    required int sistemaTransmision,
    required int traccion,
    required int noPuertas,
    required int noCilindros,
    required int fuerzaMotriz,
    required int nuevoUsado,
    required int kilometraje,
    required String placa,
    required int color,
    int? idPromotor,
    int? edicion,
    /* required String codigoEntidad,
    required String codigoSucursal,
    required String nombreCliente,
    required String identificacion,
    required int idOficial,
    int? suplidorTasacion,*/
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      final body = {
        "tipoTasacion": tipoTasacion,
        "noSolicitudCredito": noSolicitudCredito,
        "chasis": chasis,
        "marca": marca,
        "modelo": modelo,
        "ano": ano,
        "tipoVehiculoLocal": tipoVehiculoLocal,
        "versionLocal": versionLocal,
        "serie": serie,
        "trim": trim,
        "sistemaTransmision": sistemaTransmision,
        "traccion": traccion,
        "noPuertas": noPuertas,
        "noCilindros": noCilindros,
        "fuerzaMotriz": fuerzaMotriz,
        "nuevoUsado": nuevoUsado,
        "kilometraje": kilometraje,
        "placa": placa,
        "color": color,
        "idPromotor": idPromotor,
        "edicion": edicion,
      };
      l.d(body);
      return _http.request(
        '/api/solicitudes/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: body,
        parser: (data) {
          return SolicitudesData.fromJson(data["data"]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> createNewSolicitudTasacion({
    required String codigoEntidad,
    required String codigoSucursal,
    required String nombreCliente,
    required String identificacion,
    required int tipoTasacion,
    required int noSolicitudCredito,
    required int idOficial,
    int? suplidorTasacion,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      final body = {
        "codigoEntidad": codigoEntidad,
        "codigoSucursal": codigoSucursal,
        "nombreCliente": nombreCliente,
        "identificacion": identificacion,
        "tipoTasacion": tipoTasacion,
        "noSolicitudCredito": noSolicitudCredito,
        "idOficial": idOficial,
        "suplidorTasacion": suplidorTasacion,
      };
      l.d(body);
      return _http.request(
        '/api/solicitudes/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: body,
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getColaSolicitudes(
      {List<int> estado = const [],
      int? noSolicitud,
      int pageNumber = 1,
      int pageSize = 20,
      int? idSuplidor,
      List<int> tipoTasacion = const [],
      int? noTasacion,
      String nombreCliente = "",
      String identificacion = "",
      String chasis = ""}) async {
    final params = {
      "EstadosTasacionList": estado,
      "NoSolicitudCredito": noSolicitud,
      "PageSize": pageSize,
      "PageNumber": pageNumber,
      "IdSuplidor": idSuplidor,
      "TiposTasacionList": tipoTasacion,
      "NombreCliente": nombreCliente,
      "Identificacion": identificacion,
      "NoTasacion": noTasacion,
      "Chasis": chasis,
    };
    l.d(params);
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: params,
        parser: (data) {
          return GetSolicitudesResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateSentToProcess({required int noTasacion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/update-send-to-process/$noTasacion',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getSolicitudesSearch({
    required int noSolicitud,
    required int noTasacion,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/search',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "NoSolicitud": noSolicitud,
          "NoTasacion": noTasacion,
        },
        parser: (data) {
          return SolicitudesData.fromJson(data["data"]);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getProcesarSolicitudes() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/procesarsolicitudes/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return GetSolicitudesResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getEstadosSolicitud() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/estadostasacion/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return EstadoSolicitudResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getTiposTasacion() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/tipostasacion/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        parser: (data) {
          return TipoTasacionResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateEstimacion({
    required int id,
    required int sistemaTransmision,
    required int traccion,
    required int noPuertas,
    required int noCilindros,
    required int fuerzaMotriz,
    required int ano,
    required int nuevoUsado,
    required int kilometraje,
    required int color,
    required String placa,
  }) async {
    String? _token = await _authenticationClient.accessToken;

    if (_token != null) {
      final body = {
        "id": id,
        "sistemaTransmision": sistemaTransmision,
        "traccion": traccion,
        "noPuertas": noPuertas,
        "noCilindros": noCilindros,
        "fuerzaMotriz": fuerzaMotriz,
        "ano": ano,
        "nuevoUsado": nuevoUsado,
        "kilometraje": kilometraje,
        "placa": placa,
        "color": color,
      };
      l.i(jsonEncode(body));
      return _http.request(
        '/api/solicitudes/update-estimacion',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: body,
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> updateTasacion({
    required int id,
    required String chasis,
    required int marca,
    required int modelo,
    required int ano,
    required int tipoVehiculoLocal,
    required int versionLocal,
    // required int? serie,
    // required int? trim,
    required int sistemaTransmision,
    required int traccion,
    required int noPuertas,
    required int noCilindros,
    required int fuerzaMotriz,
    required int nuevoUsado,
    required int kilometraje,
    required String placa,
    required int color,
    required int edicion,
  }) async {
    String? _token = await _authenticationClient.accessToken;

    if (_token != null) {
      final body = {
        "id": id,
        "chasis": chasis,
        "marca": marca,
        "modelo": modelo,
        "ano": ano,
        "tipoVehiculoLocal": tipoVehiculoLocal,
        "versionLocal": versionLocal,
        // "serie": serie,
        // "trim": trim,
        "sistemaTransmision": sistemaTransmision,
        "traccion": traccion,
        "noPuertas": noPuertas,
        "noCilindros": noCilindros,
        "fuerzaMotriz": fuerzaMotriz,
        "nuevoUsado": nuevoUsado,
        "kilometraje": kilometraje,
        "placa": placa,
        "color": color,
        "edicion": edicion,
      };
      l.i(jsonEncode(body));
      return _http.request(
        '/api/solicitudes/update-tasacion',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: body,
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> reportesTasacion({required int idTasacion}) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/reportes/tasacion',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {"idSolicitud": idTasacion},
        parser: (data) {
          return Reporte.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
