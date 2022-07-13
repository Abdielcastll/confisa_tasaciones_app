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
        appBar: const Appbar(titulo: 'Perfil de usuario', textSize: 20),
        body: Column(
          children: [
            CardProfileWidget(profile: vm.profile),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                      text: 'Anterior',
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.orange),
                  AppButton(
                      text: 'Guardar',
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.green),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
