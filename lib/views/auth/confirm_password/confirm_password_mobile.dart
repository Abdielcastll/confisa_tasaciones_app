part of confirm_password_view;

class _ConfirmPasswordMobile extends StatelessWidget {
  final ConfirmPasswordViewModel vm;

  const _ConfirmPasswordMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AuthPageWidget(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
          width: size.width * .80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.brown.withOpacity(0.7),
          ),
          child: Column(
            children: [
              Text(
                'Jose Perez',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.white,
                    ),
              ),
              Text(
                'Aprobador de facturas',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                text: 'Nueva contraseña',
                controller: vm.tcPassword,
                obscureText: vm.obscurePassword,
                iconButton: AppObscureTextIcon(
                  icon: vm.obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onPressed: vm.onChangeObscure,
                ),
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
              )
            ],
          ),
        ),
        AppButtonLogin(
          text: 'SIGUIENTE',
          onPressed: () {},
          color: AppColors.brown,
        ),
        const SizedBox(height: 10),
        AppButtonLogin(
          text: 'ANTERIOR',
          onPressed: vm.goBack,
          color: AppColors.brown,
        )
      ],
    ));
  }
}
