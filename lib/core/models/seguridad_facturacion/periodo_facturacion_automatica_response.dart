import 'dart:convert';

PeriodoFacturacionAutomaticaResponse
    periodoFacturacionAutomaticaResponseFromJson(String str) =>
        PeriodoFacturacionAutomaticaResponse.fromJson(json.decode(str));

String periodoFacturacionAutomaticaResponseToJson(
        PeriodoFacturacionAutomaticaResponse data) =>
    json.encode(data.toJson());

class PeriodoFacturacionAutomaticaResponse {
  PeriodoFacturacionAutomaticaResponse({
    required this.data,
  });

  List<PeriodoFacturacionAutomaticaData> data;

  factory PeriodoFacturacionAutomaticaResponse.fromJson(
          Map<String, dynamic> json) =>
      PeriodoFacturacionAutomaticaResponse(
        data: json["data"]
            .map<PeriodoFacturacionAutomaticaData>(
                (e) => PeriodoFacturacionAutomaticaData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
      };
}

class PeriodoFacturacionAutomaticaData {
  PeriodoFacturacionAutomaticaData(
      {required this.descripcion,
      required this.idSuplidor,
      required this.suplidor,
      required this.valor});

  String valor, idSuplidor, descripcion, suplidor;

  factory PeriodoFacturacionAutomaticaData.fromJson(
          Map<String, dynamic> json) =>
      PeriodoFacturacionAutomaticaData(
        descripcion: json["descripcion"] ?? '',
        suplidor: json["suplidor"] ?? '',
        valor: json["valor"] ?? '',
        idSuplidor: json["idSuplidor"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "idSuplidor": idSuplidor,
        "suplidor": suplidor,
        "valor": valor
      };
}

PeriodoFacturacionAutomaticaResponse
    periodoFacturacionAutomaticaPOSTResponseFromJson(String str) =>
        PeriodoFacturacionAutomaticaResponse.fromJson(json.decode(str));

String periodoFacturacionAutomaticaPOSTResponseToJson(
        PeriodoFacturacionAutomaticaResponse data) =>
    json.encode(data.toJson());

class PeriodoFacturacionAutomaticaPOSTResponse {
  PeriodoFacturacionAutomaticaPOSTResponse({required this.data});

  bool data;

  factory PeriodoFacturacionAutomaticaPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      PeriodoFacturacionAutomaticaPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
