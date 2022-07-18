import 'dart:convert';

UsuariosResponse usuariosResponseFromJson(String str) =>
    UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) =>
    json.encode(data.toJson());

class UsuariosResponse {
  UsuariosResponse(
      {required this.data,
      required this.totalCount,
      required this.totalPages,
      required this.pageSize,
      required this.currentPage,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.nextPageUrl});

  List<UsuariosData> data;
  String nextPageUrl;
  int totalCount, pageSize, currentPage, totalPages;
  bool hasNextPage, hasPreviousPage;

  factory UsuariosResponse.fromJson(Map<String, dynamic> json) =>
      UsuariosResponse(
          data: json["data"]
              .map<UsuariosData>((e) => UsuariosData.fromJson(e))
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

class UsuariosData {
  UsuariosData(
      {required this.id,
      required this.email,
      required this.emailConfirmed,
      required this.firtsName,
      required this.idSuplidor,
      required this.imageUrl,
      required this.isActive,
      required this.lastName,
      required this.nombreCompleto,
      required this.nombreSuplidor,
      required this.phoneNumber,
      required this.userName,
      required this.roles,
      required this.idRoles});

  String id,
      userName,
      firtsName,
      lastName,
      email,
      phoneNumber,
      imageUrl,
      nombreCompleto,
      nombreSuplidor;
  List<String> roles;
  List<String> idRoles;
  bool isActive, emailConfirmed;
  int idSuplidor;

  factory UsuariosData.fromJson(Map<String, dynamic> json) => UsuariosData(
        id: json["id"] ?? '',
        userName: json["userName"] ?? '',
        firtsName: json["firtsName"] ?? '',
        lastName: json["lastName"] ?? '',
        email: json["email"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        nombreCompleto: json["nombreCompleto"] ?? '',
        nombreSuplidor: json["nombreSuplidor"] ?? '',
        isActive: json["isActive"] ?? false,
        emailConfirmed: json["emailConfirmed"] ?? false,
        idSuplidor: json["idSuplidor"] ?? 0,
        roles: json["roles"] ?? [],
        idRoles: json["idRoles"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "firtsName": firtsName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
        "nombreCompleto": nombreCompleto,
        "nombreSuplidor": nombreSuplidor,
        "isActive": isActive,
        "emailConfirmed": emailConfirmed,
        "idSuplidor": idSuplidor,
        "roles": roles
      };
}

class UsuarioDomainData {
  UsuarioDomainData({
    required this.departamento,
    required this.email,
    required this.puesto,
    required this.telefono,
    required this.nombreCompleto,
  });

  String puesto, departamento, email, telefono, nombreCompleto;

  factory UsuarioDomainData.fromJson(Map<String, dynamic> json) =>
      UsuarioDomainData(
        departamento: json["data"]["departamento"] ?? '',
        telefono: json["data"]["telefono"] ?? '',
        email: json["data"]["email"] ?? '',
        puesto: json["data"]["puesto"] ?? '',
        nombreCompleto: json["data"]["nombreCompleto"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "departamento": departamento,
        "telefono": telefono,
        "nombreCompleto": nombreCompleto,
        "puesto": puesto
      };
}

class RolUsuarioResponse {
  RolUsuarioResponse({required this.data});

  List<RolUsuarioData> data;

  factory RolUsuarioResponse.fromJson(Map<String, dynamic> json) =>
      RolUsuarioResponse(
          data: json["data"]
              .map<RolUsuarioData>((e) => RolUsuarioData.fromJson(e))
              .toList());

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}

class RolUsuarioData {
  RolUsuarioData(
      {required this.roleId,
      required this.roleName,
      required this.description,
      required this.enabled});

  String roleId, roleName, description;
  bool enabled;

  factory RolUsuarioData.fromJson(Map<String, dynamic> json) => RolUsuarioData(
        roleId: json["roleId"] ?? '',
        roleName: json["roleName"] ?? '',
        description: json["description"] ?? '',
        enabled: json["enabled"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "roleId": roleId,
        "roleName": roleName,
        "description": description,
        "enabled": enabled,
      };
}

UsuariosResponse usuarioPOSTResponseFromJson(String str) =>
    UsuariosResponse.fromJson(json.decode(str));

String usuarioPOSTResponseToJson(UsuariosResponse data) =>
    json.encode(data.toJson());

class UsuarioPOSTResponse {
  UsuarioPOSTResponse({required this.data});

  bool data;

  factory UsuarioPOSTResponse.fromJson(Map<String, dynamic> json) =>
      UsuarioPOSTResponse(data: json["data"]);

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
