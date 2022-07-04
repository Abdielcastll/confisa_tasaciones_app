import 'dart:convert';

RolResponse rolResponseFromJson(String str) =>
    RolResponse.fromJson(json.decode(str));

String rolResponseToJson(RolResponse data) => json.encode(data.toJson());

class RolResponse {
  RolResponse({
    required this.data,
  });

  RolData data;

  factory RolResponse.fromJson(Map<String, dynamic> json) => RolResponse(
        data: RolData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class RolData {
  RolData({required this.id, required this.name, required this.description});

  String id;
  String name;
  String description;

  factory RolData.fromJson(Map<String, dynamic> json) => RolData(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
