part of recovery_password_view;

class _RecoveryPasswordMobile extends StatelessWidget {
  final RecoveryPasswordViewModel vm;

  const _RecoveryPasswordMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return ProgressWidget(
      inAsyncCall: vm.loading,
      child: Scaffold(
          appBar: AppBar(title: const Text('Reiniciar Contraseña')),
          backgroundColor: AppColors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: vm.formKey,
                  child: AppTextField(
                    text: 'Email',
                    controller: vm.tcEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                ),
                const SizedBox(height: 40),
                AppButtonLogin(
                  icon: Icons.lock_open,
                  text: 'Reiniciar Contraseña',
                  onPressed: () => vm.forgotPassword(context),
                  color: AppColors.brownDark,
                ),
              ],
            ),
          )),
    );
  }
}
