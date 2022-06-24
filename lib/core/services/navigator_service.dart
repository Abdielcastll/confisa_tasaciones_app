import '../../core/base/base_service.dart';
import 'package:flutter/material.dart';

class NavigatorService extends BaseService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToPage(String routeName, {dynamic arguments}) async {
    log.i('navigateToPage: routeName: $routeName');
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToPageWithReplacement(String routeName) async {
    log.i('navigateToPageWithReplacement: '
        'routeName: $routeName');
    return navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void pop<T>([T? result]) {
    log.i('goBack:');
    navigatorKey.currentState?.pop(result);
  }
}
