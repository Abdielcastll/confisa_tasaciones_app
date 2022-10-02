import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';

class AlarmasProvider with ChangeNotifier {
  List<AlarmasData> _alarmas = [];
  List<AlarmasData> get alarmas => _alarmas;
  set alarmas(List<AlarmasData> value) {
    _alarmas = value;
    notifyListeners();
  }
}
