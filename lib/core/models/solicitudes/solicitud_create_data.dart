// To parse this JSON data, do
//
//     final solicitudCreateData = solicitudCreateDataFromJson(jsonString);

import 'dart:convert';

SolicitudCreateData solicitudCreateDataFromJson(String str) =>
    SolicitudCreateData.fromJson(json.decode(str));

String solicitudCreateDataToJson(SolicitudCreateData data) =>
    json.encode(data.toJson());

class SolicitudCreateData {
  SolicitudCreateData({
    this.tipoTasacion,
    this.noSolicitudCredito,
    this.suplidorTasacion,
    this.idOficial,
    this.codigoEntidad,
    this.codigoSucursal,
    this.nombreCliente,
    this.identificacion,
    this.fecha,
    this.chasis,
    this.marca,
    this.modelo,
    this.ano,
    this.tipoVehiculoLocal,
    this.versionLocal,
    this.serie,
    this.trim,
    this.sistemaTransmision,
    this.traccion,
    this.noPuertas,
    this.noCilindros,
    this.fuerzaMotriz,
    this.nuevoUsado,
    this.kilometraje,
    this.placa,
    this.color,
    this.idPromotor,
    this.edicion,
  });

  int? tipoTasacion;
  int? noSolicitudCredito;
  int? suplidorTasacion;
  int? idOficial;
  String? codigoEntidad;
  String? codigoSucursal;
  String? nombreCliente;
  String? identificacion;
  DateTime? fecha;
  String? chasis;
  int? marca;
  int? modelo;
  int? ano;
  int? tipoVehiculoLocal;
  int? versionLocal;
  int? serie;
  int? trim;
  int? sistemaTransmision;
  int? traccion;
  int? noPuertas;
  int? noCilindros;
  int? fuerzaMotriz;
  int? nuevoUsado;
  int? kilometraje;
  String? placa;
  int? color;
  int? idPromotor;
  int? edicion;

  factory SolicitudCreateData.fromJson(Map<String, dynamic> json) =>
      SolicitudCreateData(
        tipoTasacion: json["tipoTasacion"],
        noSolicitudCredito: json["noSolicitudCredito"],
        suplidorTasacion: json["suplidorTasacion"],
        idOficial: json["idOficial"],
        codigoEntidad: json["codigoEntidad"],
        codigoSucursal: json["codigoSucursal"],
        nombreCliente: json["nombreCliente"],
        identificacion: json["identificacion"],
        fecha: DateTime.parse(json["fecha"]),
        chasis: json["chasis"],
        marca: json["marca"],
        modelo: json["modelo"],
        ano: json["ano"],
        tipoVehiculoLocal: json["tipoVehiculoLocal"],
        versionLocal: json["versionLocal"],
        serie: json["serie"],
        trim: json["trim"],
        sistemaTransmision: json["sistemaTransmision"],
        traccion: json["traccion"],
        noPuertas: json["noPuertas"],
        noCilindros: json["noCilindros"],
        fuerzaMotriz: json["fuerzaMotriz"],
        nuevoUsado: json["nuevoUsado"],
        kilometraje: json["kilometraje"],
        placa: json["placa"],
        color: json["color"],
        idPromotor: json["idPromotor"],
        edicion: json["edicion"],
      );

  Map<String, dynamic> toJson() => {
        "tipoTasacion": tipoTasacion ?? 0,
        "noSolicitudCredito": noSolicitudCredito ?? 0,
        "suplidorTasacion": suplidorTasacion ?? 0,
        "idOficial": idOficial ?? 0,
        "codigoEntidad": codigoEntidad ?? '',
        "codigoSucursal": codigoSucursal ?? '',
        "nombreCliente": nombreCliente ?? '',
        "identificacion": identificacion ?? '',
        "fecha": fecha?.toIso8601String() ?? '',
        "chasis": chasis ?? '',
        "marca": marca ?? 0,
        "modelo": modelo ?? 0,
        "ano": ano ?? 0,
        "tipoVehiculoLocal": tipoVehiculoLocal ?? 0,
        "versionLocal": versionLocal ?? 0,
        "serie": serie ?? 0,
        "trim": trim ?? 0,
        "sistemaTransmision": sistemaTransmision ?? 0,
        "traccion": traccion ?? 0,
        "noPuertas": noPuertas ?? 0,
        "noCilindros": noCilindros ?? 0,
        "fuerzaMotriz": fuerzaMotriz ?? 0,
        "nuevoUsado": nuevoUsado ?? 0,
        "kilometraje": kilometraje ?? 0,
        "placa": placa ?? '',
        "color": color ?? 0,
        "idPromotor": idPromotor ?? 0,
        "edicion": edicion ?? 0,
      };
}
