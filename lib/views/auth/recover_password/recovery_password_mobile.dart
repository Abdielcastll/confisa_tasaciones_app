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
              borderRadius: BorderRadius.circular(18),
              color: AppColors.brownLight.withOpacity(0.7),
            ),
            child: Column(
              children: [
                Text(
                  'Recibirá un link a su correo',
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
                ),
              ],
            ),
          ),
          AppButtonLogin(
            text: 'SIGUIENTE',
            onPressed: () => vm.forgotPassword(context),
            color: AppColors.green,
          ),
          const SizedBox(height: 10),
          AppButtonLogin(
            text: 'ANTERIOR',
            onPressed: vm.goBack,
            color: AppColors.orange,
          )
        ],
      )),
    );
  }
}
