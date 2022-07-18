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
  String textError =
      'Al menos 8 carácteres, una letra mayúscula, una letra minúscula, un número y un caracter especial';
  if (!minCharactersValidationRule(pass ?? '') ||
      !uppercaseValidationRule(pass ?? '') ||
      !lowercaseValidationRule(pass ?? '') ||
      !digitValidationRule(pass ?? '') ||
      !specialCharacterValidationRule(pass ?? '')) {
    return textError;
  }
  return null;
}

bool minCharactersValidationRule(String text) => text.length < 8 ? false : true;

bool uppercaseValidationRule(String text) => text.contains(RegExp(r'[A-Z]'));

bool lowercaseValidationRule(String value) => value.contains(RegExp(r'[a-z]'));

bool digitValidationRule(String value) => value.contains(RegExp(r'[0-9]'));

bool specialCharacterValidationRule(String value) =>
    value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
