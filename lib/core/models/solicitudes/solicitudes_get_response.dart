// To parse this JSON data, do
//
//     final getSolicitudesResponse = getSolicitudesResponseFromJson(jsonString);

// ignore_for_file: unnecessary_null_in_if_null_operators, prefer_null_aware_operators

import 'dart:convert';

GetSolicitudesResponse getSolicitudesResponseFromJson(String str) =>
    GetSolicitudesResponse.fromJson(json.decode(str));

String getSolicitudesResponseToJson(GetSolicitudesResponse data) =>
    json.encode(data.toJson());

class GetSolicitudesResponse {
  GetSolicitudesResponse({
    required this.data,
    this.totalCount,
    this.totalPages,
    this.pageSize,
    this.currentPage,
    this.hasNextPage,
    this.hasPreviousPage,
    this.nextPageUrl,
  });

  List<SolicitudesData> data;
  String? nextPageUrl;
  int? totalCount, pageSize, currentPage, totalPages;
  bool? hasNextPage, hasPreviousPage;

  factory GetSolicitudesResponse.fromJson(Map<String, dynamic> json) =>
      GetSolicitudesResponse(
          data: List<SolicitudesData>.from(
              json["data"].map((x) => SolicitudesData.fromJson(x))),
          totalCount: json["meta"]?["totalCount"],
          totalPages: json["meta"]?["totalPages"],
          pageSize: json["meta"]?["pageSize"],
          currentPage: json["meta"]?["currentPage"],
          hasNextPage: json["meta"]?["hasNextPage"],
          hasPreviousPage: json["meta"]?["hasPreviousPage"],
          nextPageUrl: json["meta"]?["nextPageUrl"]);

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
        "totalPage": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
        "nextPageUrl": totalCount,
      };
}

class SolicitudesData {
  SolicitudesData({
    this.id,
    this.noTasacion,
    this.noSolicitudCredito,
    this.suplidorTasacion,
    this.descripcionSuplidorTasacion,
    this.idOficial,
    this.estadoTasacion,
    this.descripcionEstadoTasacion,
    this.tipoTasacion,
    this.descripcionTipoTasacion,
    this.codigoEntidad,
    this.codigoSucursal,
    this.descripcionSucursal,
    this.nombreCliente,
    this.identificacion,
    this.observacion,
    this.tasacionAutorizada,
    this.valorTasacion,
    this.fechaCreada,
    this.fechaSolicitada,
    this.fechaValorada,
    this.fechaAprobada,
    this.fechaVencimiento,
    this.aprobada,
    this.aprobador,
    this.noFactura,
    this.valorEstimacion,
    this.valorUltimas3Tasaciones,
    this.valorCarrosRd,
    this.valorFacturacion,
    this.chasis,
    this.marca,
    this.descripcionMarca,
    this.modelo,
    this.descripcionModelo,
    this.ano,
    this.tipoVehiculoLocal,
    this.descripcionTipoVehiculoLocal,
    this.tipoVehiculo,
    this.versionLocal,
    this.serie,
    this.descripcionSerie,
    this.trim,
    this.descripcionTrim,
    this.sistemaTransmision,
    this.descripcionSistemaTransmision,
    this.traccion,
    this.descripcionTraccion,
    this.noPuertas,
    this.noCilindros,
    this.fuerzaMotriz,
    this.nuevoUsado,
    this.descripcionNuevoUsado,
    this.kilometraje,
    this.placa,
    this.frontal,
    this.descripcionFrontal,
    this.lateralDerecho,
    this.descripcionLateralDerecho,
    this.lateraIzquierdo,
    this.descripcionLateraIzquierdo,
    this.puertaDerecha,
    this.descripcionPuertaDerecha,
    this.puertaIzquierda,
    this.descripcionPuertaIzquierda,
    this.puertaTraseraDerecha,
    this.descripcionPuertaTraseraDerecha,
    this.puertaTraseraIzquierda,
    this.descripcionPuertaTraseraIzquierda,
    this.parteTrasera,
    this.descripcionParteTrasera,
    this.capota,
    this.descripcionCapota,
    this.bumperDelantero,
    this.descripcionBumperDelantero,
    this.bumberTrasero,
    this.descripcionBumberTrasero,
    this.asientoDelantero,
    this.descripcionAsientoDelantero,
    this.asientoTrasero,
    this.descripcionAsientoTrasero,
    this.plafones,
    this.descripcionPlafones,
    this.cristalesLateralIzquierdo,
    this.descripcionCristalesLateralIzquierdo,
    this.cristalesLateralDerecho,
    this.descripcionCristalesLateralDerecho,
    this.cristalesTrasero,
    this.descripcionCristalesTrasero,
    this.cristalesDelantero,
    this.descripcionCristalesDelantero,
    this.farolesDelanteros,
    this.descripcionFarolesDelanteros,
    this.farolesTraseros,
    this.descripcionFarolesTraseros,
    this.faloresDirecciones,
    this.descripcionFaloresDirecciones,
    this.retrovisores,
    this.descripcionRetrovisores,
    this.motor,
    this.descripcionMotor,
    this.transmision,
    this.descripcionTransmision,
    this.suspension,
    this.descripcionSuspension,
    this.partesElectricas,
    this.descripcionPartesElectricas,
    this.rodamientos,
    this.descripcionRodamientos,
    this.trenDelantero,
    this.descripcionTrenDelantero,
    this.color,
    this.descripcionColor,
    this.tasador,
    this.nombreTasador,
    this.idPromotor,
    this.condicionComponenteTasacion,
    this.accesoriosTasacion,
    this.nota,
    this.descripcionEntidad,
    this.isSalvage,
    this.nombreOficial,
    this.edicion,
    this.descripcionEdicion,
    this.descripcionVersion,
  });

  int? id;
  int? noTasacion;
  int? noSolicitudCredito;
  int? suplidorTasacion;
  String? descripcionSuplidorTasacion;
  int? idOficial;
  String? nombreOficial;
  int? estadoTasacion;
  int? edicion;
  String? descripcionEntidad;
  String? descripcionEstadoTasacion;
  int? tipoTasacion;
  String? descripcionTipoTasacion;
  String? codigoEntidad;
  String? codigoSucursal;
  String? descripcionSucursal;
  String? nombreCliente;
  String? identificacion;
  String? observacion;
  int? tasacionAutorizada;
  double? valorTasacion;
  DateTime? fechaCreada;
  DateTime? fechaSolicitada;
  DateTime? fechaValorada;
  DateTime? fechaAprobada;
  DateTime? fechaVencimiento;
  int? aprobada;
  String? aprobador;
  int? noFactura;
  double? valorEstimacion;
  double? valorUltimas3Tasaciones;
  double? valorCarrosRd;
  double? valorFacturacion;
  String? chasis;
  int? marca;
  String? descripcionMarca;
  int? modelo;
  String? descripcionModelo;
  int? ano;
  int? tipoVehiculoLocal;
  String? descripcionTipoVehiculoLocal;
  int? tipoVehiculo;
  int? versionLocal;
  int? serie;
  String? descripcionSerie;
  String? descripcionVersion;
  String? descripcionEdicion;
  int? trim;
  String? descripcionTrim;
  int? sistemaTransmision;
  String? descripcionSistemaTransmision;
  int? traccion;
  String? descripcionTraccion;
  int? noPuertas;
  int? noCilindros;
  int? fuerzaMotriz;
  int? nuevoUsado;
  String? descripcionNuevoUsado;
  double? kilometraje;
  String? placa;
  int? frontal;
  String? descripcionFrontal;
  int? lateralDerecho;
  String? descripcionLateralDerecho;
  int? lateraIzquierdo;
  String? descripcionLateraIzquierdo;
  int? puertaDerecha;
  String? descripcionPuertaDerecha;
  int? puertaIzquierda;
  String? descripcionPuertaIzquierda;
  int? puertaTraseraDerecha;
  String? descripcionPuertaTraseraDerecha;
  int? puertaTraseraIzquierda;
  String? descripcionPuertaTraseraIzquierda;
  int? parteTrasera;
  String? descripcionParteTrasera;
  int? capota;
  String? descripcionCapota;
  int? bumperDelantero;
  String? descripcionBumperDelantero;
  int? bumberTrasero;
  String? descripcionBumberTrasero;
  int? asientoDelantero;
  String? descripcionAsientoDelantero;
  int? asientoTrasero;
  String? descripcionAsientoTrasero;
  int? plafones;
  String? descripcionPlafones;
  int? cristalesLateralIzquierdo;
  String? descripcionCristalesLateralIzquierdo;
  int? cristalesLateralDerecho;
  String? descripcionCristalesLateralDerecho;
  int? cristalesTrasero;
  String? descripcionCristalesTrasero;
  int? cristalesDelantero;
  String? descripcionCristalesDelantero;
  int? farolesDelanteros;
  String? descripcionFarolesDelanteros;
  int? farolesTraseros;
  String? descripcionFarolesTraseros;
  int? faloresDirecciones;
  String? descripcionFaloresDirecciones;
  int? retrovisores;
  String? descripcionRetrovisores;
  int? motor;
  String? descripcionMotor;
  int? transmision;
  String? descripcionTransmision;
  int? suspension;
  String? descripcionSuspension;
  int? partesElectricas;
  String? descripcionPartesElectricas;
  int? rodamientos;
  String? descripcionRodamientos;
  int? trenDelantero;
  String? descripcionTrenDelantero;
  int? color;
  String? descripcionColor;
  String? tasador;
  String? nombreTasador;
  int? idPromotor;
  List<CondicionComponenteTasacion>? condicionComponenteTasacion;
  List<AccesoriosTasacion>? accesoriosTasacion;
  Nota? nota;
  bool? isSalvage;

  factory SolicitudesData.fromJson(Map<String, dynamic> json) =>
      SolicitudesData(
        id: json["id"] ?? null,
        noTasacion: json["noTasacion"] ?? null,
        noSolicitudCredito: json["noSolicitudCredito"] ?? null,
        suplidorTasacion: json["suplidorTasacion"] ?? null,
        descripcionSuplidorTasacion:
            json["descripcionSuplidorTasacion"] ?? null,
        idOficial: json["idOficial"] ?? null,
        nombreOficial: json["nombreOficial"] ?? null,
        estadoTasacion: json["estadoTasacion"] ?? null,
        descripcionEstadoTasacion: json["descripcionEstadoTasacion"] ?? null,
        tipoTasacion: json["tipoTasacion"] ?? null,
        descripcionTipoTasacion: json["descripcionTipoTasacion"] ?? null,
        codigoEntidad: json["codigoEntidad"] ?? null,
        codigoSucursal: json["codigoSucursal"] ?? null,
        descripcionSucursal: json["descripcionSucursal"] ?? null,
        nombreCliente: json["nombreCliente"] ?? null,
        identificacion: json["identificacion"] ?? null,
        observacion: json["observacion"] ?? null,
        tasacionAutorizada: json["tasacionAutorizada"] ?? null,
        valorTasacion: json["valorTasacion"] ?? null,
        descripcionEdicion: json["descripcionEdicion"] ?? null,
        descripcionVersion: json["descripcionVersion"] ?? null,
        fechaCreada: json["fechaCreada"] == null
            ? null
            : DateTime.parse(json["fechaCreada"]),
        fechaSolicitada: json["fechaSolicitada"] == null
            ? null
            : DateTime.parse(json["fechaSolicitada"]),
        fechaValorada: json["fechaValorada"] == null
            ? null
            : DateTime.parse(json["fechaValorada"]),
        fechaAprobada: json["fechaAprobada"] == null
            ? null
            : DateTime.parse(json["fechaAprobada"]),
        fechaVencimiento: json["fechaVencimiento"] == null
            ? null
            : DateTime.parse(json["fechaVencimiento"]),
        aprobada: json["aprobada"] ?? null,
        aprobador: json["aprobador"] ?? null,
        noFactura: json["noFactura"] ?? null,
        valorEstimacion: json["valorEstimacion"] ?? null,
        valorUltimas3Tasaciones: json["valorUltimas3Tasaciones"] ?? null,
        valorCarrosRd: json["valorCarrosRd"] ?? null,
        valorFacturacion: json["valorFacturacion"] ?? null,
        chasis: json["chasis"] ?? null,
        marca: json["marca"] ?? null,
        descripcionMarca: json["descripcionMarca"] ?? null,
        modelo: json["modelo"] ?? null,
        descripcionModelo: json["descripcionModelo"] ?? null,
        ano: json["ano"] ?? null,
        tipoVehiculoLocal: json["tipoVehiculoLocal"] ?? null,
        descripcionTipoVehiculoLocal:
            json["descripcionTipoVehiculoLocal"] ?? null,
        tipoVehiculo: json["tipoVehiculo"] ?? null,
        versionLocal: json["versionLocal"] ?? null,
        serie: json["serie"] ?? null,
        descripcionSerie: json["descripcionSerie"] ?? null,
        trim: json["trim"] ?? null,
        descripcionTrim: json["descripcionTrim"] ?? null,
        sistemaTransmision: json["sistemaTransmision"] ?? null,
        descripcionSistemaTransmision:
            json["descripcionSistemaTransmision"] ?? null,
        traccion: json["traccion"] ?? null,
        descripcionTraccion: json["descripcionTraccion"] ?? null,
        noPuertas: json["noPuertas"] ?? null,
        noCilindros: json["noCilindros"] ?? null,
        fuerzaMotriz: json["fuerzaMotriz"] ?? null,
        nuevoUsado: json["nuevoUsado"] ?? null,
        descripcionNuevoUsado: json["descripcionNuevoUsado"] ?? null,
        kilometraje: json["kilometraje"] ?? null,
        placa: json["placa"] ?? null,
        frontal: json["frontal"] ?? null,
        descripcionFrontal: json["descripcionFrontal"] ?? null,
        lateralDerecho: json["lateralDerecho"] ?? null,
        descripcionLateralDerecho: json["descripcionLateralDerecho"] ?? null,
        lateraIzquierdo: json["lateraIzquierdo"] ?? null,
        descripcionLateraIzquierdo: json["descripcionLateraIzquierdo"] ?? null,
        puertaDerecha: json["puertaDerecha"] ?? null,
        edicion: json["edicion"] ?? null,
        descripcionPuertaDerecha: json["descripcionPuertaDerecha"] ?? null,
        puertaIzquierda: json["puertaIzquierda"] ?? null,
        descripcionPuertaIzquierda: json["descripcionPuertaIzquierda"] ?? null,
        puertaTraseraDerecha: json["puertaTraseraDerecha"] ?? null,
        descripcionPuertaTraseraDerecha:
            json["descripcionPuertaTraseraDerecha"] ?? null,
        puertaTraseraIzquierda: json["puertaTraseraIzquierda"] ?? null,
        descripcionPuertaTraseraIzquierda:
            json["descripcionPuertaTraseraIzquierda"] ?? null,
        parteTrasera: json["parteTrasera"] ?? null,
        descripcionParteTrasera: json["descripcionParteTrasera"] ?? null,
        capota: json["capota"] ?? null,
        descripcionCapota: json["descripcionCapota"] ?? null,
        bumperDelantero: json["bumperDelantero"] ?? null,
        descripcionBumperDelantero: json["descripcionBumperDelantero"] ?? null,
        bumberTrasero: json["bumberTrasero"] ?? null,
        descripcionBumberTrasero: json["descripcionBumberTrasero"] ?? null,
        asientoDelantero: json["asientoDelantero"] ?? null,
        descripcionAsientoDelantero:
            json["descripcionAsientoDelantero"] ?? null,
        asientoTrasero: json["asientoTrasero"] ?? null,
        descripcionAsientoTrasero: json["descripcionAsientoTrasero"] ?? null,
        plafones: json["plafones"] ?? null,
        descripcionPlafones: json["descripcionPlafones"] ?? null,
        cristalesLateralIzquierdo: json["cristalesLateralIzquierdo"] ?? null,
        descripcionCristalesLateralIzquierdo:
            json["descripcionCristalesLateralIzquierdo"] ?? null,
        cristalesLateralDerecho: json["cristalesLateralDerecho"] ?? null,
        descripcionCristalesLateralDerecho:
            json["descripcionCristalesLateralDerecho"] ?? null,
        cristalesTrasero: json["cristalesTrasero"] ?? null,
        descripcionCristalesTrasero:
            json["descripcionCristalesTrasero"] ?? null,
        cristalesDelantero: json["cristalesDelantero"] ?? null,
        descripcionCristalesDelantero:
            json["descripcionCristalesDelantero"] ?? null,
        farolesDelanteros: json["farolesDelanteros"] ?? null,
        descripcionFarolesDelanteros:
            json["descripcionFarolesDelanteros"] ?? null,
        farolesTraseros: json["farolesTraseros"] ?? null,
        descripcionFarolesTraseros: json["descripcionFarolesTraseros"] ?? null,
        faloresDirecciones: json["faloresDirecciones"] ?? null,
        descripcionFaloresDirecciones:
            json["descripcionFaloresDirecciones"] ?? null,
        retrovisores: json["retrovisores"] ?? null,
        descripcionRetrovisores: json["descripcionRetrovisores"] ?? null,
        motor: json["motor"] ?? null,
        descripcionMotor: json["descripcionMotor"] ?? null,
        transmision: json["transmision"] ?? null,
        descripcionTransmision: json["descripcionTransmision"] ?? null,
        suspension: json["suspension"] ?? null,
        descripcionSuspension: json["descripcionSuspension"] ?? null,
        partesElectricas: json["partesElectricas"] ?? null,
        descripcionPartesElectricas:
            json["descripcionPartesElectricas"] ?? null,
        rodamientos: json["rodamientos"] ?? null,
        descripcionRodamientos: json["descripcionRodamientos"] ?? null,
        trenDelantero: json["trenDelantero"] ?? null,
        descripcionTrenDelantero: json["descripcionTrenDelantero"] ?? null,
        color: json["color"] ?? null,
        descripcionEntidad: json["descripcionEntidad"] ?? null,
        descripcionColor: json["descripcionColor"] ?? null,
        tasador: json["tasador"] ?? null,
        nombreTasador: json["nombreTasador"] ?? null,
        idPromotor: json["idPromotor"] ?? null,
        condicionComponenteTasacion: json["condicionComponenteTasacion"] == null
            ? null
            : List<CondicionComponenteTasacion>.from(
                json["condicionComponenteTasacion"]
                    .map((x) => CondicionComponenteTasacion.fromJson(x))),
        accesoriosTasacion: json["accesoriosTasacion"] == null
            ? null
            : List<AccesoriosTasacion>.from(json["accesoriosTasacion"]
                .map((x) => AccesoriosTasacion.fromJson(x))),
        nota: json["nota"] == null ? null : Nota.fromJson(json["nota"]),
        isSalvage: json["salvamentoVin"]?["is_salvage"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "noTasacion": noTasacion ?? null,
        "noSolicitudCredito": noSolicitudCredito ?? null,
        "suplidorTasacion": suplidorTasacion ?? null,
        "descripcionEntidad": descripcionEntidad ?? null,
        "descripcionSuplidorTasacion": descripcionSuplidorTasacion ?? null,
        "idOficial": idOficial ?? null,
        "nombreOficial": nombreOficial ?? null,
        "estadoTasacion": estadoTasacion ?? null,
        "descripcionVersion": descripcionVersion ?? null,
        "descripcionEdicion": descripcionEdicion ?? null,
        "descripcionEstadoTasacion": descripcionEstadoTasacion ?? null,
        "tipoTasacion": tipoTasacion ?? null,
        "descripcionTipoTasacion": descripcionTipoTasacion ?? null,
        "codigoEntidad": codigoEntidad ?? null,
        "codigoSucursal": codigoSucursal ?? null,
        "descripcionSucursal": descripcionSucursal ?? null,
        "nombreCliente": nombreCliente ?? null,
        "identificacion": identificacion ?? null,
        "observacion": observacion ?? null,
        "tasacionAutorizada": tasacionAutorizada ?? null,
        "valorTasacion": valorTasacion ?? null,
        "fechaCreada":
            fechaCreada == null ? null : fechaCreada?.toIso8601String(),
        "fechaSolicitada":
            fechaSolicitada == null ? null : fechaSolicitada?.toIso8601String(),
        "fechaValorada":
            fechaValorada == null ? null : fechaValorada?.toIso8601String(),
        "fechaAprobada":
            fechaAprobada == null ? null : fechaAprobada?.toIso8601String(),
        "fechaVencimiento": fechaVencimiento == null
            ? null
            : fechaVencimiento?.toIso8601String(),
        "aprobada": aprobada ?? null,
        "aprobador": aprobador ?? null,
        "noFactura": noFactura ?? null,
        "valorEstimacion": valorEstimacion ?? null,
        "valorUltimas3Tasaciones": valorUltimas3Tasaciones ?? null,
        "valorCarrosRd": valorCarrosRd ?? null,
        "valorFacturacion": valorFacturacion ?? null,
        "chasis": chasis ?? null,
        "marca": marca ?? null,
        "descripcionMarca": descripcionMarca ?? null,
        "modelo": modelo ?? null,
        "descripcionModelo": descripcionModelo ?? null,
        "ano": ano ?? null,
        "tipoVehiculoLocal": tipoVehiculoLocal ?? null,
        "descripcionTipoVehiculoLocal": descripcionTipoVehiculoLocal ?? null,
        "tipoVehiculo": tipoVehiculo ?? null,
        "versionLocal": versionLocal ?? null,
        "serie": serie ?? null,
        "descripcionSerie": descripcionSerie ?? null,
        "trim": trim ?? null,
        "edicion": edicion ?? null,
        "descripcionTrim": descripcionTrim ?? null,
        "sistemaTransmision": sistemaTransmision ?? null,
        "descripcionSistemaTransmision": descripcionSistemaTransmision ?? null,
        "traccion": traccion ?? null,
        "descripcionTraccion": descripcionTraccion ?? null,
        "noPuertas": noPuertas ?? null,
        "noCilindros": noCilindros ?? null,
        "fuerzaMotriz": fuerzaMotriz ?? null,
        "nuevoUsado": nuevoUsado ?? null,
        "descripcionNuevoUsado": descripcionNuevoUsado ?? null,
        "kilometraje": kilometraje ?? null,
        "placa": placa ?? null,
        "frontal": frontal ?? null,
        "descripcionFrontal": descripcionFrontal ?? null,
        "lateralDerecho": lateralDerecho ?? null,
        "descripcionLateralDerecho": descripcionLateralDerecho ?? null,
        "lateraIzquierdo": lateraIzquierdo ?? null,
        "descripcionLateraIzquierdo": descripcionLateraIzquierdo ?? null,
        "puertaDerecha": puertaDerecha ?? null,
        "descripcionPuertaDerecha": descripcionPuertaDerecha ?? null,
        "puertaIzquierda": puertaIzquierda ?? null,
        "descripcionPuertaIzquierda": descripcionPuertaIzquierda ?? null,
        "puertaTraseraDerecha": puertaTraseraDerecha ?? null,
        "descripcionPuertaTraseraDerecha":
            descripcionPuertaTraseraDerecha ?? null,
        "puertaTraseraIzquierda": puertaTraseraIzquierda ?? null,
        "descripcionPuertaTraseraIzquierda":
            descripcionPuertaTraseraIzquierda ?? null,
        "parteTrasera": parteTrasera ?? null,
        "descripcionParteTrasera": descripcionParteTrasera ?? null,
        "capota": capota ?? null,
        "descripcionCapota": descripcionCapota ?? null,
        "bumperDelantero": bumperDelantero ?? null,
        "descripcionBumperDelantero": descripcionBumperDelantero ?? null,
        "bumberTrasero": bumberTrasero ?? null,
        "descripcionBumberTrasero": descripcionBumberTrasero ?? null,
        "asientoDelantero": asientoDelantero ?? null,
        "descripcionAsientoDelantero": descripcionAsientoDelantero ?? null,
        "asientoTrasero": asientoTrasero ?? null,
        "descripcionAsientoTrasero": descripcionAsientoTrasero ?? null,
        "plafones": plafones ?? null,
        "descripcionPlafones": descripcionPlafones ?? null,
        "cristalesLateralIzquierdo": cristalesLateralIzquierdo ?? null,
        "descripcionCristalesLateralIzquierdo":
            descripcionCristalesLateralIzquierdo ?? null,
        "cristalesLateralDerecho": cristalesLateralDerecho ?? null,
        "descripcionCristalesLateralDerecho":
            descripcionCristalesLateralDerecho ?? null,
        "cristalesTrasero": cristalesTrasero ?? null,
        "descripcionCristalesTrasero": descripcionCristalesTrasero ?? null,
        "cristalesDelantero": cristalesDelantero ?? null,
        "descripcionCristalesDelantero": descripcionCristalesDelantero ?? null,
        "farolesDelanteros": farolesDelanteros ?? null,
        "descripcionFarolesDelanteros": descripcionFarolesDelanteros ?? null,
        "farolesTraseros": farolesTraseros ?? null,
        "descripcionFarolesTraseros": descripcionFarolesTraseros ?? null,
        "faloresDirecciones": faloresDirecciones ?? null,
        "descripcionFaloresDirecciones": descripcionFaloresDirecciones ?? null,
        "retrovisores": retrovisores ?? null,
        "descripcionRetrovisores": descripcionRetrovisores ?? null,
        "motor": motor ?? null,
        "descripcionMotor": descripcionMotor ?? null,
        "transmision": transmision ?? null,
        "descripcionTransmision": descripcionTransmision ?? null,
        "suspension": suspension ?? null,
        "descripcionSuspension": descripcionSuspension ?? null,
        "partesElectricas": partesElectricas ?? null,
        "descripcionPartesElectricas": descripcionPartesElectricas ?? null,
        "rodamientos": rodamientos ?? null,
        "descripcionRodamientos": descripcionRodamientos ?? null,
        "trenDelantero": trenDelantero ?? null,
        "descripcionTrenDelantero": descripcionTrenDelantero ?? null,
        "color": color ?? null,
        "descripcionColor": descripcionColor ?? null,
        "tasador": tasador ?? null,
        "nombreTasador": nombreTasador ?? null,
        "idPromotor": idPromotor ?? null,
        "condicionComponenteTasacion": condicionComponenteTasacion == null
            ? null
            : List<dynamic>.from(
                condicionComponenteTasacion!.map((x) => x.toJson())),
        "accesoriosTasacion": accesoriosTasacion == null
            ? null
            : List<dynamic>.from(accesoriosTasacion!.map((x) => x.toJson())),
        "nota": nota == null ? null : nota?.toJson(),
      };
}

class AccesoriosTasacion {
  AccesoriosTasacion({
    this.id,
    this.idSolicitud,
    this.idAccesorio,
    this.descripcionAccesorio,
  });

  int? id;
  int? idSolicitud;
  int? idAccesorio;
  String? descripcionAccesorio;

  factory AccesoriosTasacion.fromJson(Map<String, dynamic> json) =>
      AccesoriosTasacion(
        id: json["id"] ?? null,
        idSolicitud: json["idSolicitud"] ?? null,
        idAccesorio: json["idAccesorio"] ?? null,
        descripcionAccesorio: json["descripcionAccesorio"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "idSolicitud": idSolicitud ?? null,
        "idAccesorio": idAccesorio ?? null,
        "descripcionAccesorio": descripcionAccesorio ?? null,
      };
}

class CondicionComponenteTasacion {
  CondicionComponenteTasacion({
    this.id,
    this.idSolicitud,
    this.idComponenteVehiculo,
    this.descripcionComponenteVehiculo,
    this.idCondicionComponenteVehiculo,
    this.descripcionCondicionComponenteVehiculo,
  });

  int? id;
  int? idSolicitud;
  int? idComponenteVehiculo;
  String? descripcionComponenteVehiculo;
  int? idCondicionComponenteVehiculo;
  String? descripcionCondicionComponenteVehiculo;

  factory CondicionComponenteTasacion.fromJson(Map<String, dynamic> json) =>
      CondicionComponenteTasacion(
        id: json["id"] ?? null,
        idSolicitud: json["idSolicitud"] ?? null,
        idComponenteVehiculo: json["idComponenteVehiculo"] ?? null,
        descripcionComponenteVehiculo:
            json["descripcionComponenteVehiculo"] ?? null,
        idCondicionComponenteVehiculo:
            json["idCondicionComponenteVehiculo"] ?? null,
        descripcionCondicionComponenteVehiculo:
            json["descripcionCondicionComponenteVehiculo"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "idSolicitud": idSolicitud ?? null,
        "idComponenteVehiculo": idComponenteVehiculo ?? null,
        "descripcionComponenteVehiculo": descripcionComponenteVehiculo ?? null,
        "idCondicionComponenteVehiculo": idCondicionComponenteVehiculo ?? null,
        "descripcionCondicionComponenteVehiculo":
            descripcionCondicionComponenteVehiculo ?? null,
      };
}

class Nota {
  Nota({
    this.id,
    this.idSolicitud,
    this.fechaHora,
    this.descripcion,
    this.usuario,
    this.fechaCompromiso,
    this.titulo,
    this.correo,
  });

  int? id;
  int? idSolicitud;
  DateTime? fechaHora;
  String? descripcion;
  String? usuario;
  DateTime? fechaCompromiso;
  String? titulo;
  String? correo;

  factory Nota.fromJson(Map<String, dynamic> json) => Nota(
        id: json["id"] ?? null,
        idSolicitud: json["idSolicitud"] ?? null,
        fechaHora: json["fechaHora"] == null
            ? null
            : DateTime.parse(json["fechaHora"]),
        descripcion: json["descripcion"] ?? null,
        usuario: json["usuario"] ?? null,
        fechaCompromiso: json["fechaCompromiso"] == null
            ? null
            : DateTime.parse(json["fechaCompromiso"]),
        titulo: json["titulo"] ?? null,
        correo: json["correo"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "idSolicitud": idSolicitud ?? null,
        "fechaHora": fechaHora == null ? null : fechaHora?.toIso8601String(),
        "descripcion": descripcion ?? null,
        "usuario": usuario ?? null,
        "fechaCompromiso":
            fechaCompromiso == null ? null : fechaCompromiso?.toIso8601String(),
        "titulo": titulo ?? null,
        "correo": correo ?? null,
      };
}
