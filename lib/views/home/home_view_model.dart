import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';

class HomeViewModel extends BaseViewModel {
  late SignInData _user;

  SignInData get user => _user;
  set user(SignInData value) {
    _user = value;
    notifyListeners();
  }
}
