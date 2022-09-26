import 'dart:convert';

CorteFacturacionResponse corteFacturacionResponseFromJson(String str) =>
    CorteFacturacionResponse.fromJson(json.decode(str));

String corteFacturacionResponseToJson(CorteFacturacionResponse data) =>
    json.encode(data.toJson());

class CorteFacturacionResponse {
  CorteFacturacionResponse({
    required this.data,
  });

  List<CorteFacturacionData> data;

  factory CorteFacturacionResponse.fromJson(Map<String, dynamic> json) =>
      CorteFacturacionResponse(
        data: json["data"]
            .map<CorteFacturacionData>((e) => CorteFacturacionData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
      };
}

class CorteFacturacionData {
  CorteFacturacionData(
      {required this.descripcion,
      required this.idSuplidor,
      required this.suplidor,
      required this.valor,
      required this.tipoTasacion,
      required this.descripcionTipoTasacion});

  String valor, descripcion, suplidor, descripcionTipoTasacion;
  int idSuplidor, tipoTasacion;

  factory CorteFacturacionData.fromJson(Map<String, dynamic> json) =>
      CorteFacturacionData(
        descripcion: json["descripcion"] ?? '',
        suplidor: json["suplidor"] ?? '',
        valor: json["valor"] ?? '',
        descripcionTipoTasacion: json["descripcionTipoTasacion"] ?? '',
        idSuplidor: json["idSuplidor"] ?? 0,
        tipoTasacion: json["tipoTasacion"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "idSuplidor": idSuplidor,
        "suplidor": suplidor,
        "valor": valor,
        "descripcionTipoTasacion": descripcionTipoTasacion,
        "tipoTasacion": tipoTasacion
      };
}

CorteFacturacionResponse corteFacturacionPOSTResponseFromJson(String str) =>
    CorteFacturacionResponse.fromJson(json.decode(str));

String corteFacturacionPOSTResponseToJson(CorteFacturacionResponse data) =>
    json.encode(data.toJson());

class CorteFacturacionPOSTResponse {
  CorteFacturacionPOSTResponse({required this.data});

  bool data;

  factory CorteFacturacionPOSTResponse.fromJson(Map<String, dynamic> json) =>
      CorteFacturacionPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
