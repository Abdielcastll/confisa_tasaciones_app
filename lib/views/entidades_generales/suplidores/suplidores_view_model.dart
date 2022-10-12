import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/adjuntos.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';
import 'package:tasaciones_app/core/services/navigator_service.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../theme/theme.dart';

class SuplidoresViewModel extends BaseViewModel {
  final _suplidoresApi = locator<SuplidoresApi>();
  final _adjuntoApi = locator<AdjuntosApi>();
  final _navigationService = locator<NavigatorService>();
  final _userClient = locator<UserClient>();
  final listController = ScrollController();
  final _picker = ImagePicker();
  TextEditingController tcNewDetalle = TextEditingController();
  TextEditingController tcNewRegistro = TextEditingController();
  TextEditingController tcBuscar = TextEditingController();

  List<SuplidorData> suplidores = [];

  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool _tieneFoto = false;
  bool hasNextPage = false;
  late SuplidoresResponse suplidoresResponse;
  late File foto;
  late AdjuntoFoto? fotoPerfil;
  late Profile? usuario;

  SuplidoresViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasSuplidores();
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
    suplidores.sort((a, b) {
      return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    usuario = _userClient.loadProfile;
    var resp = await _suplidoresApi.getSuplidores(pageNumber: pageNumber);
    if (resp is Success) {
      suplidoresResponse = resp.response as SuplidoresResponse;
      suplidores = suplidoresResponse.data;
      ordenar();
      /* hasNextPage = suplidoresResponse.hasNextPage; */
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    cargando = false;
  }

  Future<void> cargarMasSuplidores() async {
    pageNumber += 1;
    var resp = await _suplidoresApi.getSuplidores(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as SuplidoresResponse;
      suplidoresResponse.data.addAll(temp.data);
      suplidores.addAll(temp.data);
      ordenar();
      /* hasNextPage = temp.hasNextPage; */
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
  }

  Future<void> buscarSuplidor(String query) async {
    cargando = true;
    var resp = await _suplidoresApi.getSuplidores(
      nombre: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as SuplidoresResponse;
      suplidores = temp.data;
      ordenar();
      /* hasNextPage = temp.hasNextPage; */
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    cargando = false;
  }

  void limpiarBusqueda() {
    _busqueda = false;
    suplidores = suplidoresResponse.data;
    if (suplidores.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> onRefresh() async {
    suplidores = [];
    cargando = true;
    var resp = await _suplidoresApi.getSuplidores();
    if (resp is Success) {
      var temp = resp.response as SuplidoresResponse;
      suplidoresResponse = temp;
      suplidores = temp.data;
      ordenar();
      /* hasNextPage = temp.hasNextPage; */
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    cargando = false;
  }

  Future<void> modificarSuplidor(
      BuildContext ctx, SuplidorData suplidor) async {
    tcNewDetalle.text = suplidor.detalles;
    tcNewRegistro.text = suplidor.registro;
    String selectEstado = suplidor.estado == 1 ? "Activo" : "Inactivo";
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: AppColors.brownLight,
                  child: const Text(
                    'Modificar suplidor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: suplidor.nombre,
                                decoration: const InputDecoration(
                                  label: Text("Nombre"),
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
                                initialValue: suplidor.identificacion,
                                decoration: const InputDecoration(
                                  label: Text("Identificación"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          suplidor.direccion != ""
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: suplidor.direccion,
                                      decoration: const InputDecoration(
                                        label: Text("Dirección"),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          suplidor.email != ""
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: suplidor.email,
                                      decoration: const InputDecoration(
                                        label: Text("Email"),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          suplidor.celular != ""
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: suplidor.celular,
                                      decoration: const InputDecoration(
                                        label: Text("Celular"),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          suplidor.telefono != ""
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: suplidor.telefono,
                                      decoration: const InputDecoration(
                                        label: Text("Teléfono"),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewRegistro,
                                decoration: const InputDecoration(
                                  label: Text("Registro"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewDetalle,
                                decoration: const InputDecoration(
                                  label: Text("Detalle"),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: false,
                              initialValue:
                                  suplidor.estado == 1 ? "Activo" : "Inactivo",
                              decoration: const InputDecoration(
                                labelText: "Estado",
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () async {
                        ProgressDialog.show(context);
                        var resp = await _suplidoresApi.updateSuplidor(
                            detalles: suplidor.detalles,
                            registro: suplidor.registro,
                            estado: suplidor.estado == 1 ? 0 : 1,
                            idSuplidor: suplidor.codigoRelacionado);
                        ProgressDialog.dissmiss(context);
                        if (resp is Success) {
                          Dialogs.success(
                              msg:
                                  'Estado ${suplidor.estado == 1 ? "inactivado" : "activado"}');
                          Navigator.of(context).pop();
                          await onRefresh();
                        }

                        if (resp is Failure) {
                          ProgressDialog.dissmiss(context);
                          Dialogs.error(msg: resp.messages[0]);
                        }
                        if (resp is TokenFail) {
                          _navigationService.navigateToPageAndRemoveUntil(
                              LoginView.routeName);
                          Dialogs.error(msg: 'Sesión expirada');
                        }
                        tcNewDetalle.clear();
                        tcNewRegistro.clear();
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            suplidor.estado == 1
                                ? AppIcons.uncheckCircle
                                : AppIcons.checkCircle,
                            color: AppColors.grey,
                          ),
                          const SizedBox(
                            height: 3,
                          ), // icon
                          Text(
                            suplidor.estado == 1 ? "Inactivar" : "Activar",
                            overflow: TextOverflow.ellipsis,
                          ), // text
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        tcNewDetalle.clear();
                        tcNewRegistro.clear();
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
                        ProgressDialog.show(context);
                        var resp = await _adjuntoApi.getLogoSuplidor(
                            idSuplidor: suplidor.codigoRelacionado);
                        if (resp is Success<AdjuntoFoto>) {
                          ProgressDialog.dissmiss(context);
                          fotoPerfil = resp.response;
                          _tieneFoto = true;
                          showDialog(
                            context: context,
                            builder: (context) => _haveImage(
                                context,
                                fotoPerfil!.adjunto!,
                                usuario!.id!,
                                suplidor.codigoRelacionado),
                          );
                        } else {
                          if (resp is Failure) {
                            ProgressDialog.dissmiss(context);
                            if (resp.messages.first != "No Internet") {
                              showDialog(
                                  context: context,
                                  builder: (context) => _noImage(
                                      context,
                                      usuario!.id!,
                                      suplidor.codigoRelacionado));
                            }

                            Dialogs.error(msg: resp.messages.first);
                          }
                          if (resp is TokenFail) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.error(msg: 'su sesión a expirado');
                            _navigationService.navigateToPageAndRemoveUntil(
                                LoginView.routeName);
                          }
                        }
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.account_circle_sharp,
                            color: AppColors.gold,
                          ),
                          SizedBox(
                            height: 3,
                          ), // icon
                          Text("Logo"), // text
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (tcNewDetalle.text.trim() != suplidor.detalles ||
                              tcNewRegistro.text.trim() != suplidor.registro ||
                              suplidor.estado !=
                                  (selectEstado == "Activo" ? 1 : 0)) {
                            ProgressDialog.show(context);
                            var resp = await _suplidoresApi.updateSuplidor(
                                detalles: tcNewDetalle.text.trim(),
                                registro: tcNewRegistro.text.trim(),
                                estado: suplidor.estado,
                                idSuplidor: suplidor.codigoRelacionado);
                            ProgressDialog.dissmiss(context);
                            if (resp is Success) {
                              Dialogs.success(msg: 'Suplidor Actualizado');
                              Navigator.of(context).pop();
                              await onRefresh();
                            }

                            if (resp is Failure) {
                              ProgressDialog.dissmiss(context);
                              Dialogs.error(msg: resp.messages[0]);
                            }
                            if (resp is TokenFail) {
                              _navigationService.navigateToPageAndRemoveUntil(
                                  LoginView.routeName);
                              Dialogs.error(msg: 'Sesión expirada');
                            }
                            tcNewDetalle.clear();
                            tcNewRegistro.clear();
                          } else {
                            Dialogs.success(msg: 'Suplidor Actualizado');
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
              ],
            ),
          );
        });
  }

  Future<void> editarFoto(
      BuildContext ctx, String idUser, int idSuplidor) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: foto.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar foto',
          toolbarColor: AppColors.orange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,

          lockAspectRatio: false,
          // showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Editar foto',
        ),
      ],
    );
    foto = File(croppedFile!.path);
    ProgressDialog.show(ctx);
    var resp = await _adjuntoApi.updateLogoSuplidor(
        adjuntoInBytes: base64Encode(foto.readAsBytesSync()),
        idUser: idUser,
        idSuplidor: idSuplidor);
    if (resp is Success) {
      ProgressDialog.dissmiss(ctx);
      Dialogs.success(msg: "Logo ingresado correctamente");
      _navigationService.pop(ctx);
    }
    if (resp is Failure) {
      ProgressDialog.dissmiss(ctx);
      Dialogs.error(msg: resp.messages.first);
    }
    notifyListeners();
  }

  void cargarFoto(BuildContext context, String idUser, int idSuplidor) async {
    var img = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
    );
    if (img != null) {
      foto = File(img.path);
      editarFoto(context, idUser, idSuplidor);
    }
  }

  Widget _noImage(BuildContext context, String idUser, int idSuplidor) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Container(
          height: 80,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppColors.brownLight,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: const Text(
            'Logo Suplidor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Stack(
                  children: [
                    ClipOval(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.grey,
                        child: const Icon(
                          Icons.photo_size_select_actual_outlined,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: ClipOval(
                          child: Container(
                            height: 35,
                            width: 35,
                            color: AppColors.brown,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_a_photo_rounded,
                                size: 20,
                              ),
                              onPressed: () =>
                                  cargarFoto(context, idUser, idSuplidor),
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _haveImage(
      BuildContext context, String image, String idUser, int idSuplidor) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Container(
        height: 80,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: AppColors.brownLight,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: const Text(
          'Logo Suplidor',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Stack(
              children: [
                ClipOval(
                  child: Container(
                    height: MediaQuery.of(context).size.width * .25,
                    width: MediaQuery.of(context).size.width * .25,
                    color: Colors.white,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        color: Colors.red,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Image.memory(
                                base64Decode(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        icon: Image.memory(
                          base64Decode(image),
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.width * .25,
                          width: MediaQuery.of(context).size.width * .25,
                        )),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: ClipOval(
                      child: Container(
                        height: 35,
                        width: 35,
                        color: AppColors.brown,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo_rounded,
                            size: 20,
                          ),
                          onPressed: () =>
                              cargarFoto(context, idUser, idSuplidor),
                          color: Colors.white,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
    /* Stack(
      children: [
        ClipOval(
          child: Container(
            height: MediaQuery.of(context).size.width * .25,
            width: MediaQuery.of(context).size.width * .25,
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Image.memory(
                        base64Decode(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                icon: Image.memory(
                  base64Decode(image),
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.width * .25,
                  width: MediaQuery.of(context).size.width * .25,
                )),
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: ClipOval(
              child: Container(
                height: 35,
                width: 35,
                color: AppColors.brown,
                child: IconButton(
                  icon: const Icon(
                    Icons.add_a_photo_rounded,
                    size: 20,
                  ),
                  onPressed: () => cargarFoto(context, idUser, idSuplidor),
                  color: Colors.white,
                ),
              ),
            ))
      ],
    ); */
  }

  @override
  void dispose() {
    listController.dispose();
    tcNewDetalle.dispose();
    tcNewRegistro.dispose();
    tcBuscar.dispose();
    super.dispose();
  }
}
