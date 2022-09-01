import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/solicitudes/base_widgets/base_form_widget.dart';

class EnviarForm extends StatelessWidget {
  const EnviarForm({
    required this.enviar,
    required this.atras,
    Key? key,
  }) : super(key: key);
  final void Function() enviar;
  final void Function() atras;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      titleHeader: 'Enviar',
      iconHeader: Icons.add_chart_sharp,
      labelNext: 'Guardar',
      iconNext: AppIcons.save,
      onPressedNext: enviar,
      labelBack: 'Atrás',
      iconBack: Icons.arrow_back_ios,
      onPressedBack: atras,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            SizedBox(height: 50),
            Text(
              'Atención',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 50),
            Text(
              'Después de ser enviada la solicitud para su valoración no podrá ser modificada.',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
