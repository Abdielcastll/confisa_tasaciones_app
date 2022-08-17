import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/tracciones_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';

import '../authentication_client.dart';
import '../models/solicitudes/solicitud_create_data.dart';
import '../models/solicitudes/solicitud_credito_response.dart';
import '../models/vin_decoder_response.dart';
import 'api_status.dart';
import 'http.dart';

class SolicitudesApi {
  SolicitudesApi(this._http, this._authenticationClient);
  final Http _http;
  final AuthenticationClient _authenticationClient;

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

  Future<Object> getCantidadFotos() async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/fotos/get-cantidad',
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

  Future<Object> createNewSolicitudEstimacion({
    required String codigoEntidad,
    required String codigoSucursal,
    required String nombreCliente,
    required String identificacion,
    required String chasis,
    required String placa,
    required int tipoTasacion,
    required int noSolicitudCredito,
    required int idOficial,
    required int marca,
    required int modelo,
    required int ano,
    required int tipoVehiculoLocal,
    required int versionLocal,
    required int sistemaTransmision,
    required int traccion,
    required int noPuertas,
    required int noCilindros,
    required int fuerzaMotriz,
    required int nuevoUsado,
    required int kilometraje,
    required int color,
    required int edicion,
    int? suplidorTasacion,
    int? serie,
    int? trim,
    int? idPromotor,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "codigoEntidad": codigoEntidad,
          "codigoSucursal": codigoSucursal,
          "nombreCliente": nombreCliente,
          "identificacion": identificacion,
          "chasis": chasis,
          "placa": placa,
          "tipoTasacion": tipoTasacion,
          "noSolicitudCredito": noSolicitudCredito,
          "idOficial": idOficial,
          "marca": marca,
          "modelo": modelo,
          "ano": ano,
          "tipoVehiculoLocal": tipoVehiculoLocal,
          "versionLocal": versionLocal,
          "sistemaTransmision": sistemaTransmision,
          "traccion": traccion,
          "noPuertas": noPuertas,
          "noCilindros": noCilindros,
          "fuerzaMotriz": fuerzaMotriz,
          "nuevoUsado": nuevoUsado,
          "kilometraje": kilometraje,
          "color": color,
          "edicion": edicion,
          "suplidorTasacion": suplidorTasacion,
          "serie": serie,
          "trim": trim,
          "idPromotor": idPromotor,
        },
        // parser: (data) {
        //   return EntidadResponse.fromJson(data);
        // },
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
      return _http.request(
        '/api/solicitudes/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: {
          "codigoEntidad": codigoEntidad,
          "codigoSucursal": codigoSucursal,
          "nombreCliente": nombreCliente,
          "identificacion": identificacion,
          "tipoTasacion": tipoTasacion,
          "noSolicitudCredito": noSolicitudCredito,
          "idOficial": idOficial,
          "suplidorTasacion": suplidorTasacion,
        },
        // parser: (data) {
        //   return EntidadResponse.fromJson(data);
        // },
      );
    } else {
      return TokenFail();
    }
  }

  Future<Object> getColaSolicitudes({
    int? noSolicitud,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/get',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        queryParameters: {
          "NoSolicitudCredito": noSolicitud,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
        },
        parser: (data) {
          return GetSolicitudesResponse.fromJson(data);
        },
      );
    } else {
      return TokenFail();
    }
  }
}
