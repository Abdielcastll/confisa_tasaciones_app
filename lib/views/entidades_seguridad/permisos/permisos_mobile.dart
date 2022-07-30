part of permisos_view;

class _PermisosMobile extends StatelessWidget {
  final PermisosViewModel vm;

  const _PermisosMobile(this.vm);

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
            'Permisos',
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
                          onSubmitted: vm.buscarPermiso,
                          style: const TextStyle(
                            color: AppColors.brownDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Buscar permisos...',
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w700),
                            suffixIcon: !vm.busqueda
                                ? IconButton(
                                    icon: const Icon(AppIcons.search),
                                    onPressed: () =>
                                        vm.buscarPermiso(vm.tcBuscar.text),
                                    color: AppColors.brownDark,
                                  )
                                : IconButton(
                                    onPressed: vm.limpiarBusqueda,
                                    icon: const Icon(
                                      AppIcons.closeCircle,
                                      color: AppColors.brownDark,
                                    )),
                          ),
                        )),
                  ),
                ),
                MaterialButton(
                  onPressed: () => vm.crearPermiso(context, size),
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
                child: vm.permisos.isEmpty
                    ? const RefreshWidget()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: vm.permisos.length + 1,
                        controller: vm.listController,
                        itemBuilder: (context, i) {
                          if (i >= vm.permisos.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: !vm.hasNextPage
                                  ? const SizedBox()
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            );
                          }
                          var permiso = vm.permisos[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: MaterialButton(
                              onPressed: () =>
                                  vm.modificarPermiso(permiso, context),
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 70,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  permiso.descripcion,
                                  style: const TextStyle(
                                    color: AppColors.brownDark,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
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
