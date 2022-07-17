String? emailValidator(String? email) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  if (regExp.hasMatch(email ?? '')) {
    return null;
  }
  return 'Correo inválido';
}

String? passwordValidator(String? pass) {
  if (pass!.isEmpty) {
    return 'Contraseña inválida';
  }
  return null;
}
