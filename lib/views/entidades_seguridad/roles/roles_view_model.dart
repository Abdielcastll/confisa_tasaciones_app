import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/permisos_api.dart';
import '../../../core/api/roles_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/permisos_response.dart';
import '../../../core/models/roles_claims_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../widgets/buscador.dart';
import '../widgets/dialog_mostrar_informacion_permisos.dart';
import '../widgets/dialog_mostrar_informacion_roles.dart';
import '../widgets/forms/form_actualizar_rol.dart';

class RolesViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _rolesApi = locator<RolesAPI>();
  final _permisosApi = locator<PermisosAPI>();
  final listController = ScrollController();
  final _navigationService = locator<NavigatorService>();

  TextEditingController tcBuscar = TextEditingController();

  List<RolData> roles = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late RolResponse rolesResponse;

  RolesViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasRoles();
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
    roles.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    roles = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp = await _rolesApi.getRoles(pageNumber: pageNumber);
    if (resp is Success) {
      rolesResponse = resp.response as RolResponse;
      roles = rolesResponse.data;
      ordenar();
      hasNextPage = rolesResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> onRefresh() async {
    roles = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp = await _rolesApi.getRoles(pageNumber: pageNumber);
    if (resp is Success) {
      rolesResponse = resp.response as RolResponse;
      roles = rolesResponse.data;
      ordenar();
      hasNextPage = rolesResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> cargarMasRoles() async {
    pageNumber += 1;
    var resp = await _rolesApi.getRoles(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as RolResponse;
      roles.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
      pageNumber -= 1;
    }
  }

  Future<void> buscarRol(String query) async {
    cargando = true;
    var resp = await _rolesApi.getRoles(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as RolResponse;
      roles = temp.data;
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
    roles = rolesResponse.data;
    if (roles.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  bool buscando = false;

  Future<void> modificarRol(
      RolData rol, BuildContext context, Size size) async {
    String titulo = "Actualizar Rol";
    final GlobalKey<FormState> _formKey = GlobalKey();
    const String buttonTittle = "Modificar";
    final _rolesApi = locator<RolesAPI>();
    bool validator = true;
    ProgressDialog.show(context);
    var resp = await _rolesApi.getTiposRoles();
    if (resp is Success<RolTipeResponse>) {
      ProgressDialog.dissmiss(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: ActualizarRolForm(
                      rol: rol,
                      showEliminar: true,
                      formKey: _formKey,
                      size: size,
                      titulo: titulo,
                      validator: validator,
                      modificar: (nombref, descripcionf, tipoRol) async {
                        ProgressDialog.show(context);
                        var resp = await _rolesApi.updateRol(
                            rol.id, nombref, descripcionf, tipoRol["id"]);
                        if (resp is Success<RolPOSTResponse>) {
                          ProgressDialog.dissmiss(context);
                          Dialogs.success(msg: "Modificacion Exitosa");
                          _navigationService.pop();
                          onInit();
                        } else if (resp is Failure) {
                          ProgressDialog.dissmiss(context);
                          Dialogs.error(msg: resp.messages.first);
                        }
                      },
                      eliminar: () {
                        Dialogs.confirm(context,
                            tittle: "Eliminar Rol",
                            description:
                                "Esta seguro que desea eliminar el rol?",
                            confirm: () async {
                          ProgressDialog.show(context);
                          var resp = await _rolesApi.deleteRol(rol.id);
                          if (resp is Success<RolPOSTResponse>) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.success(msg: "Eliminado con exito");
                            _navigationService.pop();
                            onInit();
                          } else if (resp is Failure) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.error(msg: resp.messages.first);
                          }
                        });
                      },
                      changePermisos: () async {
                        List<RolClaimsData> list = [];
                        ProgressDialog.show(context);
                        var resp =
                            await _rolesApi.getRolesClaims(idRol: rol.id);
                        if (resp is Success<RolClaimsResponse>) {
                          var resp2 = await _permisosApi.getPermisos();
                          if (resp2 is Success<PermisosResponse>) {
                            ProgressDialog.dissmiss(context);
                            for (var element in resp2.response.data) {
                              list.add(RolClaimsData(
                                  id: element.id,
                                  descripcion: element.descripcion));
                            }
                            list.sort((a, b) {
                              return a.descripcion
                                  .toLowerCase()
                                  .compareTo(b.descripcion.toLowerCase());
                            });
                            bool isSelect = false;
                            showDialog(
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  List<RolClaimsData> selectedPermisos = [];
                                  int first = 1;
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    if (first == 1) {
                                      setState(() {
                                        selectedPermisos = resp.response.data;
                                        first = first + 1;
                                      });
                                    }

                                    return AlertDialog(
                                      insetPadding: const EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      contentPadding: EdgeInsets.zero,
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .75,
                                        child: dialogMostrarInformacionRoles(
                                          Container(
                                            height: size.height * .08,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: AppColors.gold,
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  "Permisos de ${rol.description}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: AppColors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          [
                                            DataTable(
                                                onSelectAll: (isSelectedAll) {
                                                  setState(() => {
                                                        selectedPermisos =
                                                            isSelectedAll!
                                                                ? list
                                                                : [],
                                                        isSelect = isSelectedAll
                                                      });
                                                },
                                                columns: const [
                                                  DataColumn(
                                                    label: Text("Permiso"),
                                                  ),
                                                ],
                                                rows: list
                                                    .map((e) => DataRow(
                                                            selected: selectedPermisos
                                                                .any((element) =>
                                                                    element
                                                                        .id ==
                                                                    e.id),
                                                            onSelectChanged:
                                                                (isSelected) =>
                                                                    setState(
                                                                        () {
                                                                      final isAdding =
                                                                          isSelected != null &&
                                                                              isSelected;
                                                                      if (!isSelect) {
                                                                        isAdding
                                                                            ? selectedPermisos.add(
                                                                                e)
                                                                            : selectedPermisos.removeWhere((element) =>
                                                                                element.id ==
                                                                                e.id);
                                                                      }
                                                                    }),
                                                            cells: [
                                                              DataCell(
                                                                Text(
                                                                  e.descripcion,
                                                                ),
                                                                onTap: null,
                                                              ),
                                                            ]))
                                                    .toList())
                                          ],
                                          size,
                                          () async {
                                            ProgressDialog.show(context);
                                            var resp = await _rolesApi
                                                .updatePermisoRol(
                                                    rol.id, selectedPermisos);
                                            if (resp
                                                is Success<RolPOSTResponse>) {
                                              ProgressDialog.dissmiss(context);
                                              Dialogs.success(
                                                  msg: "Actualizado con exito");
                                              _navigationService.pop();
                                            } else if (resp is Failure) {
                                              ProgressDialog.dissmiss(context);
                                              Dialogs.error(
                                                  msg: resp.messages.first);
                                            }
                                          },
                                          () {
                                            Dialogs.confirm(context,
                                                tittle: "Eliminar Permiso",
                                                description:
                                                    "Esta seguro que desea eliminar el permiso?",
                                                confirm: () async {
                                              ProgressDialog.show(context);
                                              var resp = await _rolesApi
                                                  .deletePermisosRol(
                                                      rol.id, selectedPermisos);
                                              if (resp
                                                  is Success<RolPOSTResponse>) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                Dialogs.success(
                                                    msg: "Eliminado con exito");
                                                _navigationService.pop();
                                                notifyListeners();
                                              } else if (resp is Failure) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                Dialogs.error(
                                                    msg: resp.messages.first);
                                              }
                                            });
                                          },
                                          buscador(
                                            text: 'Buscar permisos...',
                                            onChanged: (value) {
                                              setState(() {
                                                list = [];
                                                for (var element
                                                    in resp2.response.data) {
                                                  if (element.descripcion
                                                      .toLowerCase()
                                                      .contains(value
                                                          .toLowerCase())) {
                                                    list.add(RolClaimsData(
                                                        id: element.id,
                                                        descripcion: element
                                                            .descripcion));
                                                  }
                                                }
                                                list.sort((a, b) {
                                                  return a.descripcion
                                                      .toLowerCase()
                                                      .compareTo(b.descripcion
                                                          .toLowerCase());
                                                });
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                });
                          } else if (resp2 is Failure) {
                            ProgressDialog.dissmiss(context);
                            Dialogs.error(msg: resp2.messages.first);
                          }
                        } else if (resp is Failure) {
                          ProgressDialog.dissmiss(context);
                          Dialogs.error(msg: resp.messages.first);
                        }
                      },
                      buttonTittle: buttonTittle,
                      tiposRoles: resp.response.data),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ));
          });
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages.first);
    }
  }

  Future<void> crearRol(BuildContext context, Size size) async {
    final _rolesApi = locator<RolesAPI>();
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear rol";
    bool validator = true;
    String buttonTittle = "Crear";
    ProgressDialog.show(context);
    var resp = await _rolesApi.getTiposRoles();
    if (resp is Success<RolTipeResponse>) {
      ProgressDialog.dissmiss(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: ActualizarRolForm(
                  rol: RolData(
                      description: "",
                      id: "",
                      name: "",
                      typeRole: 0,
                      typeRoleDescription: ""),
                  showEliminar: false,
                  formKey: _formKey,
                  size: size,
                  titulo: titulo,
                  validator: validator,
                  modificar: (nombref, descripcionf, tipoRol) async {
                    ProgressDialog.show(context);
                    var resp = await _rolesApi.createRoles(
                        nombref, descripcionf, tipoRol["id"]);
                    if (resp is Success<RolPOSTResponse>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Creacion de rol exitosa");
                      _navigationService.pop();
                      onInit();
                    } else if (resp is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: resp.messages.first);
                    }
                  },
                  eliminar: () {},
                  changePermisos: () {},
                  buttonTittle: buttonTittle,
                  tiposRoles: resp.response.data),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            );
          });
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages.first);
    }
  }

  @override
  void dispose() {
    listController.dispose();
    super.dispose();
  }
}
