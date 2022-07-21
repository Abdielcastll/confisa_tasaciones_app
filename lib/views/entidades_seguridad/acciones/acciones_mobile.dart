part of acciones_view;

class _AccionesMobile extends StatelessWidget {
  final AccionesViewModel vm;

  const _AccionesMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Acciones',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.brownLight,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Buscar',
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: AppColors.brownDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
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
                  itemCount: vm.acciones.length + 1,
                  controller: vm.listController,
                  itemBuilder: (context, i) {
                    if (i >= vm.acciones.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: !vm.hasNextPage
                            ? const SizedBox()
                            : const Center(child: CircularProgressIndicator()),
                      );
                    }
                    var accion = vm.acciones[i];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 70,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            accion.nombre,
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
            )
          ],
        ),
      ),
    );
  }
}