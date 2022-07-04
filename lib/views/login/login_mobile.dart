part of home_view;

class _LoginMobile extends StatelessWidget {
  final LoginViewModel vm;

  const _LoginMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 150,
              child: Image.asset('assets/img/header.png', fit: BoxFit.none),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 300,
              // color: AppColors.brownDark,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/fondo.png'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextField(
                    text: 'Email',
                    controller: vm.tcEmail,
                    obscureText: false,
                    iconButton: const SizedBox(),
                  ),
                  const SizedBox(height: 25),
                  AppTextField(
                    text: 'Password',
                    controller: vm.tcPassword,
                    obscureText: vm.obscurePassword,
                    iconButton: AppObscureTextIcon(vm: vm),
                  ),
                  const SizedBox(height: 25),
                  AppButtonLogin(
                    text: 'INGRESAR',
                    onPressed: () {
                      vm.signIn(context);
                    },
                    color: AppColors.orange,
                  ),
                  AppButtonLogin(
                    text: 'RECUPERAR CONTRASEÑA',
                    onPressed: () {},
                    color: AppColors.green,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: Image.asset('assets/img/footer.png', fit: BoxFit.cover),
            )
          ],
        ),
      ),
    );
  }
}
