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
  SuplidorData(
      {required this.codigoRelacionado,
      required this.estado,
      required this.nombre,
      required this.identificacion,
      required this.direccion,
      required this.celular,
      required this.detalles,
      required this.email,
      required this.registro,
      required this.telefono});

  int codigoRelacionado, estado;
  String nombre, direccion, detalles, registro, email, celular, telefono;
  String identificacion;

  factory SuplidorData.fromJson(Map<String, dynamic> json) => SuplidorData(
        codigoRelacionado: json["codigoRelacionado"] ?? 0,
        estado: json["estado"] ?? 0,
        nombre: json["nombre"] ?? '',
        identificacion: json["identificacion"] ?? '',
        direccion: json["direccion"] ?? '',
        registro: json["registro"] ?? '',
        email: json["email"] ?? '',
        celular: json["celular"] ?? '',
        telefono: json["telefono"] ?? '',
        detalles: json["detalles"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "codigoRelacionado": codigoRelacionado,
        "estado": estado,
        "nombre": nombre,
        "identificacion": identificacion,
        "direccion": direccion,
        "registro": registro,
        "email": email,
        "celular": celular,
        "telefono": telefono,
        "detalles": detalles
      };
}

class SuplidoresPOSTResponse {
  SuplidoresPOSTResponse({
    required this.data,
  });

  bool data;

  factory SuplidoresPOSTResponse.fromJson(Map<String, dynamic> json) =>
      SuplidoresPOSTResponse(
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {"data": data};
}
