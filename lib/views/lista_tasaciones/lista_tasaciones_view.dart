import 'package:confisa_tasaciones_app/widgets/appbar_example.dart';
import 'package:flutter/material.dart';

class ListaTasacionesView extends StatelessWidget {
  static const routeName = 'lista_tasaciones';
  const ListaTasacionesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppbarExample(titulo: "Listado de Tasaciones"),
      body: Center(
        child: Text('ListaTasacionesView'),
      ),
    );
  }
}
