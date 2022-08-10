import 'dart:convert';

ParametrosServidorEmailResponse parametrosServidorEmailResponseFromJson(
        String str) =>
    ParametrosServidorEmailResponse.fromJson(json.decode(str));

String parametrosServidorEmailResponseToJson(
        ParametrosServidorEmailResponse data) =>
    json.encode(data.toJson());

class ParametrosServidorEmailResponse {
  ParametrosServidorEmailResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<ParametrosServidorEmailData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory ParametrosServidorEmailResponse.fromJson(Map<String, dynamic> json) =>
      ParametrosServidorEmailResponse(
          data: json["data"]
              .map<ParametrosServidorEmailData>(
                  (e) => ParametrosServidorEmailData.fromJson(e))
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

class ParametrosServidorEmailData {
  ParametrosServidorEmailData(
      {required this.id,
      required this.host,
      required this.password,
      required this.puerto,
      required this.remitente,
      required this.usuario});

  String remitente, host, puerto, usuario, password;
  int id;

  factory ParametrosServidorEmailData.fromJson(Map<String, dynamic> json) =>
      ParametrosServidorEmailData(
        id: json["id"] ?? 0,
        usuario: json["usuario"] ?? '',
        password: json["password"] ?? '',
        host: json["host"] ?? '',
        puerto: json["puerto"] ?? '',
        remitente: json["remitente"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "password": password,
        "host": host,
        "puerto": puerto,
        "remitente": remitente
      };
}

ParametrosServidorEmailResponse parametrosServidorEmailPOSTResponseFromJson(
        String str) =>
    ParametrosServidorEmailResponse.fromJson(json.decode(str));

String parametrosServidorEmailPOSTResponseToJson(
        ParametrosServidorEmailResponse data) =>
    json.encode(data.toJson());

class ParametrosServidorEmailPOSTResponse {
  ParametrosServidorEmailPOSTResponse({required this.data});

  bool data;

  factory ParametrosServidorEmailPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      ParametrosServidorEmailPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
