import 'dart:convert';

TarifarioTasacionResponse tarifarioTasacionResponseFromJson(String str) =>
    TarifarioTasacionResponse.fromJson(json.decode(str));

String tarifarioTasacionResponseToJson(TarifarioTasacionResponse data) =>
    json.encode(data.toJson());

class TarifarioTasacionResponse {
  TarifarioTasacionResponse({
    required this.data,
  });

  List<TarifarioTasacionData> data;

  factory TarifarioTasacionResponse.fromJson(Map<String, dynamic> json) =>
      TarifarioTasacionResponse(
        data: json["data"]
            .map<TarifarioTasacionData>(
                (e) => TarifarioTasacionData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
      };
}

class TarifarioTasacionData {
  TarifarioTasacionData(
      {required this.descripcionTipoTasacion,
      required this.idSuplidor,
      required this.suplidor,
      required this.tipoTasacion,
      required this.valor});

  String descripcionTipoTasacion, suplidor, valor;
  int idSuplidor, tipoTasacion;

  factory TarifarioTasacionData.fromJson(Map<String, dynamic> json) =>
      TarifarioTasacionData(
        idSuplidor: json["idSuplidor"] ?? 0,
        tipoTasacion: json["tipoTasacion"] ?? 0,
        descripcionTipoTasacion: json["descripcionTipoTasacion"] ?? '',
        suplidor: json["suplidor"] ?? '',
        valor: json["valor"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "idSuplidor": idSuplidor,
        "tipoTasacion": tipoTasacion,
        "descripcionTipoTasacion": descripcionTipoTasacion,
        "suplidor": suplidor,
        "valor": valor
      };
}

TarifarioTasacionResponse tarifarioTasacionPOSTResponseFromJson(String str) =>
    TarifarioTasacionResponse.fromJson(json.decode(str));

String tarifarioTasacionPOSTResponseToJson(TarifarioTasacionResponse data) =>
    json.encode(data.toJson());

class TarifarioTasacionPOSTResponse {
  TarifarioTasacionPOSTResponse({required this.data});

  bool data;

  factory TarifarioTasacionPOSTResponse.fromJson(Map<String, dynamic> json) =>
      TarifarioTasacionPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
