part of home_view;

class _LoginMobile extends StatelessWidget {
  final LoginViewModel vm;

  const _LoginMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.loading,
      child: AuthPageWidget(
        child: Form(
          key: vm.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(
                text: 'Usuario',
                controller: vm.tcEmail,
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              const SizedBox(height: 25),
              AppTextField(
                text: 'Contraseña',
                validator: passwordValidator,
                controller: vm.tcPassword,
                obscureText: vm.obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                iconButton: AppObscureTextIcon(
                  icon: vm.obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onPressed: vm.changeObscure,
                ),
              ),
              const SizedBox(height: 25),
              AppButtonLogin(
                text: 'Iniciar Sesión',
                onPressed: () => vm.signIn(context),
                color: AppColors.brown,
              ),
              const SizedBox(height: 10),
              TextButton(
                child: Text(
                  '¿Olvido su contraseña?',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),

                onPressed: () => vm.goToRecoveryPassword(),
                // color: AppColors.orange,
              )
            ],
          ),
        ),
      ),
    );
  }
}
