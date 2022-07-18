import 'dart:convert';

class Success<T> {
  final T response;
  Success({
    required this.response,
  });
}

Failure failureFromJson(String str) => Failure.fromJson(json.decode(str));

String failureToJson(Failure data) => json.encode(data.toJson());

class Failure {
  Failure({
    required this.messages,
    required this.supportMessage,
    required this.statusCode,
  });

  List<String> messages;
  String supportMessage;
  int statusCode;

  factory Failure.fromJson(Map<String, dynamic> json) => Failure(
        messages: List<String>.from(json["messages"].map((x) => x)),
        supportMessage: json["supportMessage"] ?? '',
        statusCode: json["statusCode"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "supportMessage": supportMessage,
        "statusCode": statusCode,
      };
}
