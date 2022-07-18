class SuplidoresResponse {
  SuplidoresResponse({
    required this.data,
  });

  List<SuplidorData> data;

  factory SuplidoresResponse.fromJson(Map<String, dynamic> json) =>
      SuplidoresResponse(
        data: json["data"]
            .map<SuplidorData>((e) => SuplidorData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {"data": data.map((e) => e.toJson())};
}

class SuplidorData {
  SuplidorData({
    required this.codigoRelacionado,
    required this.estado,
    required this.nombre,
    required this.identificacion,
  });

  int codigoRelacionado, estado;
  String nombre;
  String identificacion;

  factory SuplidorData.fromJson(Map<String, dynamic> json) => SuplidorData(
        codigoRelacionado: json["codigoRelacionado"] ?? 0,
        estado: json["estado"] ?? 0,
        nombre: json["nombre"] ?? '',
        identificacion: json["identificacion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "codigoRelacionado": codigoRelacionado,
        "estado": estado,
        "nombre": nombre,
        "identificacion": identificacion
      };
}
