part of home_view;

class _LoginMobile extends StatelessWidget {
  final LoginViewModel vm;

  const _LoginMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.loading,
      child: AuthPageWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
              text: 'Email',
              controller: vm.tcEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),
            AppTextField(
              text: 'Contraseña',
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
              text: 'INGRESAR',
              onPressed: () => vm.signIn(context),
              color: AppColors.green,
            ),
            const SizedBox(height: 10),
            AppButtonLogin(
              text: 'RECUPERAR CONTRASEÑA',
              onPressed: () => vm.goToRecoveryPassword(),
              color: AppColors.orange,
            )
          ],
        ),
      ),
    );
  }
}
