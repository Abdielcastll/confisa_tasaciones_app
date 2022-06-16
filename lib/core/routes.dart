import 'package:confisa_tasaciones_app/views/login/login_view.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(dynamic)> router = {
  LoginView.routeName: (_) => const LoginView(),
};
