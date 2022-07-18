import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/utils/validators.dart';
import 'package:tasaciones_app/views/Perfil_de_usuario/perfil_view_model.dart';
import 'package:tasaciones_app/widgets/app_textfield.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_obscure_text_icon.dart';

class CardChangePasswordWidget extends StatelessWidget {
  const CardChangePasswordWidget(this.vm, {Key? key}) : super(key: key);

  final PerfilViewModel vm;
  final TextStyle styleContent =
      const TextStyle(color: Colors.white, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        vm.currentPage == 0 ? Navigator.of(context).pop() : vm.currentPage = 0;
        return Future.value(false);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.brownLight2,
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.fromLTRB(25, 50, 25, 0),
        child: Form(
          key: vm.formKey,
          child: Column(
            children: [
              _itemPass(
                title: 'Contraseña actual',
                controller: vm.tcCurrentPass,
                iconButton: AppObscureTextIcon(
                  icon: vm.obscurePassCurrent
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onPressed: vm.changeObscureCurrent,
                ),
                obscureText: vm.obscurePassCurrent,
              ),
              const SizedBox(height: 15),
              _itemPass(
                title: 'Nueva contraseña',
                controller: vm.tcNewPass,
                iconButton: AppObscureTextIcon(
                  icon: vm.obscurePassNew
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onPressed: vm.changeObscureNew,
                ),
                obscureText: vm.obscurePassNew,
              ),
              const SizedBox(height: 15),
              _itemPass(
                title: 'Confirme nueva contraseña',
                controller: vm.tcConfirmNewPass,
                iconButton: AppObscureTextIcon(
                  icon: vm.obscurePassConfirmNew
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onPressed: vm.changeObscureConfirmNew,
                ),
                obscureText: vm.obscurePassConfirmNew,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Column _itemPass({
    required String title,
    required TextEditingController controller,
    required Widget iconButton,
    required bool? obscureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          text: '',
          controller: controller,
          validator: passwordValidator,
          iconButton: iconButton,
          obscureText: obscureText,
          colorError: Colors.grey[100],
        )
      ],
    );
  }
}
