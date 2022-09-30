import 'dart:convert';

MontosFacturaMinimaResponse montosFacturaMinimaResponseFromJson(String str) =>
    MontosFacturaMinimaResponse.fromJson(json.decode(str));

String montosFacturaMinimaResponseToJson(MontosFacturaMinimaResponse data) =>
    json.encode(data.toJson());

class MontosFacturaMinimaResponse {
  MontosFacturaMinimaResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<MontosFacturaMinimaData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory MontosFacturaMinimaResponse.fromJson(Map<String, dynamic> json) =>
      MontosFacturaMinimaResponse(
          data: json["data"]
              .map<MontosFacturaMinimaData>(
                  (e) => MontosFacturaMinimaData.fromJson(e))
              .toList(),
          totalCount: json["meta"]["totalCount"],
          totalPages: json["meta"]["totalPages"],
          pageSize: json["meta"]["pageSize"],
          currentPage: json["meta"]["currentPage"],
          hasNextPage: json["meta"]["hasNextPage"],
          hasPreviousPage: json["meta"]["hasPreviousPage"],
          nextPageUrl: json["meta"]["nextPageUrl"]);

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
        "totalCount": totalCount,
        "totalPage": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
        "nextPageUrl": totalCount,
      };
}

class MontosFacturaMinimaData {
  MontosFacturaMinimaData(
      {required this.id,
      required this.codigoEntidad,
      required this.codigoSucursal,
      required this.valor});

  String codigoEntidad, codigoSucursal, valor;
  int id;

  factory MontosFacturaMinimaData.fromJson(Map<String, dynamic> json) =>
      MontosFacturaMinimaData(
        id: json["id"] ?? 0,
        codigoEntidad: json["codigoEntidad"] ?? '',
        codigoSucursal: json["codigoSucursal"] ?? '',
        valor: json["valor"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigoEntidad": codigoEntidad,
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
