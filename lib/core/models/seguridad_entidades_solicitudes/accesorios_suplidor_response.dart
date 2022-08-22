import 'dart:convert';

AccesoriosSuplidorResponse accesoriosSuplidorResponseFromJson(String str) =>
    AccesoriosSuplidorResponse.fromJson(json.decode(str));

String accesoriosSuplidorResponseToJson(AccesoriosSuplidorResponse data) =>
    json.encode(data.toJson());

class AccesoriosSuplidorResponse {
  AccesoriosSuplidorResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<AccesoriosSuplidorData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory AccesoriosSuplidorResponse.fromJson(Map<String, dynamic> json) =>
      AccesoriosSuplidorResponse(
          data: json["data"]
              .map<AccesoriosSuplidorData>(
                  (e) => AccesoriosSuplidorData.fromJson(e))
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

class AccesoriosSuplidorResponseSinMeta {
  AccesoriosSuplidorResponseSinMeta({
    required this.data,
  });

  List<AccesoriosSuplidorData> data;

  factory AccesoriosSuplidorResponseSinMeta.fromJson(
          Map<String, dynamic> json) =>
      AccesoriosSuplidorResponseSinMeta(
        data: json["data"]
            .map<AccesoriosSuplidorData>(
                (e) => AccesoriosSuplidorData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()),
      };
}

class AccesoriosSuplidorData {
  AccesoriosSuplidorData(
      {required this.id,
      required this.accesorioDescripcion,
      required this.estado,
      required this.idAccesorio,
      required this.idSuplidor,
      required this.suplidorDescripcion});

  String accesorioDescripcion, suplidorDescripcion;
  int id, idAccesorio, idSuplidor, estado;

  factory AccesoriosSuplidorData.fromJson(Map<String, dynamic> json) =>
      AccesoriosSuplidorData(
        id: json["id"] ?? 0,
        idAccesorio: json["idAccesorio"] ?? 0,
        idSuplidor: json["idSuplidor"] ?? 0,
        estado: json["estado"] ?? 0,
        accesorioDescripcion: json["accesorioDescripcion"] ?? '',
        suplidorDescripcion: json["suplidorDescripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idAccesorio": idAccesorio,
        "idSuplidor": idSuplidor,
        "estado": estado,
        "accesorioDescripcion": accesorioDescripcion,
        "suplidorDescripcion": suplidorDescripcion
      };
}

AccesoriosSuplidorResponse accesoriosSuplidorPOSTResponseFromJson(String str) =>
    AccesoriosSuplidorResponse.fromJson(json.decode(str));

String accesoriosSuplidorPOSTResponseToJson(AccesoriosSuplidorResponse data) =>
    json.encode(data.toJson());

class AccesoriosSuplidorPOSTResponse {
  AccesoriosSuplidorPOSTResponse({required this.data});

  bool data;

  factory AccesoriosSuplidorPOSTResponse.fromJson(Map<String, dynamic> json) =>
      AccesoriosSuplidorPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
