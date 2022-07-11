part of home_view;

class _HomeMobile extends StatelessWidget {
  final HomeViewModel vm;

  const _HomeMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.loading,
      child: Scaffold(
        drawer: GlobalDrawerDartDesktop(),
        appBar: AppBar(
          title: const Text('Mobile'),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  child: const Text("Prueba"), onPressed: vm.accesPermisos),
              Text(
                vm.user.nombreCompleto,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                vm.user.email,
                style: const TextStyle(fontSize: 18),
              ),
              ...vm.user.role.map((e) => Text(e)),
            ],
          ),
        ),
      ),
    );
  }
}
