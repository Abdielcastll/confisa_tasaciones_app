import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/home/home_view.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();

  void goToHome() {
    _navigationService.navigateToPage(HomeView.routeName);
  }
}
