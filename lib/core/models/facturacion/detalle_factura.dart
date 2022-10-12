// To parse this JSON data, do
//
//     final detalleFactura = detalleFacturaFromJson(jsonString);

import 'dart:convert';

DetalleFactura detalleFacturaFromJson(String str) =>
    DetalleFactura.fromJson(json.decode(str));

String detalleFacturaToJson(DetalleFactura data) => json.encode(data.toJson());

class DetalleFactura {
  DetalleFactura({
    this.idSuplidor,
    this.suplidor,
    this.rnc,
    this.direccion,
    this.codigoEntidad,
    this.entidad,
    this.ncf,
    this.subTotal,
    this.itbis,
    this.honorarios,
    this.totalGeneral,
    this.noFactura,
    this.estadoFactura,
    this.detalleSucursales,
  });

  int? idSuplidor;
  String? suplidor;
  String? rnc;
  String? direccion;
  String? codigoEntidad;
  String? entidad;
  String? ncf;
  double? subTotal;
  double? itbis;
  double? honorarios;
  double? totalGeneral;
  int? noFactura;
  int? estadoFactura;
  List<DetalleSucursale>? detalleSucursales;

  factory DetalleFactura.fromJson(Map<String, dynamic> json) => DetalleFactura(
        idSuplidor: json["idSuplidor"],
        suplidor: json["suplidor"],
        rnc: json["rnc"],
        direccion: json["direccion"],
        codigoEntidad: json["codigoEntidad"],
        entidad: json["entidad"],
        ncf: json["ncf"],
        subTotal: json["subTotal"].toDouble(),
        itbis: json["itbis"].toDouble(),
        honorarios: json["honorarios"],
        totalGeneral: json["totalGeneral"],
        noFactura: json["noFactura"],
        estadoFactura: json["estadoFactura"],
        detalleSucursales: List<DetalleSucursale>.from(
            json["detalleSucursales"].map((x) => DetalleSucursale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idSuplidor": idSuplidor,
        "suplidor": suplidor,
        "rnc": rnc,
        "direccion": direccion,
        "codigoEntidad": codigoEntidad,
        "entidad": entidad,
        "ncf": ncf,
        "subTotal": subTotal,
        "itbis": itbis,
        "honorarios": honorarios,
        "totalGeneral": totalGeneral,
        "noFactura": noFactura,
        "estadoFactura": estadoFactura,
        "detalleSucursales":
            List<dynamic>.from(detalleSucursales!.map((x) => x.toJson())),
      };
}

class DetalleSucursale {
  DetalleSucursale({
    this.nombreSucursal,
    this.idSucursal,
    this.tasacionesReserva,
    this.totalReservas,
    this.subTotalSucursal,
    this.itbisSucursal,
    this.totalGeneralSucursal,
    this.tasacionesGastos,
    this.honorarios,
    this.totalGastos,
  });

  String? nombreSucursal;
  String? idSucursal;
  double? subTotalSucursal;
  double? itbisSucursal;
  double? totalGeneralSucursal;
  List<Tasaciones>? tasacionesReserva;
  List<Tasaciones>? tasacionesGastos;
  double? honorarios;
  double? totalReservas;
  double? totalGastos;

  factory DetalleSucursale.fromJson(Map<String, dynamic> json) =>
      DetalleSucursale(
        nombreSucursal: json["nombreSucursal"],
        idSucursal: json["idSucursal"],
        subTotalSucursal: json["subTotalSucursal"].toDouble(),
        itbisSucursal: json["itbisSucursal"].toDouble(),
        totalGeneralSucursal: json["totalGeneralSucursal"],
        tasacionesReserva: List<Tasaciones>.from(
            json["tasacionesReserva"].map((x) => Tasaciones.fromJson(x))),
        tasacionesGastos: List<Tasaciones>.from(
            json["tasacionesGastos"].map((x) => Tasaciones.fromJson(x))),
        honorarios: json["honorariosSucursal"],
        totalReservas: json["totalReservas"],
        totalGastos: json["totalGastos"],
      );

  Map<String, dynamic> toJson() => {
        "nombreSucursal": nombreSucursal,
        "idSucursal": idSucursal,
        "subTotalSucursal": subTotalSucursal,
        "itbisSucursal": itbisSucursal,
        "totalGeneralSucursal": totalGeneralSucursal,
        "tasacionesReserva":
            List<dynamic>.from(tasacionesReserva!.map((x) => x.toJson())),
        "tasacionesGastos":
            List<dynamic>.from(tasacionesGastos!.map((x) => x.toJson())),
        "honorariosSucursal": honorarios,
        "totalReservas": totalReservas,
        "totalGastos": totalGastos,
      };
}

class Tasaciones {
  Tasaciones({
    this.noTasacion,
    this.idCredito,
    this.fechaTransaccion,
    this.nombreCliente,
    this.cedulaCliente,
    this.costo,
  });

  int? noTasacion;
  int? idCredito;
  DateTime? fechaTransaccion;
  String? nombreCliente;
  String? cedulaCliente;
  double? costo;

  factory Tasaciones.fromJson(Map<String, dynamic> json) => Tasaciones(
        noTasacion: json["noTasacion"],
        idCredito: json["idCredito"],
        fechaTransaccion: DateTime.parse(json["fechaTransaccion"]),
        nombreCliente: json["nombreCliente"],
        cedulaCliente: json["cedulaCliente"],
        costo: json["costo"],
      );

  Map<String, dynamic> toJson() => {
        "noTasacion": noTasacion,
        "idCredito": idCredito,
        "fechaTransaccion": fechaTransaccion?.toIso8601String(),
        "nombreCliente": nombreCliente,
        "cedulaCliente": cedulaCliente,
        "costo": costo,
      };
}
