import 'dart:convert';

SegmentosAccesoriosVehiculosResponse
    segmentosAccesoriosVehiculosResponseFromJson(String str) =>
        SegmentosAccesoriosVehiculosResponse.fromJson(json.decode(str));

String segmentosAccesoriosVehiculosResponseToJson(
        SegmentosAccesoriosVehiculosResponse data) =>
    json.encode(data.toJson());

class SegmentosAccesoriosVehiculosResponse {
  SegmentosAccesoriosVehiculosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<SegmentosAccesoriosVehiculosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory SegmentosAccesoriosVehiculosResponse.fromJson(
          Map<String, dynamic> json) =>
      SegmentosAccesoriosVehiculosResponse(
          data: json["data"]
              .map<SegmentosAccesoriosVehiculosData>(
                  (e) => SegmentosAccesoriosVehiculosData.fromJson(e))
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

class SegmentosAccesoriosVehiculosData {
  SegmentosAccesoriosVehiculosData(
      {required this.id, required this.descripcion});

  String descripcion;
  int id;

  factory SegmentosAccesoriosVehiculosData.fromJson(
          Map<String, dynamic> json) =>
      SegmentosAccesoriosVehiculosData(
        id: json["id"] ?? 0,
        descripcion: json["descripcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}

SegmentosAccesoriosVehiculosResponse
    segmentosAccesoriosVehiculosPOSTResponseFromJson(String str) =>
        SegmentosAccesoriosVehiculosResponse.fromJson(json.decode(str));

String segmentosAccesoriosVehiculosPOSTResponseToJson(
        SegmentosAccesoriosVehiculosResponse data) =>
    json.encode(data.toJson());

class SegmentosAccesoriosVehiculosPOSTResponse {
  SegmentosAccesoriosVehiculosPOSTResponse({required this.data});

  bool data;

  factory SegmentosAccesoriosVehiculosPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      SegmentosAccesoriosVehiculosPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
