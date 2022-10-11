import 'dart:convert';

MontosFacturaMinimaResponse montosFacturaMinimaResponseFromJson(String str) =>
    MontosFacturaMinimaResponse.fromJson(json.decode(str));

String montosFacturaMinimaResponseToJson(MontosFacturaMinimaResponse data) =>
    json.encode(data.toJson());

class MontosFacturaMinimaResponse {
  MontosFacturaMinimaResponse({required this.data});

  List<MontosFacturaMinimaData> data;

  factory MontosFacturaMinimaResponse.fromJson(List<dynamic> list) =>
      MontosFacturaMinimaResponse(
          data: list
              .map<MontosFacturaMinimaData>(
                  (e) => MontosFacturaMinimaData.fromJson(e))
              .toList());

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
      };
}

class MontosFacturaMinimaData {
  MontosFacturaMinimaData(
      {required this.codigoSucursal,
      required this.valor,
      required this.descripcionSucursal,
      required this.idSuplidor,
      required this.descripcionSuplidor});

  String descripcionSucursal, codigoSucursal, valor, descripcionSuplidor;
  int idSuplidor;

  factory MontosFacturaMinimaData.fromJson(Map<String, dynamic> json) =>
      MontosFacturaMinimaData(
        descripcionSucursal: json["descripcionSucursal"] ?? '',
        idSuplidor: json["idSuplidor"] ?? '',
        descripcionSuplidor: json["descripcionSuplidor"] ?? '',
        codigoSucursal: json["codigoSucursal"] ?? '',
        valor: json["valor"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "idSuplidor": idSuplidor,
        "descripcionSuplidor": descripcionSuplidor,
        "descripcionSucursal": descripcionSucursal,
        "codigoSucursal": codigoSucursal,
        "valor": valor
      };
}

MontosFacturaMinimaResponse montosFacturaMinimaPOSTResponseFromJson(
        String str) =>
    MontosFacturaMinimaResponse.fromJson(json.decode(str));

String montosFacturaMinimaPOSTResponseToJson(
        MontosFacturaMinimaResponse data) =>
    json.encode(data.toJson());

class MontosFacturaMinimaPOSTResponse {
  MontosFacturaMinimaPOSTResponse({required this.data});

  bool data;

  factory MontosFacturaMinimaPOSTResponse.fromJson(Map<String, dynamic> json) =>
      MontosFacturaMinimaPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
