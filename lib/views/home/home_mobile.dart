part of home_view;

class _HomeMobile extends StatelessWidget {
  final HomeViewModel vm;

  const _HomeMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: const Text("Prueba Permisos"),
                onPressed: () async {
                  final _permisosAPI = locator<PermisosAPI>();
                  ProgressDialog.show(context);
                  var resp =
                      await _permisosAPI.getPermisos(token: vm.user.token);
                  if (resp is Success<PermisosResponse>) {
                    ProgressDialog.dissmiss(context);
                  } else if (resp is Failure) {
                    ProgressDialog.dissmiss(context);
                    Dialogs.alert(
                      context,
                      tittle: 'Error',
                      description: resp.messages,
                    );
                  }
                }),
            ElevatedButton(
                child: const Text("Prueba"), onPressed: vm.accesPermisos),
            ElevatedButton(
              child: const Text("Token"),
              onPressed: vm.accesToken,
            ),
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
    );
  }
}
