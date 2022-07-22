import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/api/permisos_api.dart';
import '../../../core/api/roles_api.dart';
import '../../../core/api/recursos_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/acciones_response.dart';
import '../../../core/models/permisos_response.dart';
import '../../../core/models/recursos_response.dart';
import '../../../core/models/roles_claims_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/app_circle_icon_button.dart';
import '../widgets/dialog_mostrar_informacion_permisos.dart';
import '../widgets/dialog_mostrar_informacion_roles.dart';
import '../widgets/forms/form_actualizar_rol.dart';
import '../widgets/forms/form_crear_permiso.dart';

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

  Future<void> onInit() async {
    cargando = true;
    roles = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp = await _rolesApi.getRoles(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      rolesResponse = resp.response as RolResponse;
      roles = rolesResponse.data;
      hasNextPage = rolesResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasRoles() async {
    pageNumber += 1;
    var resp = await _rolesApi.getRoles(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      var temp = resp.response as RolResponse;
      roles.addAll(temp.data);
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

  Future<void> modificarRol(
      RolData rol, BuildContext context, Size size) async {
    String titulo = "Actualizar Rol";
    final GlobalKey<FormState> _formKey = GlobalKey();
    const String buttonTittle = "Modificar";
    String nombre = "";
    String descripcion = "";
    bool validator = true;
    List<Widget> informacion = [];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: ActualizarRolForm(
                  rol: rol,
                  showEliminar: true,
                  formKey: _formKey,
                  size: size,
                  titulo: titulo,
                  validator: validator,
                  modificar: (nombref, descripcionf) async {
                    ProgressDialog.show(context);
                    var resp = await _rolesApi.updateRol(
                        rol.id, nombref, descripcionf);
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
                        description: "Esta seguro que desea eliminar el rol?",
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
                    ProgressDialog.show(context);
                    var resp = await _rolesApi.getRolesClaims(idRol: rol.id);
                    if (resp is Success<RolClaimsResponse>) {
                      bool isSelect = false;
                      ProgressDialog.dissmiss(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            List<RolClaimsData> selectedPermisos = [];
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: EdgeInsets.zero,
                                content: dialogMostrarInformacionRoles(
                                    Container(
                                      height: size.height * .08,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        color: AppColors.gold,
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text("Permisos de ${rol.name}",
                                            style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    [
                                      DataTable(
                                          onSelectAll: (isSelectedAll) {
                                            setState(() => {
                                                  selectedPermisos =
                                                      isSelectedAll!
                                                          ? resp.response.data
                                                          : [],
                                                  isSelect = isSelectedAll
                                                });
                                          },
                                          columns: [
                                            DataColumn(
                                                label: Row(
                                              children: [
                                                const Text("Permiso"),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                CircleIconButton(
                                                    color: AppColors.green,
                                                    icon: Icons.add,
                                                    onPressed: () async {
                                                      ProgressDialog.show(
                                                          context);
                                                      var respPermisos =
                                                          await _permisosApi
                                                              .getPermisos(
                                                                  pageSize:
                                                                      1000);
                                                      if (respPermisos is Success<
                                                          PermisosResponse>) {
                                                        ProgressDialog.dissmiss(
                                                            context);
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              List<PermisosData>
                                                                  selectedPermisos2 =
                                                                  [];
                                                              return StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                return AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  content:
                                                                      dialogMostrarInformacionPermisos(
                                                                          Container(
                                                                            height:
                                                                                size.height * .08,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                              color: AppColors.gold,
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Row(
                                                                                children: [
                                                                                  const SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  const Text("Permisos", style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                  const SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  CircleIconButton(
                                                                                      color: AppColors.green,
                                                                                      icon: Icons.add,
                                                                                      onPressed: () async {
                                                                                        if (selectedPermisos2.isNotEmpty) {
                                                                                          ProgressDialog.show(context);
                                                                                          var respAsignacion = await _rolesApi.assingPermisosRol(rol.id, selectedPermisos2);
                                                                                          if (respAsignacion is Success<RolPOSTResponse>) {
                                                                                            ProgressDialog.dissmiss(context);
                                                                                            Dialogs.success(msg: "Asignacion exitosa");
                                                                                            ProgressDialog.dissmiss(context);
                                                                                            ProgressDialog.dissmiss(context);
                                                                                            notifyListeners();
                                                                                          } else {
                                                                                            if (respAsignacion is Failure) {
                                                                                              ProgressDialog.dissmiss(context);
                                                                                              Dialogs.error(msg: respAsignacion.messages.first);
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      })
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          [
                                                                            DataTable(
                                                                                onSelectAll: (isSelectedAll) {
                                                                                  setState(() => {
                                                                                        selectedPermisos2 = isSelectedAll! ? respPermisos.response.data : [],
                                                                                        isSelect = isSelectedAll
                                                                                      });
                                                                                },
                                                                                columns: const [
                                                                                  DataColumn(
                                                                                    label: Text("Permiso"),
                                                                                  ),
                                                                                ],
                                                                                rows: respPermisos.response.data
                                                                                    .map((e) => DataRow(
                                                                                            selected: selectedPermisos2.contains(e),
                                                                                            onSelectChanged: (isSelected) => setState(() {
                                                                                                  final isAdding = isSelected != null && isSelected;
                                                                                                  if (!isSelect) {
                                                                                                    isAdding ? selectedPermisos2.add(e) : selectedPermisos2.remove(e);
                                                                                                  }
                                                                                                }),
                                                                                            cells: [
                                                                                              DataCell(
                                                                                                Text(
                                                                                                  e.descripcion,
                                                                                                ),
                                                                                              ),
                                                                                            ]))
                                                                                    .toList())
                                                                          ],
                                                                          size),
                                                                );
                                                              });
                                                            });
                                                      } else if (respPermisos
                                                          is Failure) {
                                                        ProgressDialog.dissmiss(
                                                            context);
                                                        Dialogs.error(
                                                            msg: respPermisos
                                                                .messages
                                                                .first);
                                                      }
                                                    })
                                              ],
                                            )),
                                          ],
                                          rows: resp.response.data
                                              .map((e) => DataRow(
                                                      selected: selectedPermisos
                                                          .contains(e),
                                                      onSelectChanged:
                                                          (isSelected) =>
                                                              setState(() {
                                                                final isAdding =
                                                                    isSelected !=
                                                                            null &&
                                                                        isSelected;
                                                                if (!isSelect) {
                                                                  isAdding
                                                                      ? selectedPermisos
                                                                          .add(
                                                                              e)
                                                                      : selectedPermisos
                                                                          .remove(
                                                                              e);
                                                                }
                                                              }),
                                                      cells: [
                                                        DataCell(
                                                          Text(
                                                            e.descripcion,
                                                          ),
                                                          onTap: () {},
                                                        ),
                                                      ]))
                                              .toList())
                                    ],
                                    size, () async {
                                  ProgressDialog.show(context);
                                  var resp = await _rolesApi.updatePermisoRol(
                                      rol.id, selectedPermisos);
                                  if (resp is Success<RolPOSTResponse>) {
                                    ProgressDialog.dissmiss(context);
                                    Dialogs.success(
                                        msg: "Actualizado con exito");
                                    _navigationService.pop();
                                  } else if (resp is Failure) {
                                    ProgressDialog.dissmiss(context);
                                    Dialogs.error(msg: resp.messages.first);
                                  }
                                }, () {
                                  Dialogs.confirm(context,
                                      tittle: "Eliminar Permiso",
                                      description:
                                          "Esta seguro que desea eliminar el permiso?",
                                      confirm: () async {
                                    ProgressDialog.show(context);
                                    var resp =
                                        await _rolesApi.deletePermisosRol(
                                            rol.id, selectedPermisos);
                                    if (resp is Success<RolPOSTResponse>) {
                                      ProgressDialog.dissmiss(context);
                                      Dialogs.success(
                                          msg: "Eliminado con exito");
                                      _navigationService.pop();
                                      notifyListeners();
                                    } else if (resp is Failure) {
                                      ProgressDialog.dissmiss(context);
                                      Dialogs.error(msg: resp.messages.first);
                                    }
                                  });
                                }),
                              );
                            });
                          });
                    } else if (resp is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: resp.messages.first);
                    }
                  },
                  descripcion: descripcion,
                  buttonTittle: buttonTittle,
                  nombre: nombre),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ));
        });
  }

  Future<void> crearRol(BuildContext context, Size size) async {
    final _rolesApi = locator<RolesAPI>();
    String descripcion = "";
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear rol";
    bool validator = true;
    String buttonTittle = "Crear";
    String nombre = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: ActualizarRolForm(
                rol: RolData(description: "", id: "", name: ""),
                showEliminar: false,
                formKey: _formKey,
                size: size,
                titulo: titulo,
                validator: validator,
                modificar: (nombref, descripcionf) async {
                  ProgressDialog.show(context);
                  var resp = await _rolesApi.createRoles(nombref, descripcionf);
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
                descripcion: descripcion,
                buttonTittle: buttonTittle,
                nombre: nombre),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        });
  }

  @override
  void dispose() {
    listController.dispose();
    super.dispose();
  }
}
