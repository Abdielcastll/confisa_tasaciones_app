class PorcentajesHonorariosEntidadResponse {
  PorcentajesHonorariosEntidadResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<PorcentajesHonorariosEntidadData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory PorcentajesHonorariosEntidadResponse.fromJson(
          Map<String, dynamic> json) =>
      PorcentajesHonorariosEntidadResponse(
          data: json["data"]
              .map<PorcentajesHonorariosEntidadData>(
                  (e) => PorcentajesHonorariosEntidadData.fromJson(e))
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

class PorcentajesHonorariosEntidadData {
  PorcentajesHonorariosEntidadData(
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

  factory PorcentajesHonorariosEntidadData.fromJson(
          Map<String, dynamic> json) =>
      PorcentajesHonorariosEntidadData(
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

class PorcentajesHonorariosEntidadPOSTResponse {
  PorcentajesHonorariosEntidadPOSTResponse({required this.data});

  bool data;

  factory PorcentajesHonorariosEntidadPOSTResponse.fromJson(
          Map<String, dynamic> json) =>
      PorcentajesHonorariosEntidadPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
