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
    required this.source,
    required this.exception,
    required this.errorId,
    required this.supportMessage,
    required this.statusCode,
  });

  List<String> messages;
  String source;
  String exception;
  String errorId;
  String supportMessage;
  int statusCode;

  factory Failure.fromJson(Map<String, dynamic> json) => Failure(
        messages: List<String>.from(json["messages"].map((x) => x)),
        source: json["source"] ?? '',
        exception: json["exception"] ?? '',
        errorId: json["errorId"] ?? '',
        supportMessage: json["supportMessage"] ?? '',
        statusCode: json["statusCode"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "source": source,
        "exception": exception,
        "errorId": errorId,
        "supportMessage": supportMessage,
        "statusCode": statusCode,
      };
}
