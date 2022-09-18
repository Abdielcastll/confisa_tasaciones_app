part of confirm_password_view;

class _ConfirmPasswordMobile extends StatelessWidget {
  final ConfirmPasswordViewModel vm;

  const _ConfirmPasswordMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(vm.activateUser ? 'Activar Usuario' : 'Resetear Contraseña'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: vm.formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      vm.activateUser
                          ? 'Hola ${vm.username}!\nPor favor completa los siguientes campos para activar tu usuario'
                          : 'Por favor completa los siguientes campos para cambiar tu contraseña',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.brownDark,
                        fontSize: 24,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTextField(
                        text: 'Contraseña',
                        controller: vm.tcPassword,
                        obscureText: vm.obscurePassword,
                        iconButton: AppObscureTextIcon(
                          icon: vm.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onPressed: vm.onChangeObscure,
                        ),
                        validator: vm.validator,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        text: 'Confirmar contraseña',
                        controller: vm.tcPasswordConfirm,
                        obscureText: vm.obscurePasswordConfirm,
                        iconButton: AppObscureTextIcon(
                          icon: vm.obscurePasswordConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onPressed: vm.onChangeObscureConfirm,
                        ),
                        validator: vm.validator,
                      ),
                      const SizedBox(height: 10),
                      FlutterPwValidator(
                        controller: vm.tcPasswordConfirm,
                        minLength: 8,
                        uppercaseCharCount: 1,
                        numericCharCount: 1,
                        specialCharCount: 1,
                        width: MediaQuery.of(context).size.width * .90,
                        height: 120,
                        onSuccess: () => vm.isValidPassword = true,
                        onFail: () => vm.isValidPassword = false,
                        strings: FrenchStrings(),
                      ),
                      const SizedBox(height: 40),
                      AppButtonLogin(
                        icon: Icons.lock_open,
                        text: vm.activateUser
                            ? 'Activar Usuario'
                            : 'Resetear Contraseña',
                        onPressed: () {
                          if (vm.formKey.currentState!.validate()) {
                            vm.resetPassword(context);
                          }
                        },
                        color: AppColors.brownDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
