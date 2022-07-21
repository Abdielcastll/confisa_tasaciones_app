part of usuarios_view;

class _UsuariosMobile extends StatelessWidget {
  final UsuariosViewModel vm;

  const _UsuariosMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Usuarios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.brownLight,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: vm.tcBuscar,
                        onSubmitted: vm.buscarUsuario,
                        style: const TextStyle(
                          color: AppColors.brownDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Buscar usuarios...',
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w700),
                          suffixIcon: !vm.busqueda
                              ? const Icon(
                                  Icons.search_outlined,
                                  color: AppColors.brownDark,
                                )
                              : IconButton(
                                  onPressed: vm.limpiarBusqueda,
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    color: AppColors.brownDark,
                                  )),
                        ),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () => vm.crearUsuario(context, size),
                  color: Colors.white,
                  minWidth: 30,
                  height: 48,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 4,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.add_circle_sharp,
                      color: AppColors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: vm.usuarios.length + 1,
                  controller: vm.listController,
                  itemBuilder: (context, i) {
                    if (i >= vm.usuarios.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: !vm.hasNextPage
                            ? const SizedBox()
                            : const Center(child: CircularProgressIndicator()),
                      );
                    }
                    var usuario = vm.usuarios[i];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () =>
                            vm.modificarUsuario(usuario, context, size),
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 70,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usuario.nombreCompleto,
                                style: const TextStyle(
                                  color: AppColors.brownDark,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                "Correo/Usuario: ${usuario.email}",
                                style: const TextStyle(
                                    color: AppColors.brownDark, fontSize: 12),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Roles: ",
                                    style: TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 12),
                                  ),
                                  ...usuario.roles.map((e) => Text(
                                        "${e.description} ",
                                        style: const TextStyle(
                                            color: AppColors.brownDark,
                                            fontSize: 12),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
