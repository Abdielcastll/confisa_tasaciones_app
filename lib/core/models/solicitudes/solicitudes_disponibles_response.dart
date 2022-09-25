// To parse this JSON data, do
//
//     final solicitudesDisponibles = solicitudesDisponiblesFromJson(jsonString);

import 'dart:convert';

List<SolicitudesDisponibles> solicitudesDisponiblesFromJson(String str) =>
    List<SolicitudesDisponibles>.from(
        json.decode(str).map((x) => SolicitudesDisponibles.fromJson(x)));

String solicitudesDisponiblesToJson(List<SolicitudesDisponibles> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SolicitudesDisponibles {
  SolicitudesDisponibles({
    this.noSolicitud,
    // this.noCotizacion,
    this.nombreCliente,
    // this.noIdentificacion,
    // this.marca,
    // this.modelo,
    // this.ano,
    // this.precio,
    // this.producto,
    // this.origenNegocio,
    // this.codEntidad,
    // this.entidad,
    // this.codSucursal,
    // this.sucursal,
    // this.codOficialNegocios,
    // this.codigoEmpleadoOficial,
    // this.nombreOficialNegocios,
    // this.estado,
    // this.codigoMarcaEasybank,
    // this.codigoModeloEasybank,
    // this.idMarcaTasaciones,
    // this.idModeloTasaciones,
    // this.email,
    // this.idSuplidor,
  });

  int? noSolicitud;
  // int? noCotizacion;
  String? nombreCliente;
  /* String? noIdentificacion;
  String? marca;
  String? modelo;
  String? ano;
  int? precio;
  String? producto;
  String? origenNegocio;
  String? codEntidad;
  String? entidad;
  String? codSucursal;
  String? sucursal;
  int? codOficialNegocios;
  int? codigoEmpleadoOficial;
  String? nombreOficialNegocios;
  int? estado;
  int? codigoMarcaEasybank;
  int? codigoModeloEasybank;
  int? idMarcaTasaciones;
  int? idModeloTasaciones;
  String? email;
  int? idSuplidor;*/

  factory SolicitudesDisponibles.fromJson(Map<String, dynamic> json) =>
      SolicitudesDisponibles(
        noSolicitud: json["noSolicitud"],
        nombreCliente: json["nombreCliente"],
        /*  noCotizacion: json["noCotizacion"],
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
        codigoEmpleadoOficial: json["codigoEmpleadoOficial"],
        nombreOficialNegocios: json["nombreOficialNegocios"],
        estado: json["estado"],
        codigoMarcaEasybank: json["codigoMarcaEasybank"],
        codigoModeloEasybank: json["codigoModeloEasybank"],
        idMarcaTasaciones: json["idMarcaTasaciones"],
        idModeloTasaciones: json["idModeloTasaciones"],
        email: json["email"],
        idSuplidor: json["idSuplidor"],*/
      );

  Map<String, dynamic> toJson() => {
        "noSolicitud": noSolicitud,
        "nombreCliente": nombreCliente,
        /* "noCotizacion": noCotizacion,
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
        "codigoEmpleadoOficial": codigoEmpleadoOficial,
        "nombreOficialNegocios": nombreOficialNegocios,
        "estado": estado,
        "codigoMarcaEasybank": codigoMarcaEasybank,
        "codigoModeloEasybank": codigoModeloEasybank,
        "idMarcaTasaciones": idMarcaTasaciones,
        "idModeloTasaciones": idModeloTasaciones,
        "email": email,
        "idSuplidor": idSuplidor,*/
      };
}
