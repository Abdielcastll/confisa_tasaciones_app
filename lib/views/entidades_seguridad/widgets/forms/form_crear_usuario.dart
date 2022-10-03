import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/api/usuarios_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/core/models/seguridad_entidades_generales/suplidores_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../../core/authentication_client.dart';
import '../../../../core/services/navigator_service.dart';

Future<dynamic> dialogCrearUsuario(
    String titulo,
    Size size,
    BuildContext context,
    GlobalKey<FormState> _formKey,
    List<RolData> roles,
    String nombreCompleto,
    String telefono,
    String email,
    bool validator,
    Function modificar,
    var dropdown,
    String buttonTittle,
    Map<String, dynamic> rol1,
    Map<String, dynamic> suplidor) {
  List<Widget> permisoRol = [];
  rol1['id'] = "";
  rol1["nombre"] = "";
  rol1["description"] = "";
  rol1["typeRolDescription"] = "";
  suplidor['codigoRelacional'] = 0;
  suplidor["nombre"] = "";
  suplidor["identificacion"] = "";
  int noTasador = 0;
  int codSuplidor = 0;
  final _usuariosApi = locator<UsuariosAPI>();
  final _suplidoresApi = locator<SuplidoresApi>();
  final user = locator<AuthenticationClient>().loadSession;
  final usuario = locator<UserClient>().loadProfile;
  final _navigationService = locator<NavigatorService>();
  List<SuplidorData> suplidores = [];
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        codSuplidor = usuario.idSuplidor ?? 0;
        return StatefulBuilder(builder: ((BuildContext context, setState) {
          return AlertDialog(
            content: SizedBox(
              width: size.width * .75,
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          child: Text(titulo,
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  children: [
                                    DropdownSearch<String>(
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                labelText: "Rol",
                                                border: UnderlineInputBorder()),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                      items: roles.map((e) => e.name).toList(),
                                      enabled: true,
                                      popupProps: const PopupProps.menu(
                                          fit: FlexFit.loose,
                                          showSelectedItems: true,
                                          searchDelay:
                                              Duration(microseconds: 0)),
                                      onChanged: (value) async {
                                        setState(
                                          () => permisoRol = [],
                                        );

                                        dropdown = value;

                                        rol1['nombre'] = value;
                                        rol1["id"] = roles
                                            .firstWhere((element) =>
                                                element.name == value)
                                            .id;
                                        rol1["description"] = roles
                                            .firstWhere((element) =>
                                                element.name == value)
                                            .description;
                                        rol1["typeRolDescription"] = roles
                                            .firstWhere((element) =>
                                                element.name == value)
                                            .typeRoleDescription;
                                        if (rol1["typeRolDescription"] ==
                                            "Externo") {
                                          for (var element in user.role) {
                                            if (element ==
                                                "Aprobador Tasaciones") {
                                              ProgressDialog.show(context);
                                              var resp = await _usuariosApi
                                                  .getUsuarios(
                                                      email: user.email);
                                              if (resp is Success<
                                                  UsuariosResponse>) {
                                                codSuplidor = resp.response.data
                                                    .first.idSuplidor;
                                                ProgressDialog.dissmiss(
                                                    context);
                                                permisoRol.add(
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                );
                                                permisoRol.add(
                                                  Text(
                                                      "Suplidor ${resp.response.data.first.nombreSuplidor}",
                                                      style: appDropdown),
                                                );
                                              } else if (resp is Failure) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                Dialogs.error(
                                                    msg: resp.messages[0]);
                                              }
                                            }
                                            if (codSuplidor == 0) {
                                              ProgressDialog.show(context);
                                              var resp = await _suplidoresApi
                                                  .getSuplidores();
                                              if (resp is Success<
                                                  SuplidoresResponse>) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                suplidores = resp.response.data;
                                                setState((() {
                                                  permisoRol = [
                                                    TextFormField(
                                                      decoration: const InputDecoration(
                                                          labelText:
                                                              'Nombre Completo',
                                                          border:
                                                              UnderlineInputBorder()),
                                                      onSaved: (value) {
                                                        nombreCompleto = value!;
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty ||
                                                            value.length < 8) {
                                                          return 'Debe ingresar un nombre válido';
                                                        }

                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Teléfono',
                                                              border:
                                                                  UnderlineInputBorder()),
                                                      onSaved: (value) {
                                                        telefono = value!;
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty ||
                                                            value.length < 9) {
                                                          return 'Debe ingresar un teléfono válido';
                                                        }

                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Email',
                                                              border:
                                                                  UnderlineInputBorder()),
                                                      onSaved: (value) {
                                                        email = value!;
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty ||
                                                            value.length < 8 ||
                                                            !EmailValidator
                                                                .validate(
                                                                    value,
                                                                    true,
                                                                    true)) {
                                                          return 'Debe ingresar un email valido';
                                                        }

                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    rol1["description"] ==
                                                            "Tasador"
                                                        ? TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration: const InputDecoration(
                                                                label: Text(
                                                                    "No Tasador"),
                                                                border:
                                                                    UnderlineInputBorder()),
                                                            onSaved: (value) {
                                                              value != ""
                                                                  ? noTasador =
                                                                      int.parse(
                                                                          value!)
                                                                  : noTasador =
                                                                      0;
                                                            },
                                                            validator: (value) {
                                                              if (rol1[
                                                                      "description"] ==
                                                                  "Tasador") {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty ||
                                                                    value.length <
                                                                        4) {
                                                                  return 'Debe ingresar un No tasador válido';
                                                                }
                                                              }
                                                              return null;
                                                            },
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    rol1["description"] ==
                                                            "Tasador"
                                                        ? const SizedBox(
                                                            height: 10,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    codSuplidor == 0
                                                        ? DropdownSearch<
                                                            String>(
                                                            validator: (value) =>
                                                                value == null
                                                                    ? 'Debe escojer un suplidor'
                                                                    : null,
                                                            dropdownDecoratorProps:
                                                                const DropDownDecoratorProps(
                                                                    dropdownSearchDecoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          "Suplidor",
                                                                    ),
                                                                    textAlignVertical:
                                                                        TextAlignVertical
                                                                            .center),
                                                            items: suplidores
                                                                .map((e) =>
                                                                    e.nombre)
                                                                .toList(),
                                                            popupProps: const PopupProps
                                                                    .menu(
                                                                fit: FlexFit
                                                                    .loose,
                                                                showSelectedItems:
                                                                    true,
                                                                searchDelay:
                                                                    Duration(
                                                                        microseconds:
                                                                            0)),
                                                            onChanged: (value) {
                                                              dropdown = value;
                                                              suplidor[
                                                                      'nombre'] =
                                                                  value;
                                                              suplidor["codigoRelacional"] = suplidores
                                                                  .firstWhere(
                                                                      (element) =>
                                                                          element
                                                                              .nombre ==
                                                                          value)
                                                                  .codigoRelacionado;

                                                              suplidor["identificacion"] = suplidores
                                                                  .firstWhere(
                                                                      (element) =>
                                                                          element
                                                                              .nombre ==
                                                                          value)
                                                                  .identificacion;
                                                            },
                                                          )
                                                        : Container(),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            _navigationService
                                                                .pop();
                                                          },
                                                          // button pressed
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                AppIcons
                                                                    .closeCircle,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ), // icon
                                                              Text(
                                                                  "Cancelar"), // text
                                                            ],
                                                          ),
                                                        ),
                                                        TextButton(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                AppIcons.save,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ), // icon
                                                              Text(
                                                                  "Crear"), // text
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            // Validate returns true if the form is valid, or false otherwise.
                                                            _formKey
                                                                .currentState
                                                                ?.save();
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              _formKey
                                                                  .currentState
                                                                  ?.save();
                                                              modificar(
                                                                  nombreCompleto,
                                                                  email,
                                                                  telefono,
                                                                  codSuplidor,
                                                                  noTasador);
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ];
                                                }));
                                              } else if (resp is Failure) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                Dialogs.error(
                                                    msg: resp.messages[0]);
                                              }
                                            } else if (user.role.any(
                                                (element) =>
                                                    element ==
                                                    "AprobadorTasaciones")) {
                                              ProgressDialog.show(context);
                                              var resp = await _suplidoresApi
                                                  .getSuplidoresPorId(
                                                      codigoRelacionado:
                                                          codSuplidor);
                                              if (resp is Success<
                                                  SuplidoresResponse>) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                suplidores = resp.response.data;
                                                setState((() {
                                                  permisoRol = [
                                                    TextFormField(
                                                      decoration: const InputDecoration(
                                                          labelText:
                                                              'Nombre Completo',
                                                          border:
                                                              UnderlineInputBorder()),
                                                      onSaved: (value) {
                                                        nombreCompleto = value!;
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty ||
                                                            value.length < 8) {
                                                          return 'Debe ingresar un nombre válido';
                                                        }

                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Teléfono',
                                                              border:
                                                                  UnderlineInputBorder()),
                                                      onSaved: (value) {
                                                        telefono = value!;
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty ||
                                                            value.length < 10) {
                                                          return 'Debe ingresar un teléfono válido';
                                                        }

                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Email',
                                                              border:
                                                                  UnderlineInputBorder()),
                                                      onSaved: (value) {
                                                        email = value!;
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty ||
                                                            value.length < 8 ||
                                                            !EmailValidator
                                                                .validate(
                                                                    value,
                                                                    true,
                                                                    true)) {
                                                          return 'Debe ingresar un email valido';
                                                        }

                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    rol1["description"] ==
                                                            "Tasador"
                                                        ? TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration: const InputDecoration(
                                                                label: Text(
                                                                    "No Tasador"),
                                                                border:
                                                                    UnderlineInputBorder()),
                                                            onSaved: (value) {
                                                              value != ""
                                                                  ? noTasador =
                                                                      int.parse(
                                                                          value!)
                                                                  : noTasador =
                                                                      0;
                                                            },
                                                            validator: (value) {
                                                              if (rol1[
                                                                      "description"] ==
                                                                  "Tasador") {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty ||
                                                                    value.length <
                                                                        4) {
                                                                  return 'Debe ingresar un No tasador válido';
                                                                }
                                                              }
                                                              return null;
                                                            },
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    rol1["description"] ==
                                                            "Tasador"
                                                        ? const SizedBox(
                                                            height: 10,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    TextFormField(
                                                      readOnly: true,
                                                      onChanged: (value) {
                                                        dropdown = value;
                                                        suplidor['nombre'] =
                                                            value;
                                                        suplidor[
                                                                "codigoRelacional"] =
                                                            suplidores
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .nombre ==
                                                                        value)
                                                                .codigoRelacionado;

                                                        suplidor[
                                                                "identificacion"] =
                                                            suplidores
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .nombre ==
                                                                        value)
                                                                .identificacion;
                                                      },
                                                      initialValue: suplidores
                                                          .first.nombre,
                                                      decoration:
                                                          const InputDecoration(
                                                              label: Text(
                                                                  "Suplidor"),
                                                              border:
                                                                  UnderlineInputBorder()),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'No posee un suplidor';
                                                        }

                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            _navigationService
                                                                .pop();
                                                          },
                                                          // button pressed
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                AppIcons
                                                                    .closeCircle,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ), // icon
                                                              Text(
                                                                  "Cancelar"), // text
                                                            ],
                                                          ),
                                                        ),
                                                        TextButton(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                AppIcons.save,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ), // icon
                                                              Text(
                                                                  "Crear"), // text
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            // Validate returns true if the form is valid, or false otherwise.
                                                            _formKey
                                                                .currentState
                                                                ?.save();
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              _formKey
                                                                  .currentState
                                                                  ?.save();
                                                              modificar(
                                                                  nombreCompleto,
                                                                  email,
                                                                  telefono,
                                                                  codSuplidor,
                                                                  noTasador);
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ];
                                                }));
                                              } else if (resp is Failure) {
                                                ProgressDialog.dissmiss(
                                                    context);
                                                Dialogs.error(
                                                    msg: resp.messages[0]);
                                              }
                                            }
                                          }
                                        } else if (rol1["typeRolDescription"] ==
                                            "Interno") {
                                          permisoRol = [
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                  labelText: 'Email',
                                                  border:
                                                      UnderlineInputBorder()),
                                              onSaved: (value) {
                                                email = value!;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    value.length < 8 ||
                                                    !EmailValidator.validate(
                                                        value, true, true)) {
                                                  return 'Debe ingresar un email válido';
                                                }

                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
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
                                                        MainAxisAlignment
                                                            .center,
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
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const <Widget>[
                                                      Icon(
                                                        AppIcons.search,
                                                        color: AppColors.green,
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ), // icon
                                                      Text("Buscar"), // text
                                                    ],
                                                  ),
                                                  onPressed: () async {
                                                    // Validate returns true if the form is valid, or false otherwise.
                                                    _formKey.currentState
                                                        ?.save();
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _formKey.currentState
                                                          ?.save();
                                                      ProgressDialog.show(
                                                          context);
                                                      var resp =
                                                          await _usuariosApi
                                                              .getUsuarioDomain(
                                                                  email: email);
                                                      if (resp is Success<
                                                          UsuarioDomainData>) {
                                                        ProgressDialog.dissmiss(
                                                            context);
                                                        setState((() {
                                                          permisoRol = [
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            TextFormField(
                                                              enabled: false,
                                                              initialValue: resp
                                                                  .response
                                                                  .nombreCompleto,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    UnderlineInputBorder(),
                                                                isDense: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                label: Text(
                                                                    'Nombre'),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            TextFormField(
                                                              enabled: false,
                                                              initialValue: resp
                                                                  .response
                                                                  .email,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    UnderlineInputBorder(),
                                                                isDense: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                label: Text(
                                                                    'Email'),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            TextFormField(
                                                              enabled: false,
                                                              initialValue: resp
                                                                  .response
                                                                  .puesto,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    UnderlineInputBorder(),
                                                                isDense: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                label: Text(
                                                                    'Puesto'),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            TextFormField(
                                                              enabled: false,
                                                              initialValue: resp
                                                                  .response
                                                                  .telefono,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    UnderlineInputBorder(),
                                                                isDense: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                label: Text(
                                                                    'Teléfono'),
                                                              ),
                                                            ),
                                                            Container(),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    _navigationService
                                                                        .pop();
                                                                  },
                                                                  // button pressed
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: const <
                                                                        Widget>[
                                                                      Icon(
                                                                        AppIcons
                                                                            .closeCircle,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            3,
                                                                      ), // icon
                                                                      Text(
                                                                          "Cancelar"), // text
                                                                    ],
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: const <
                                                                        Widget>[
                                                                      Icon(
                                                                        AppIcons
                                                                            .save,
                                                                        color: AppColors
                                                                            .green,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            3,
                                                                      ), // icon
                                                                      Text(
                                                                          "Crear"), // text
                                                                    ],
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    // Validate returns true if the form is valid, or false otherwise.
                                                                    _formKey
                                                                        .currentState
                                                                        ?.save();
                                                                    if (_formKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      _formKey
                                                                          .currentState
                                                                          ?.save();
                                                                      modificar(
                                                                          resp.response
                                                                              .nombreCompleto,
                                                                          resp.response
                                                                              .email,
                                                                          resp.response
                                                                              .telefono,
                                                                          codSuplidor,
                                                                          noTasador);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ];
                                                        }));
                                                      } else if (resp
                                                          is Failure) {
                                                        ProgressDialog.dissmiss(
                                                            context);
                                                        Dialogs.error(
                                                            msg: resp
                                                                .messages[0]);
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ];
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ...permisoRol,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.zero,
          );
        }));
      });
}
