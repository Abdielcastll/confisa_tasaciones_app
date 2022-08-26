part of cantidad_fotos_view;

class _CantidadFotosMobile extends StatelessWidget {
  final CantidadFotosViewModel vm;

  const _CantidadFotosMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: vm.cargando,
      opacity: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: const Text(
            'Cantidad Fotos',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.brownLight,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
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
                        onPressed: () =>
                            vm.modificarFotosCantidad(context, foto),
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
