class SuplidoresDefaultResponse {
  SuplidoresDefaultResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<SuplidoresDefaultData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory SuplidoresDefaultResponse.fromJson(Map<String, dynamic> json) =>
      SuplidoresDefaultResponse(
          data: json["data"]
              .map<SuplidoresDefaultData>(
                  (e) => SuplidoresDefaultData.fromJson(e))
              .toList(),
          totalCount: json["meta"]["totalCount"],
          totalPages: json["meta"]["totalPages"],
          pageSize: json["meta"]["pageSize"],
          currentPage: json["meta"]["currentPage"],
          hasNextPage: json["meta"]["hasNextPage"],
          hasPreviousPage: json["meta"]["hasPreviousPage"],
          nextPageUrl: json["meta"]["nextPageUrl"]);

  Map<String, dynamic> toJson() => {"data": data.map((e) => e.toJson())};
}

class SuplidoresDefaultData {
  SuplidoresDefaultData(
      {required this.id,
      required this.codigoEntidad,
      required this.descripcionCatalogoParametros,
      required this.descripcionEntidad,
      required this.valor});

  int id;
  String codigoEntidad,
      descripcionEntidad,
      descripcionCatalogoParametros,
      valor;

  factory SuplidoresDefaultData.fromJson(Map<String, dynamic> json) =>
      SuplidoresDefaultData(
        id: json["id"] ?? 0,
        codigoEntidad: json["codigoEntidad"] ?? '',
        descripcionEntidad: json["descripcionEntidad"] ?? '',
        descripcionCatalogoParametros:
            json["descripcionCatalogoParametros"] ?? '',
        valor: json["valor"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigoEntidad": codigoEntidad,
        "descripcionEntidad": descripcionEntidad,
        "descripcionCatalogoParametros": descripcionCatalogoParametros,
        "valor": valor
      };
}

class SuplidoresDefaultPOSTResponse {
  SuplidoresDefaultPOSTResponse({required this.data});

  bool data;

  factory SuplidoresDefaultPOSTResponse.fromJson(Map<String, dynamic> json) =>
      SuplidoresDefaultPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
