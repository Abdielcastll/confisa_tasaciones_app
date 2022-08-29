import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

Future<String> createFileFromString(String stringBase64) async {
  Uint8List bytes = base64.decode(stringBase64);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file =
      File("$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");
  file.writeAsBytesSync(bytes);
  return file.path;
}
