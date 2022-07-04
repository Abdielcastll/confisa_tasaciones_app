import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/autentication_api.dart';
import 'package:tasaciones_app/core/base/base_view_model.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/provider/user_data_provider.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/views/home/home_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _authenticationAPI = GetIt.instance<AuthenticationAPI>();
  final _logger = Logger();
  TextEditingController tcEmail = TextEditingController();
  TextEditingController tcPassword = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    ProgressDialog.show(context);
    var resp = await _authenticationAPI.signIn(
      email: tcEmail.text,
      password: tcPassword.text,
    );
    if (resp is Success) {
      ProgressDialog.dissmiss(context);
      _logger.d(resp.response);
      SignInResponse user = SignInResponse.fromJson(resp.response);
      Provider.of<UserProvider>(context, listen: false).user = user;
      _logger.d(user);
      _navigationService.navigateToPageWithReplacement(HomeView.routeName);
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.alert(
        context,
        tittle: 'Error',
        description: resp.messages,
      );
    }
  }

  @override
  void dispose() {
    tcEmail.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
