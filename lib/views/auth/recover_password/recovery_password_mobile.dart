part of recovery_password_view;

class _RecoveryPasswordMobile extends StatelessWidget {
  final RecoveryPasswordViewModel vm;

  const _RecoveryPasswordMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ProgressWidget(
      inAsyncCall: vm.loading,
      child: AuthPageWidget(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 20),
            width: size.width * .80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.brown.withOpacity(0.7),
            ),
            child: Form(
              key: vm.formKey,
              child: Column(
                children: [
                  Text(
                    'Escriba su correo',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    text: 'Email',
                    controller: vm.tcEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                ],
              ),
            ),
          ),
          AppButtonLogin(
            text: 'Siguiente',
            onPressed: () => vm.forgotPassword(context),
            color: AppColors.brown,
          ),
          const SizedBox(height: 10),
          AppButtonLogin(
            text: 'Anterior',
            onPressed: vm.goBack,
            color: AppColors.brown,
          )
        ],
      )),
    );
  }
}
