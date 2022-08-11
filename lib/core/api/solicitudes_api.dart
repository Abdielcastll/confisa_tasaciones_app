import 'package:tasaciones_app/core/models/cantidad_fotos_response.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/solicitud_create_data.dart';
import 'package:tasaciones_app/core/models/solicitud_credito_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/tracciones_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';

import '../authentication_client.dart';
import '../models/vin_decoder_response.dart';
import 'api_status.dart';
import 'http.dart';

class SolicitudesApi {
  SolicitudesApi(this._http, this._authenticationClient);
  final Http _http;
  final AuthenticationClient _authenticationClient;

/*
***********  Solicitud de estimacion **************

/api/solicitudcredito/get/{idSolicitud} ----------------------------------LISTA
/api/vins/vin-decoder-----------------------------------------------------LISTA
/api/tiposcondicionesvehiculos/get----------------------------------------LISTA
/api/infovehiculos/get-marcas
/api/infovehiculos/get-modelos
/api/infovehiculos/get-ediciones/{modeloid}
/api/infovehiculos/get-versiones
/api/infovehiculos/get-tipos-vehiculo
/api/infovehiculos/get-tracciones
/api/infovehiculos/get-transmisiones
/api/solicitudes/create
*/

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

  Future<Object> createNewSolicitud(SolicitudCreateData data) async {
    String? _token = await _authenticationClient.accessToken;
    if (_token != null) {
      return _http.request(
        '/api/solicitudes/create',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        data: data.toJson(),
        // parser: (data) {
        //   return EntidadResponse.fromJson(data);
        // },
      );
    } else {
      return TokenFail();
    }
  }
}
