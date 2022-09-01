part of perfil_view;

class _PerfilMobile extends StatelessWidget {
  final PerfilViewModel vm;

  const _PerfilMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.loading,
      opacity: false,
      child: Scaffold(
// <<<<<<< HEAD
        // appBar: Appbar(titulo: 'Perfil de usuario', textSize: 20),
// =======
        appBar: Appbar(
          titulo: 'Perfil de usuario',
          textSize: 20,
          alarmas: [],
          esColaSolicitud: false,
          currentForm: 0,
          idSolicitud: 0,
        ),
// >>>>>>> 54fea58bf1ebd9fae1f7632f65f5438839711932
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    vm.currentPage == 0
                        ? CardProfileWidget(vm)
                        : CardChangePasswordWidget(vm),
                    // const Spacer(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                      text: 'Anterior',
                      onPressed: () => vm.currentPage == 1
                          ? vm.currentPage = 0
                          : Navigator.of(context).pop(),
                      color: AppColors.orange),
                  if (vm.editable())
                    AppButton(
                      text: 'Guardar',
                      onPressed: () => vm.currentPage == 0
                          ? vm.guardarPerfil(context)
                          : vm.updatePassword(context),
                      color: AppColors.green,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
