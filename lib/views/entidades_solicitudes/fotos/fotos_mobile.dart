part of fotos_view;

class _FotosMobile extends StatelessWidget {
  final FotosViewModel vm;

  const _FotosMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Parametros Fotos',
            overflow: TextOverflow.ellipsis,
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
                        child: DropdownButton<String>(
                            value: vm.opcion,
                            items: vm.opciones(),
                            onChanged: (String? value) => vm.opcion = value!)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 1,
                  controller: vm.listController,
                  itemBuilder: (context, i) {
                    var foto = vm.foto;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
                      child: MaterialButton(
                        onPressed: vm.opcion == "Cantidad"
                            ? () => vm.modificarFotosCantidad(context, foto)
                            : () => vm.modificarFotosTipo(context, foto),
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 70,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      foto.descripcion ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.brownDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
