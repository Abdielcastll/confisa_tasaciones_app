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
                              ? IconButton(
                                  icon: const Icon(AppIcons.search),
                                  onPressed: () =>
                                      vm.buscarUsuario(vm.tcBuscar.text),
                                  color: AppColors.brownDark,
                                )
                              : IconButton(
                                  onPressed: vm.limpiarBusqueda,
                                  icon: const Icon(
                                    AppIcons.closeCircle,
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
                      AppIcons.iconPlus,
                      color: AppColors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => vm.onRefresh(),
                child: vm.usuarios.isEmpty
                    ? const RefreshWidget()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: vm.usuarios.length + 1,
                        controller: vm.listController,
                        itemBuilder: (context, i) {
                          if (i >= vm.usuarios.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: !vm.hasNextPage
                                  ? const SizedBox()
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            );
                          }
                          var usuario = vm.usuarios[i];
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: MaterialButton(
                                onPressed: () =>
                                    vm.modificarUsuario(usuario, context, size),
                                color: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 86,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              usuario.nombreCompleto,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: AppColors.brownDark,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              "Correo/Usuario: ${usuario.email}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: AppColors.brownDark,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              "Roles: " +
                                                  (usuario.roles
                                                      .map((e) => e.description)
                                                      .toList()
                                                      .join(", ")
                                                      .toString()),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: AppColors.brownDark,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        usuario.isActive
                                            ? AppIcons.checkCircle
                                            : AppIcons.nonCheckCircle,
                                        color: AppColors.gold,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
