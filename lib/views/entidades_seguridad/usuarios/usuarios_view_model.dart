import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/adjuntos.dart';
import 'package:tasaciones_app/core/models/adjunto_foto_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/roles_api.dart';
import '../../../core/api/usuarios_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/roles_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../../auth/login/login_view.dart';
import '../widgets/buscador.dart';
import '../widgets/dialog_mostrar_informacion_permisos.dart';
import '../widgets/forms/form_crear_usuario.dart';
import '../widgets/forms/form_update_usuario.dart';

class UsuariosViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _usuariosApi = locator<UsuariosAPI>();
  final _rolesApi = locator<RolesAPI>();
  final listController = ScrollController();
  final _navigationService = locator<NavigatorService>();
  final _picker = ImagePicker();
  final _adjuntoApi = locator<AdjuntosApi>();

  TextEditingController tcBuscar = TextEditingController();

  List<UsuariosData> usuarios = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _tieneFoto = false;
  bool _tieneFirma = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late UsuariosResponse usuariosResponse;
  late File foto;
  late AdjuntoFoto? fotoPerfil;
  late AdjuntoFoto? fotoFirma;

  UsuariosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasUsuarios();
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
    usuarios.sort((a, b) {
      return a.nombreCompleto
          .toLowerCase()
          .compareTo(b.nombreCompleto.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    usuarios = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp = await _usuariosApi.getUsuarios(pageNumber: pageNumber);
    if (resp is Success) {
      usuariosResponse = resp.response as UsuariosResponse;
      usuarios = usuariosResponse.data;
      ordenar();
      hasNextPage = usuariosResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
    cargando = false;
  }

  Future<void> onRefresh() async {
    usuarios = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp = await _usuariosApi.getUsuarios(pageNumber: pageNumber);
    if (resp is Success) {
      usuariosResponse = resp.response as UsuariosResponse;
      usuarios = usuariosResponse.data;
      ordenar();
      hasNextPage = usuariosResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  Future<void> cargarMasUsuarios() async {
    pageNumber += 1;
    var resp = await _usuariosApi.getUsuarios(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as UsuariosResponse;
      usuarios.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  Future<void> buscarUsuario(String query) async {
    cargando = true;
    var resp = await _usuariosApi.getUsuarios(
      nombreCompleto: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as UsuariosResponse;
      usuarios = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
    cargando = false;
  }

  void limpiarBusqueda() {
    _busqueda = false;
    usuarios = usuariosResponse.data;
    if (usuarios.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> editarFoto(BuildContext ctx, String idUser) async {
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
          toolbarTitle: 'Editar firma',
          toolbarColor: AppColors.orange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,

          lockAspectRatio: false,
          // showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Editar firma',
        ),
      ],
    );
    foto = File(croppedFile!.path);
    ProgressDialog.show(ctx);
    var resp = await _adjuntoApi.updateFotoFirma(
      adjuntoInBytes: base64Encode(foto.readAsBytesSync()),
      idUser: idUser,
    );
    if (resp is Success) {
      ProgressDialog.dissmiss(ctx);
      Dialogs.success(msg: "Firma ingresada correctamente");
      _navigationService.pop(ctx);
      _navigationService.pop(ctx);
    }
    if (resp is Failure) {
      ProgressDialog.dissmiss(ctx);
      Dialogs.error(msg: resp.messages.first);
    }
    notifyListeners();
  }

  void cargarFoto(BuildContext context, String idUser) async {
    var img = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
    );
    if (img != null) {
      foto = File(img.path);
      editarFoto(context, idUser);
    }
  }

  Widget _noImageFirma(BuildContext context, String idUser) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
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
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: const Text(
                        'Firma Tasador',
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
                                      Icons.key,
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
                                              cargarFoto(context, idUser),
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
              });
        },
        icon: Container(
          width: 35,
          height: 35,
          color: AppColors.brownDark,
          child: const Icon(
            Icons.key,
            color: Colors.white,
          ),
        ));
  }

  Widget _haveImageFirma(BuildContext context, String image, String idUser) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
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
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: const Text(
                    'Firma Tasador',
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
                                    height:
                                        MediaQuery.of(context).size.width * .25,
                                    width:
                                        MediaQuery.of(context).size.width * .25,
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
                                        cargarFoto(context, idUser),
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
            });
      },
      icon: Container(
        width: 35,
        height: 35,
        color: AppColors.brownDark,
        child: const Icon(
          Icons.key,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _noImage(BuildContext context, String idUser) {
    return Stack(
      children: [
        ClipOval(
          child: Container(
            height: MediaQuery.of(context).size.width * .25,
            width: MediaQuery.of(context).size.width * .25,
            padding: const EdgeInsets.all(8),
            color: Colors.grey,
            child: Image.asset(
              'assets/img/no-avatar.png',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _haveImage(BuildContext context, String image, String idUser) {
    return Stack(
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
      ],
    );
  }

  Future<void> modificarUsuario(
      UsuariosData usuario, BuildContext context, Size size) async {
    String email = "", telefono = "", nombre = "";
    int idSuplidor = 0;
    GlobalKey<FormState> _key = GlobalKey();
    _tieneFoto = false;
    _tieneFirma = false;

    cargando = true;
    var resp = await _adjuntoApi.getFotoPerfil(idUser: usuario.id);
    if (resp is Success<AdjuntoFoto>) {
      fotoPerfil = resp.response;
      _tieneFoto = true;
    } else {
      if (resp is Failure) {
        Dialogs.error(msg: resp.messages.first);
      }
      if (resp is TokenFail) {
        Dialogs.error(msg: 'su sesión a expirado');
        _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
      }
    }
    cargando = false;

    if (usuario.roles.any((element) => element.description == "Tasador")) {
      cargando = true;
      var resp = await _adjuntoApi.getFotoFirma(idUser: usuario.id);
      if (resp is Success<AdjuntoFoto>) {
        fotoFirma = resp.response;
        _tieneFirma = true;
      } else {
        if (resp is Failure) {
          Dialogs.error(msg: resp.messages.first);
        }
        if (resp is TokenFail) {
          Dialogs.error(msg: 'su sesión a expirado');
          _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
        }
      }
      cargando = false;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.gold, width: 3)),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 75,
              child: dialogActualizarInformacion(
                  Column(
                    children: [
                      _tieneFoto
                          ? _haveImage(
                              context, fotoPerfil!.adjunto!, usuario.id)
                          : _noImage(context, usuario.id),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          usuario.roles.any(
                                  (element) => element.description == "Tasador")
                              ? _tieneFirma
                                  ? _haveImageFirma(
                                      context, fotoFirma!.adjunto!, usuario.id)
                                  : _noImageFirma(context, usuario.id)
                              : const SizedBox.shrink(),
                          usuario.roles.any(
                                  (element) => element.description == "Tasador")
                              ? const SizedBox(
                                  width: 15,
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                  size,
                  context,
                  _key,
                  nombre,
                  telefono,
                  email,
                  true,
                  (nombref, emailf, telefonof, noTasador) async {
                    if (nombref != "" || emailf != "" || telefonof != "") {
                      ProgressDialog.show(context);
                      var creacion = await _usuariosApi.updateUsuarios(
                          id: usuario.id,
                          email: emailf,
                          phoneNumber: telefonof,
                          fullName: nombref,
                          noTasador: noTasador == 0 ? null : noTasador);
                      if (creacion is Success<UsuarioPOSTResponse>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.success(msg: "Modificación de datos exitosa");
                        _key.currentState?.reset();
                        _navigationService.pop();
                        onInit();
                      } else if (creacion is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: creacion.messages.first);
                      }
                    }
                  },
                  "Modificar",
                  usuario,
                  () {
                    Dialogs.confirm(context,
                        tittle: (usuario.isActive ? "DESACTIVAR" : "ACTIVAR") +
                            " USUARIO",
                        description: "¿Esta seguro que desea " +
                            (usuario.isActive ? "desactivar" : "activar") +
                            " al usuario?", confirm: () async {
                      ProgressDialog.show(context);
                      var creacion = await _usuariosApi.updateStatusUsuario(
                          id: usuario.id, status: !usuario.isActive);
                      if (creacion is Success<UsuarioPOSTResponse>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.success(msg: "Estado actualizado");
                        _navigationService.pop();
                        onInit();
                      } else if (creacion is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: creacion.messages.first);
                      }
                    });
                  },
                  () async {
                    ProgressDialog.show(context);
                    var resp = await _rolesApi.getRoles();
                    if (resp is Success<RolResponse>) {
                      ProgressDialog.dissmiss(context);
                      if (usuario.roles.first.typeRolDescription == "Interno") {
                        resp.response.data.removeWhere((element) =>
                            element.typeRoleDescription != "Interno");
                      } else if (usuario.roles.first.typeRolDescription ==
                          "Externo") {
                        resp.response.data.removeWhere((element) =>
                            element.typeRoleDescription != "Externo");
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            var data = resp.response.data;
                            List<RolData> selectedRol2 = [];
                            for (var element in usuario.roles) {
                              selectedRol2.add(RolData(
                                  id: element.roleId,
                                  name: element.roleName,
                                  description: element.description,
                                  typeRole: element.typeRol,
                                  typeRoleDescription:
                                      element.typeRolDescription));
                            }

                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: EdgeInsets.zero,
                                content: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .75,
                                  child: dialogMostrarInformacionPermisos(
                                      Container(
                                        height: size.height * .08,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          color: AppColors.gold,
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text("Cambiar Rol",
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      buscador(
                                        text: 'Buscar rol...',
                                        onChanged: (value) {
                                          setState(() {
                                            data = resp.response.data
                                                .where((e) => e.name
                                                    .toLowerCase()
                                                    .contains(
                                                        value.toLowerCase()))
                                                .toList();
                                          });
                                        },
                                      ),
                                      data.isEmpty
                                          ? [
                                              const Padding(
                                                padding: EdgeInsets.all(50),
                                                child: Text(
                                                  'No hay resultados',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )
                                            ]
                                          : [
                                              DataTable(
                                                  onSelectAll: (isSelectedAll) {
                                                    setState(() => {
                                                          selectedRol2 =
                                                              isSelectedAll!
                                                                  ? data
                                                                      .toList()
                                                                  : [],
                                                        });
                                                  },
                                                  columns: const [
                                                    DataColumn(
                                                      label: Text("Rol"),
                                                    ),
                                                  ],
                                                  rows: data
                                                      .map((e) => DataRow(
                                                              selected: selectedRol2
                                                                  .any((element) =>
                                                                      element
                                                                          .id ==
                                                                      e.id),
                                                              onSelectChanged:
                                                                  (isSelected) =>
                                                                      setState(
                                                                          () {
                                                                        isSelected!
                                                                            ? selectedRol2.add(
                                                                                e)
                                                                            : selectedRol2.removeWhere((element) =>
                                                                                element.id ==
                                                                                e.id);
                                                                      }),
                                                              cells: [
                                                                DataCell(
                                                                  Text(
                                                                    e.description,
                                                                  ),
                                                                ),
                                                              ]))
                                                      .toList()),
                                            ],
                                      size,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              _navigationService.pop();
                                            },
                                            // button pressed
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                              if (selectedRol2.isNotEmpty) {
                                                ProgressDialog.show(context);
                                                List<RolData2> tempList = [];
                                                for (var element
                                                    in selectedRol2) {
                                                  tempList.add(RolData2(
                                                      roleId: element.id,
                                                      roleName: element.name,
                                                      description:
                                                          element.description,
                                                      enabled: true,
                                                      typeRol: element.typeRole,
                                                      typeRolDescription: element
                                                          .typeRoleDescription));
                                                }
                                                var cambio = await _usuariosApi
                                                    .updateRolUsuario(
                                                        id: usuario.id,
                                                        roles: tempList);
                                                if (cambio is Success<
                                                    UsuarioPOSTResponse>) {
                                                  ProgressDialog.dissmiss(
                                                      context);
                                                  Dialogs.success(
                                                      msg: "Roles asignados");
                                                  _navigationService.pop();
                                                  _navigationService.pop();
                                                  onInit();
                                                } else if (cambio is Failure) {
                                                  ProgressDialog.dissmiss(
                                                      context);
                                                  Dialogs.error(
                                                      msg: cambio
                                                          .messages.first);
                                                }
                                              }
                                            },
                                            // button pressed
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const <Widget>[
                                                Icon(
                                                  AppIcons.save,
                                                  color: AppColors.green,
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ), // icon
                                                Text("Cambiar"), // text
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            });
                          });
                    } else if (resp is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: resp.messages.first);
                    } else if (resp is TokenFail) {
                      Dialogs.error(msg: 'su sesión a expirado');
                      _navigationService
                          .navigateToPageAndRemoveUntil(LoginView.routeName);
                    }
                  },
                  idSuplidor),
            ),
          );
        });
  }

  Future<void> crearUsuario(BuildContext context, Size size) async {
    final _usuariosApi = locator<UsuariosAPI>();
    final _rolesApi = locator<RolesAPI>();
    final user = locator<AuthenticationClient>().loadSession;
    String nombre = "";
    String telefono = "";
    String email = "";
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear Usuario";
    bool validator = true;
    String buttonTittle = "Crear";
    Map<String, dynamic> rol1 = {};
    Map<String, dynamic> suplidor = {};
    List<RolData> roles = [];
    dynamic rolElegido;
    ProgressDialog.show(context);
    var resp = await _rolesApi.getRoles();
    if (resp is Success<RolResponse>) {
      ProgressDialog.dissmiss(context);
      for (var element in user.role) {
        if (element == "Administrador") {
          roles = resp.response.data;
          break;
        } else if (element == "AprobadorTasaciones") {
          roles = resp.response.data;
          roles.removeWhere(
              (element) => (element.typeRoleDescription != "Externo"));
        } else {
          roles = [];
        }
      }

      dialogCrearUsuario(titulo, size, context, _formKey, roles, nombre,
          telefono, email, validator,
          (nombref, emailf, telefonof, codigoSuplidorf, noTasador) async {
        if (codigoSuplidorf == 0) {
          ProgressDialog.show(context);
          var creacion = await _usuariosApi.createUsuarios(
              email: emailf,
              phoneNumber: telefonof,
              fullName: nombref,
              roleId: rol1['id'],
              codigoSuplidor: suplidor["codigoRelacional"],
              noTasador: noTasador == 0 ? null : noTasador);
          if (creacion is Success<UsuarioPOSTResponse>) {
            ProgressDialog.dissmiss(context);
            Dialogs.success(msg: "Creación de usuario exitosa");
            _navigationService.pop();
            onInit();
          } else if (creacion is Failure) {
            ProgressDialog.dissmiss(context);
            Dialogs.error(msg: creacion.messages[0]);
          }
        } else {
          ProgressDialog.show(context);
          var creacion = await _usuariosApi.createUsuarios(
              email: emailf,
              phoneNumber: telefonof,
              fullName: nombref,
              roleId: rol1['id'],
              codigoSuplidor: codigoSuplidorf,
              noTasador: noTasador == 0 ? null : noTasador);
          if (creacion is Success<UsuarioPOSTResponse>) {
            ProgressDialog.dissmiss(context);
            Dialogs.success(msg: "Creación de usuario exitosa");
            _navigationService.pop();
            onInit();
          } else if (creacion is Failure) {
            ProgressDialog.dissmiss(context);
            Dialogs.error(msg: creacion.messages[0]);
          }
        }
      }, rolElegido, buttonTittle, rol1, suplidor);
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages.first);
    } else if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigationService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  @override
  void dispose() {
    listController.dispose();
    super.dispose();
  }
}
