import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/consultar_modificar_view_model.dart';

import '../../../../../core/models/tracciones_response.dart';
import '../../../../../theme/theme.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';

class VehiculoForm extends StatelessWidget {
  const VehiculoForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final ConsultarModificarViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Vehículo',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () {
        vm.currentForm = 1;
        vm.vinData = null;
      },
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () {
        vm.cargarAlarmas(vm.solicitud.id!);
        vm.goToFotos(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Form(
                    key: vm.formKey2,
                    child: BaseTextField(
                      label: 'No. VIN',
                      hint: 'Ingrese el número VIN del vehículo',
                      controller: vm.tcVIN,
                    ),
                  ),
                ),
                // IconButton(
                //   iconSize: 50,
                //   onPressed: () => vm.consultarVIN(context),
                //   icon: const CircleAvatar(
                //     child: Icon(
                //       Icons.search,
                //       color: AppColors.white,
                //     ),
                //     backgroundColor: AppColors.brownDark,
                //   ),
                // ),
                // IconButton(
                //   iconSize: 50,
                //   onPressed: () async => await vm.escanearVIN(),
                //   icon: const CircleAvatar(
                //     child: Icon(
                //       Icons.qr_code,
                //       color: AppColors.white,
                //     ),
                //     backgroundColor: AppColors.brownDark,
                //   ),
                // ),
              ],
            ),
            Form(
              key: vm.formKey3,
              child: Column(
                children: [
                  BaseTextFieldNoEdit(
                    label: 'Marca',
                    initialValue: vm.solicitud.descripcionMarca ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Modelo',
                    initialValue: vm.solicitud.descripcionModelo ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Año',
                    initialValue: vm.solicitud.ano.toString(),
                  ),
                  // if (vm.vinData != null)
                  Column(
                    children: [
                      // TIPO DE VEHICULO

                      vm.vinData?.tipoVehiculo != null
                          ? BaseTextFieldNoEdit(
                              label: 'Tipo',
                              initialValue: vm.vinData?.tipoVehiculo ?? '',
                            )
                          : vm.solicitudCola.estadoTasacion != 9
                              ? BaseTextFieldNoEdit(
                                  label: 'Tipo',
                                  initialValue: vm.solicitudCola
                                          .descripcionTipoVehiculoLocal ??
                                      '',
                                )
                              : DropdownSearch<TipoVehiculoData>(
                                  asyncItems: (text) =>
                                      vm.getTipoVehiculo(text),
                                  dropdownBuilder: (context, tipo) {
                                    return Text(
                                      tipo == null
                                          ? vm.solicitudCola
                                                  .descripcionTipoVehiculoLocal ??
                                              'Seleccione'
                                          : tipo.descripcion,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    );
                                  },
                                  onChanged: (v) => vm.tipoVehiculo = v,
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label: Text('Tipo'),
                                                  border:
                                                      UnderlineInputBorder())),
                                  popupProps: PopupProps.menu(
                                    itemBuilder: (context, otp, isSelected) {
                                      return ListTile(
                                        title: Text(otp.descripcion),
                                        selected: isSelected,
                                      );
                                    },
                                    emptyBuilder: (_, __) => const Center(
                                      child: Text('No hay resultados'),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null) {
                                      return 'Seleccione un tipo';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                      const SizedBox(height: 10),

                      // SISTEMA DE TRANSMISIÓN

                      vm.vinData?.sistemaCambio != null
                          ? BaseTextFieldNoEdit(
                              label: 'Sistema de cambio',
                              initialValue: vm.vinData?.sistemaCambio,
                            )
                          : vm.solicitudCola.estadoTasacion != 9
                              ? BaseTextFieldNoEdit(
                                  label: 'Sistema de cambio',
                                  initialValue: vm.solicitudCola
                                          .descripcionSistemaTransmision ??
                                      '',
                                )
                              : DropdownSearch<TransmisionesData>(
                                  asyncItems: (text) =>
                                      vm.getTransmisiones(text),
                                  dropdownBuilder: (context, tipo) {
                                    return Text(
                                        tipo == null
                                            ? vm.solicitudCola
                                                    .descripcionSistemaTransmision ??
                                                'Seleccione'
                                            : tipo.descripcion,
                                        style: const TextStyle(fontSize: 15));
                                  },
                                  onChanged: (v) => vm.transmision = v,
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label: Text(
                                                      'Sistema de cambios'),
                                                  border:
                                                      UnderlineInputBorder())),
                                  popupProps: PopupProps.menu(
                                    itemBuilder: (context, otp, isSelected) {
                                      return ListTile(
                                        title: Text(otp.descripcion),
                                        selected: isSelected,
                                      );
                                    },
                                    emptyBuilder: (_, __) => const Center(
                                      child: Text('No hay resultados'),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null) {
                                      return 'Seleccione un sistema de cambios';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                      const SizedBox(height: 10),

                      // SISTEMA DE TRACCION

                      vm.vinData?.traccion != null
                          ? BaseTextFieldNoEdit(
                              label: 'Tracción',
                              initialValue: vm.vinData?.traccion,
                            )
                          : vm.solicitudCola.estadoTasacion != 9
                              ? BaseTextFieldNoEdit(
                                  label: 'Tracción',
                                  initialValue:
                                      vm.solicitudCola.descripcionTraccion ??
                                          '',
                                )
                              : DropdownSearch<TraccionesData>(
                                  asyncItems: (text) => vm.getTracciones(text),
                                  dropdownBuilder: (context, tipo) {
                                    return Text(
                                        tipo == null
                                            ? vm.solicitudCola
                                                    .descripcionTraccion ??
                                                'Seleccione'
                                            : tipo.descripcion,
                                        style: const TextStyle(fontSize: 15));
                                  },
                                  onChanged: (v) => vm.traccion = v,
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label: Text('Tracción'),
                                                  border:
                                                      UnderlineInputBorder())),
                                  popupProps: PopupProps.menu(
                                    itemBuilder: (context, otp, isSelected) {
                                      return ListTile(
                                        title: Text(otp.descripcion),
                                        subtitle: Text(otp.descripcion2 ?? ''),
                                        selected: isSelected,
                                      );
                                    },
                                    emptyBuilder: (_, __) => const Center(
                                      child: Text('No hay resultados'),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null) {
                                      return 'Seleccione una tracción';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                      const SizedBox(height: 10),

                      // Numero de puertas

                      vm.vinData?.numeroPuertas != null
                          ? BaseTextFieldNoEdit(
                              label: 'No. de puertas',
                              initialValue: vm.vinData?.numeroPuertas,
                            )
                          : vm.solicitudCola.estadoTasacion != 9
                              ? BaseTextFieldNoEdit(
                                  label: 'No. de puertas',
                                  initialValue:
                                      vm.solicitudCola.noPuertas.toString(),
                                )
                              : DropdownSearch<int>(
                                  items: const [2, 3, 4, 5],
                                  dropdownBuilder: (context, nPuertas) {
                                    return Text(
                                        nPuertas == null
                                            ? vm.solicitudCola.noPuertas
                                                .toString()
                                            : nPuertas.toString(),
                                        style: const TextStyle(fontSize: 15));
                                  },
                                  onChanged: (v) => vm.nPuertas = v,
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label: Text('No. de puertas'),
                                                  border:
                                                      UnderlineInputBorder())),
                                  popupProps: PopupProps.menu(
                                    itemBuilder: (context, otp, isSelected) {
                                      return ListTile(
                                        title: Text(otp.toString()),
                                        selected: isSelected,
                                      );
                                    },
                                    emptyBuilder: (_, __) => const Center(
                                      child: Text('No hay resultados'),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null) {
                                      return 'Seleccione número de puertas';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                      const SizedBox(height: 10),

                      // Numero de cilindros

                      vm.vinData?.numeroCilindros != null
                          ? BaseTextFieldNoEdit(
                              label: 'No. de cilindros',
                              initialValue: vm.vinData?.numeroCilindros,
                            )
                          : vm.solicitudCola.estadoTasacion != 9
                              ? BaseTextFieldNoEdit(
                                  label: 'No. de cilindros',
                                  initialValue:
                                      vm.solicitudCola.noCilindros.toString(),
                                )
                              : DropdownSearch<int>(
                                  // asyncItems: (text) => vm.getTracciones(text),
                                  items: const [3, 4, 5, 6, 8, 10, 12],
                                  dropdownBuilder: (context, nCilindros) {
                                    return Text(
                                        nCilindros == null
                                            ? vm.solicitudCola.noCilindros
                                                .toString()
                                            : nCilindros.toString(),
                                        style: const TextStyle(fontSize: 15));
                                  },
                                  onChanged: (v) => vm.nCilindros = v,
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label:
                                                      Text('No. de cilindros'),
                                                  border:
                                                      UnderlineInputBorder())),
                                  popupProps: PopupProps.menu(
                                    itemBuilder:
                                        (context, nCilindros, isSelected) {
                                      return ListTile(
                                        title: Text(nCilindros.toString()),
                                        selected: isSelected,
                                      );
                                    },
                                    emptyBuilder: (_, __) => const Center(
                                      child: Text('No hay resultados'),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null) {
                                      return 'Seleccione número de cilindros';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                      // Fuerza Motriz
                      vm.solicitudCola.estadoTasacion != 9
                          ? BaseTextFieldNoEdit(
                              label: 'Fuerza motriz',
                              initialValue:
                                  vm.solicitudCola.fuerzaMotriz.toString(),
                            )
                          : BaseTextField(
                              label: 'Fuerza motriz',
                              controller: vm.tcFuerzaMotriz,
                              validator: (v) {
                                if (v?.trim() == '') {
                                  return 'Escriba la fuerza motriz';
                                } else {
                                  return null;
                                }
                              }),
                      BaseTextFieldNoEdit(
                        label: 'Estado del vehículo',
                        initialValue: vm.solicitud.descripcionNuevoUsado ?? '',
                      ),
                      vm.solicitudCola.estadoTasacion != 9
                          ? BaseTextFieldNoEdit(
                              label: 'Kilometraje',
                              initialValue:
                                  vm.solicitudCola.kilometraje.toString(),
                            )
                          : BaseTextField(
                              label: 'Kilometraje',
                              keyboardType: TextInputType.number,
                              controller: vm.tcKilometraje,
                              validator: (v) {
                                if (v?.trim() == '') {
                                  return 'Escriba el Kilometraje';
                                } else {
                                  return null;
                                }
                              }),
                      const SizedBox(height: 10),
                      vm.solicitudCola.estadoTasacion != 9
                          ? BaseTextFieldNoEdit(
                              label: 'Color',
                              initialValue: vm.solicitudCola.descripcionColor,
                            )
                          : DropdownSearch<ColorVehiculo>(
                              asyncItems: (text) => vm.getColores(text),
                              dropdownBuilder: (context, tipo) {
                                return Text(
                                    tipo == null
                                        ? vm.solicitud.descripcionColor ??
                                            'Seleccione'
                                        : tipo.descripcion,
                                    style: const TextStyle(fontSize: 15));
                              },
                              onChanged: (v) => vm.colorVehiculo = v,
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          label: Text('Color'),
                                          border: UnderlineInputBorder())),
                              popupProps: PopupProps.menu(
                                itemBuilder: (context, otp, isSelected) {
                                  return ListTile(
                                    title: Text(otp.descripcion),
                                    selected: isSelected,
                                  );
                                },
                                // showSearchBox: true,

                                emptyBuilder: (_, __) => const Center(
                                  child: Text('No hay resultados'),
                                ),
                              ),
                              validator: (v) {
                                if (v == null) {
                                  return 'Seleccione un color';
                                } else {
                                  return null;
                                }
                              }),
                      vm.solicitudCola.estadoTasacion != 9
                          ? BaseTextFieldNoEdit(
                              label: 'Placa',
                              initialValue: vm.solicitudCola.placa,
                            )
                          : BaseTextField(
                              label: 'Placa',
                              controller: vm.tcPlaca,
                              validator: (v) {
                                if (v?.trim() == '') {
                                  return 'Escriba el número de placa';
                                } else {
                                  return null;
                                }
                              }),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
