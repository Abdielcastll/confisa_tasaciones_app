// To parse this JSON data, do
//
//     final solicitudCreditoResponse = solicitudCreditoResponseFromJson(jsonString);

import 'dart:convert';

SolicitudCreditoResponse solicitudCreditoResponseFromJson(String str) =>
    SolicitudCreditoResponse.fromJson(json.decode(str));

String solicitudCreditoResponseToJson(SolicitudCreditoResponse data) =>
    json.encode(data.toJson());

class SolicitudCreditoResponse {
  SolicitudCreditoResponse({
    required this.data,
  });

  SolicitudCreditoData data;

  factory SolicitudCreditoResponse.fromJson(Map<String, dynamic> json) =>
      SolicitudCreditoResponse(
        data: SolicitudCreditoData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class SolicitudCreditoData {
  SolicitudCreditoData({
    this.noSolicitud,
    this.noCotizacion,
    this.nombreCliente,
    this.noIdentificacion,
    this.marca,
    this.modelo,
    this.ano,
    this.precio,
    this.producto,
    this.origenNegocio,
    this.codEntidad,
    this.entidad,
    this.codSucursal,
    this.sucursal,
    this.codOficialNegocios,
    this.nombreOficialNegocios,
    this.chasis,
    this.estado,
    this.codigoMarcaEasybank,
    this.codigoModeloEasybank,
    this.idMarcaTasaciones,
    this.idModeloTasaciones,
  });

  int? noSolicitud;
  int? noCotizacion;
  String? nombreCliente;
  String? noIdentificacion;
  String? marca;
  String? modelo;
  String? ano;
  double? precio;
  String? producto;
  String? origenNegocio;
  String? codEntidad;
  String? entidad;
  String? codSucursal;
  String? sucursal;
  int? codOficialNegocios;
  String? nombreOficialNegocios;
  String? chasis;
  int? estado;
  int? codigoMarcaEasybank;
  int? codigoModeloEasybank;
  int? idMarcaTasaciones;
  int? idModeloTasaciones;

  factory SolicitudCreditoData.fromJson(Map<String, dynamic> json) =>
      SolicitudCreditoData(
        noSolicitud: json["noSolicitud"],
        noCotizacion: json["noCotizacion"],
        nombreCliente: json["nombreCliente"],
        noIdentificacion: json["noIdentificacion"],
        marca: json["marca"],
        modelo: json["modelo"],
        ano: json["ano"],
        precio: json["precio"],
        producto: json["producto"],
        origenNegocio: json["origenNegocio"],
        codEntidad: json["codEntidad"],
        entidad: json["entidad"],
        codSucursal: json["codSucursal"],
        sucursal: json["sucursal"],
        codOficialNegocios: json["codOficialNegocios"],
        nombreOficialNegocios: json["nombreOficialNegocios"],
        chasis: json["chasis"],
        estado: json["estado"],
        codigoMarcaEasybank: json["codigoMarcaEasybank"],
        codigoModeloEasybank: json["codigoModeloEasybank"],
        idMarcaTasaciones: json["idMarcaTasaciones"],
        idModeloTasaciones: json["idModeloTasaciones"],
      );

  Map<String, dynamic> toJson() => {
        "noSolicitud": noSolicitud,
        "noCotizacion": noCotizacion,
        "nombreCliente": nombreCliente,
        "noIdentificacion": noIdentificacion,
        "marca": marca,
        "modelo": modelo,
        "ano": ano,
        "precio": precio,
        "producto": producto,
        "origenNegocio": origenNegocio,
        "codEntidad": codEntidad,
        "entidad": entidad,
        "codSucursal": codSucursal,
        "sucursal": sucursal,
        "codOficialNegocios": codOficialNegocios,
        "nombreOficialNegocios": nombreOficialNegocios,
        "chasis": chasis,
        "estado": estado,
        "codigoMarcaEasybank": codigoMarcaEasybank,
        "codigoModeloEasybank": codigoModeloEasybank,
        "idMarcaTasaciones": idMarcaTasaciones,
        "idModeloTasaciones": idModeloTasaciones,
      };
}
