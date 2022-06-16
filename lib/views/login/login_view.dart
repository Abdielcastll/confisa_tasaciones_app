import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  static const routeName = 'login';
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('LoginView'),
      ),
    );
  }
}
