import 'package:confisa_tasaciones_app/views/login/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderInjector {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => LoginViewModel()),
  ];
}
