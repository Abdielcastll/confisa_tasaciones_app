import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_facturacion/documentos_facturacion_api.dart';
import 'package:tasaciones_app/core/models/seguridad_facturacion/documentos_facturacion_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class DocumentosFacturacionViewModel extends BaseViewModel {
  final _documentosFacturacionApi = locator<DocumentosFacturacionApi>();
  final listController = ScrollController();
  TextEditingController tcNewDescripcion = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<DocumentosFacturacionData> documentosFacturacion = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late DocumentosFacturacionResponse documentosFacturacionResponse;

  DocumentosFacturacionViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasDocumentosFacturacion();
        }
      }
    });
  }

  bool get cargando => _cargando;
  set cargando(bool value) {
    _cargando = value;
    notifyListeners();
  }

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  void ordenar() {
    documentosFacturacion.sort((a, b) {
      return a.descripcion.toLowerCase().compareTo(b.descripcion.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    var resp = await _documentosFacturacionApi.getDocumentoFacturacion(
        pageNumber: pageNumber);
    if (resp is Success) {
      documentosFacturacionResponse =
          resp.response as DocumentosFacturacionResponse;
      documentosFacturacion = documentosFacturacionResponse.data;
      ordenar();
      hasNextPage = documentosFacturacionResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasDocumentosFacturacion() async {
    pageNumber += 1;
    var resp = await _documentosFacturacionApi.getDocumentoFacturacion(
        pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as DocumentosFacturacionResponse;
      documentosFacturacionResponse.data.addAll(temp.data);
      documentosFacturacion.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarDocumentosFacturacion(String query) async {
    cargando = true;
    var resp = await _documentosFacturacionApi.getDocumentoFacturacion(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as DocumentosFacturacionResponse;
      documentosFacturacion = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  void limpiarBusqueda() {
    _busqueda = false;
    documentosFacturacion = documentosFacturacionResponse.data;
    if (documentosFacturacion.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    documentosFacturacion = [];
    cargando = true;
    var resp = await _documentosFacturacionApi.getDocumentoFacturacion();
    if (resp is Success) {
      var temp = resp.response as DocumentosFacturacionResponse;
      documentosFacturacionResponse = temp;
      documentosFacturacion = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> modificarDocumentosFacturacion(
      BuildContext ctx, DocumentosFacturacionData documentosFacturacion) async {
    tcNewDescripcion.text = documentosFacturacion.descripcion;
    final GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: AppColors.brownLight,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Modificar Documento Facturación',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewDescripcion,
                                decoration: const InputDecoration(
                                  label: Text("Descripción"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: documentosFacturacion
                                    .descripcionEstadoTasacion,
                                decoration: const InputDecoration(
                                  label: Text("Descripción Estado Tasación"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Dialogs.confirm(ctx,
                              tittle: 'Eliminar Documento Facturación',
                              description:
                                  '¿Esta seguro de eliminar el documento facturación ${documentosFacturacion.descripcion}?',
                              confirm: () async {
                            ProgressDialog.show(ctx);
                            var resp = await _documentosFacturacionApi
                                .deleteDocumentosFacturacion(
                                    id: documentosFacturacion.id);
                            ProgressDialog.dissmiss(ctx);
                            if (resp is Failure) {
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Documento Facturación eliminada');
                              await onRefresh();
                            }
                          });
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.trash,
                              color: AppColors.grey,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Eliminar"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewDescripcion.clear();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.closeCircle,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Cancelar"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (tcNewDescripcion.text.trim() !=
                                documentosFacturacion.descripcion) {
                              ProgressDialog.show(context);
                              var resp = await _documentosFacturacionApi
                                  .updateDocumentosFacturacion(
                                      descripcion: tcNewDescripcion.text.trim(),
                                      id: documentosFacturacion.id);
                              ProgressDialog.dissmiss(context);
                              if (resp is Success) {
                                Dialogs.success(
                                    msg: 'Documento Facturación Actualizado');
                                Navigator.of(context).pop();
                                await onRefresh();
                              }

                              if (resp is Failure) {
                                ProgressDialog.dissmiss(context);
                                Dialogs.error(msg: resp.messages[0]);
                              }
                              tcNewDescripcion.clear();
                            } else {
                              Dialogs.success(
                                  msg: 'Documento Facturación Actualizado');
                              Navigator.of(context).pop();
                            }
                          }
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.save,
                              color: AppColors.green,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Guardar"), // text
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  Future<void> crearDocumentoFacturacion(BuildContext ctx) async {
    tcNewDescripcion.clear();
    final GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: AppColors.brownLight,
                    child: const Text(
                      'Crear Documentos Facturación',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tcNewDescripcion,
                        validator: (value) {
                          if (value!.trim() == '') {
                            return 'Escriba una descripción';
                          } else {
                            return null;
                          }
                        },
                        maxLines: 5,
                        decoration: const InputDecoration(
                          label: Text("Descripción"),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          tcNewDescripcion.clear();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.closeCircle,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Cancelar"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ProgressDialog.show(context);
                            var resp = await _documentosFacturacionApi
                                .createDocumentoFacturacion(
                                    descripcion: tcNewDescripcion.text.trim());
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(
                                  msg: 'Documentos Facturación Creado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            tcNewDescripcion.clear();
                          }
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.save,
                              color: AppColors.green,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Guardar"), // text
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    listController.dispose();
    tcNewDescripcion.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
