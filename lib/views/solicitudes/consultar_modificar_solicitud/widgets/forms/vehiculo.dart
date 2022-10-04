import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/consultar_modificar_view_model.dart';

import '../../../../../core/models/ediciones_vehiculo_response.dart';
import '../../../../../core/models/tracciones_response.dart';
import '../../../../../core/models/versiones_vehiculo_response.dart';
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
        // vm.cargarAlarmas(vm.solicitud.id!);
        vm.mostrarAccComp ? vm.currentForm = 3 : vm.goToFotos(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            vm.solicitud.estadoTasacion != 34
                ? BaseTextFieldNoEdit(
                    label: 'No. VIN',
                    initialValue: vm.solicitud.chasis ?? 'No disponible',
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Form(
                          key: vm.formKey2,
                          child: BaseTextField(
                            label: 'No. VIN',
                            hint: 'Ingrese el número VIN del vehículo',
                            validator: vm.noVINValidator,
                            controller: vm.tcVIN,
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 50,
                        onPressed: () => vm.consultarVIN(context),
                        icon: const CircleAvatar(
                          child: Icon(
                            Icons.search,
                            color: AppColors.white,
                          ),
                          backgroundColor: AppColors.brownDark,
                        ),
                      ),
                      IconButton(
                        iconSize: 50,
                        onPressed: () async => await vm.escanearVIN(),
                        icon: const CircleAvatar(
                          child: Icon(
                            Icons.qr_code,
                            color: AppColors.white,
                          ),
                          backgroundColor: AppColors.brownDark,
                        ),
                      ),
                    ],
                  ),
            Form(
              key: vm.formKey3,
              child: Column(
                children: [
                  BaseTextFieldNoEdit(
                    label: 'Marca',
                    initialValue:
                        vm.solicitud.descripcionMarca ?? 'No disponible',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Modelo',
                    initialValue:
                        vm.solicitud.descripcionModelo ?? 'No disponible',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Año',
                    initialValue:
                        vm.solicitud.ano?.toString() ?? 'No disponible',
                  ),
                  if (vm.vinData?.serie != null)
                    BaseTextFieldNoEdit(
                      label: 'Serie',
                      initialValue: vm.vinData?.serie ?? 'No disponible',
                    ),
                  if (vm.vinData?.trim != null)
                    BaseTextFieldNoEdit(
                      label: 'Trim',
                      initialValue: vm.vinData?.trim ?? 'No disponible',
                    ),
                  // if (vm.vinData != null)
                  Column(
                    children: [
                      // VERSION VEHICULO
                      if (vm.solicitud.estadoTasacion == 34)
                        DropdownSearch<VersionVehiculoData>(
                          asyncItems: (text) => vm.getversionVehiculo(text),
                          dropdownBuilder: (context, tipo) {
                            return Text(
                              tipo == null
                                  ? vm.versionVehiculo?.descripcion ??
                                      'Seleccione'
                                  : tipo.descripcion,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );
                          },
                          onChanged: (v) => vm.versionVehiculo = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  label: Text('Versión'),
                                  border: UnderlineInputBorder())),
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
                          validator: vm.solicitud.estadoTasacion != 34
                              ? null
                              : (v) {
                                  if (v == null && vm.versionVehiculo == null) {
                                    return 'Seleccione una versión';
                                  } else {
                                    return null;
                                  }
                                },
                        ),
                      // const SizedBox(height: 10),
                      DropdownSearch<EdicionVehiculo>(
                        asyncItems: (text) => vm.getEdiciones(text),
                        enabled: vm.solicitud.estadoTasacion == 34,
                        dropdownBuilder: (context, tipo) {
                          return Text(
                            tipo == null
                                ? 'Seleccione'
                                : tipo.descripcionEasyBank ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          );
                        },
                        onChanged: (v) => vm.edicionVehiculo = v,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                label: Text('Edición'),
                                border: UnderlineInputBorder())),
                        popupProps: PopupProps.menu(
                          itemBuilder: (context, otp, isSelected) {
                            return ListTile(
                              title: Text(otp.descripcionEasyBank ?? ''),
                              selected: isSelected,
                            );
                          },
                          emptyBuilder: (_, __) => const Center(
                            child: Text('No hay resultados'),
                          ),
                        ),
                        // validator: (v) {
                        //   if (v == null) {
                        //     return 'Seleccione una edición';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                      // TIPO DE VEHICULO

                      BaseTextFieldNoEdit(
                        label: 'Tipo',
                        initialValue:
                            vm.solicitud.descripcionTipoVehiculoLocal ??
                                'No disponible',
                      ),
                      // const SizedBox(height: 10),

                      // SISTEMA de CAMBIOS

                      DropdownSearch<TransmisionesData>(
                        asyncItems: (text) => vm.getTransmisiones(text),
                        enabled: vm.solicitud.estadoTasacion == 34,
                        dropdownBuilder: (context, tipo) {
                          return Text(
                              tipo == null
                                  ? vm.vinData?.sistemaCambio ??
                                      vm.solicitud
                                          .descripcionSistemaTransmision ??
                                      'Seleccione'
                                  : tipo.descripcion,
                              style: const TextStyle(fontSize: 15));
                        },
                        onChanged: (v) => vm.transmision = v,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                label: Text('Sistema de cambios'),
                                border: UnderlineInputBorder())),
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
                        validator: vm.solicitud.estadoTasacion != 34
                            ? null
                            : (v) {
                                if (v == null &&
                                    vm.vinData?.sistemaCambio == null &&
                                    vm.solicitud
                                            .descripcionSistemaTransmision ==
                                        null) {
                                  return 'Seleccione un sistema de cambios';
                                } else {
                                  return null;
                                }
                              },
                      ),

                      // const SizedBox(height: 10),

                      DropdownSearch<TraccionesData>(
                        asyncItems: (text) => vm.getTracciones(text),
                        enabled: vm.solicitud.estadoTasacion == 34,
                        dropdownBuilder: (context, tipo) {
                          return Text(
                              tipo == null
                                  ? vm.vinData?.traccion ??
                                      vm.solicitud.descripcionTraccion ??
                                      'Seleccione'
                                  : tipo.descripcion,
                              style: const TextStyle(fontSize: 15));
                        },
                        onChanged: (v) => vm.traccion = v,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                label: Text('Tracción'),
                                border: UnderlineInputBorder())),
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
                        validator: vm.solicitud.estadoTasacion != 34
                            ? null
                            : (v) {
                                if (v == null &&
                                    vm.vinData?.traccion == null &&
                                    vm.solicitud
                                            .descripcionSistemaTransmision ==
                                        null) {
                                  return 'Seleccione una tracción';
                                } else {
                                  return null;
                                }
                              },
                      ),

                      // const SizedBox(height: 10),

                      DropdownSearch<int>(
                        items: const [2, 3, 4, 5],
                        enabled: vm.solicitud.estadoTasacion == 34,
                        dropdownBuilder: (context, nPuertas) {
                          return Text(
                              nPuertas == null
                                  ? '${vm.vinData?.numeroPuertas ?? vm.solicitud.noPuertas?.toString() ?? 'Seleccione'}'
                                  : nPuertas.toString(),
                              style: const TextStyle(fontSize: 15));
                        },
                        onChanged: (v) => vm.nPuertas = v,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                label: Text('No. de puertas'),
                                border: UnderlineInputBorder())),
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
                        validator: vm.solicitud.estadoTasacion != 34
                            ? null
                            : (v) {
                                if (v == null &&
                                    vm.vinData?.numeroPuertas == null &&
                                    vm.solicitud.noPuertas == null) {
                                  return 'Seleccione número de puertas';
                                } else {
                                  return null;
                                }
                              },
                      ),

                      // const SizedBox(height: 10),

                      DropdownSearch<int>(
                        items: const [3, 4, 5, 6, 8, 10, 12],
                        enabled: vm.solicitud.estadoTasacion == 34,
                        dropdownBuilder: (context, nCilindros) {
                          return Text(
                              nCilindros == null
                                  ? '${vm.vinData?.numeroCilindros ?? vm.solicitud.noCilindros ?? 'Seleccione'}'
                                  : nCilindros.toString(),
                              style: const TextStyle(fontSize: 15));
                        },
                        onChanged: (v) => vm.nCilindros = v,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                label: Text('No. de cilindros'),
                                border: UnderlineInputBorder())),
                        popupProps: PopupProps.menu(
                          itemBuilder: (context, nCilindros, isSelected) {
                            return ListTile(
                              title: Text(nCilindros.toString()),
                              selected: isSelected,
                            );
                          },
                          emptyBuilder: (_, __) => const Center(
                            child: Text('No hay resultados'),
                          ),
                        ),
                        validator: vm.solicitud.estadoTasacion != 34
                            ? null
                            : (v) {
                                if (v == null &&
                                    vm.vinData?.numeroCilindros == null &&
                                    vm.solicitud.noCilindros == null) {
                                  return 'Seleccione número de cilindros';
                                } else {
                                  return null;
                                }
                              },
                      ),

                      // Fuerza Motriz
                      BaseTextField(
                          enabled: vm.solicitud.estadoTasacion == 34,
                          label: 'Fuerza motriz',
                          controller: vm.tcFuerzaMotriz,
                          keyboardType: TextInputType.number,
                          validator: vm.solicitud.estadoTasacion != 34
                              ? null
                              : (v) {
                                  if (v?.trim() == '') {
                                    return 'Escriba la fuerza motriz';
                                  } else {
                                    return null;
                                  }
                                }),

                      //  ESTADO
                      BaseTextFieldNoEdit(
                        label: 'Estado del vehículo',
                        initialValue: vm.solicitud.descripcionNuevoUsado ??
                            'No disponible',
                      ),

                      //  KILOMETRAJE
                      BaseTextField(
                          enabled: vm.solicitud.estadoTasacion == 34,
                          label: 'Kilometraje',
                          keyboardType: TextInputType.number,
                          controller: vm.tcKilometraje,
                          validator: vm.solicitud.estadoTasacion != 34
                              ? null
                              : (v) {
                                  if (v?.trim() == '') {
                                    return 'Escriba el Kilometraje';
                                  } else {
                                    return null;
                                  }
                                }),

                      // const SizedBox(height: 10),

                      //  COLOR
                      DropdownSearch<ColorVehiculo>(
                          asyncItems: (text) => vm.getColores(text),
                          enabled: vm.solicitud.estadoTasacion == 34,
                          dropdownBuilder: (context, tipo) {
                            return Text(
                                tipo == null
                                    ? vm.solicitud.descripcionColor ??
                                        'Seleccione'
                                    : tipo.descripcion,
                                style: const TextStyle(fontSize: 15));
                          },
                          onChanged: (v) => vm.colorVehiculo = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
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
                            emptyBuilder: (_, __) => const Center(
                              child: Text('No hay resultados'),
                            ),
                          ),
                          validator: vm.solicitud.estadoTasacion != 34
                              ? null
                              : (v) {
                                  if (v == null &&
                                      vm.solicitud.descripcionColor == null) {
                                    return 'Seleccione un color';
                                  } else {
                                    return null;
                                  }
                                }),

                      // PLACA
                      BaseTextField(
                          enabled: vm.solicitud.estadoTasacion == 34,
                          label: 'Placa',
                          controller: vm.tcPlaca,
                          validator: vm.solicitud.estadoTasacion != 34
                              ? null
                              : (v) {
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
