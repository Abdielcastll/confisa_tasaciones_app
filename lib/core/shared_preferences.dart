import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static final Preferencias _instancia = Preferencias._internal();
  factory Preferencias() {
    return _instancia;
  }
  Preferencias._internal();

  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
