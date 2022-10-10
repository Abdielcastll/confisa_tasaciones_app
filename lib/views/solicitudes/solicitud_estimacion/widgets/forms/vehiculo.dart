import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/ediciones_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';

import '../../../../../core/models/tracciones_response.dart';
import '../../../../../core/models/versiones_vehiculo_response.dart';
import '../../../../../theme/theme.dart';
import '../../../base_widgets/base_form_widget.dart';
import '../../../base_widgets/base_text_field_widget.dart';
import '../../solicitud_estimacion_view_model.dart';

class VehiculoForm extends StatelessWidget {
  const VehiculoForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final SolicitudEstimacionViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BaseFormWidget(
      iconHeader: Icons.add_chart_sharp,
      titleHeader: 'Vehículo',
      iconBack: Icons.arrow_back_ios,
      labelBack: 'Anterior',
      onPressedBack: () {
        vm.currentForm = 1;
      },
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      onPressedNext: () => vm.goToFotos(context),
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
                      enabled: vm.vinData == null,
                      label: 'No. VIN',
                      hint: 'Ingrese el número VIN del vehículo',
                      validator: vm.noVINValidator,
                      controller: vm.tcVIN,
                      maxLength: 17,
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 50,
                  onPressed: () {
                    if (vm.vinData == null) {
                      vm.consultarVIN(context);
                    }
                  },
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
                  onPressed: () async {
                    if (vm.vinData == null) {
                      await vm.escanearVIN();
                    }
                  },
                  icon: const CircleAvatar(
                    child: Icon(
                      Icons.qr_code,
                      color: AppColors.white,
                    ),
                    backgroundColor: AppColors.brownDark,
                  ),
                ),
                IconButton(
                  iconSize: 50,
                  onPressed: () {
                    vm.resetData();
                  },
                  icon: const CircleAvatar(
                    child: Icon(
                      Icons.restart_alt_rounded,
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
                  if (vm.vinData?.message != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.yellow[600],
                      ),
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded),
                          const SizedBox(width: 5),
                          Expanded(child: Text(vm.vinData!.message!)),
                        ],
                      ),
                    ),
                  BaseTextFieldNoEdit(
                    label: 'Marca',
                    initialValue: vm.solicitud?.marca ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Modelo',
                    initialValue: vm.solicitud?.modelo ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Año',
                    initialValue: vm.solicitud?.ano ?? '',
                  ),
                  if (vm.vinData?.serie != null)
                    BaseTextFieldNoEdit(
                      label: 'Serie',
                      initialValue: vm.vinData?.serie == ''
                          ? 'No disponible'
                          : vm.vinData?.serie ?? '',
                    ),
                  if (vm.vinData?.trim != null)
                    BaseTextFieldNoEdit(
                      label: 'Trim',
                      initialValue: vm.vinData?.trim == ''
                          ? 'No disponible'
                          : vm.vinData?.trim ?? '',
                    ),
                  if (vm.vinData != null)
                    Column(
                      children: [
                        DropdownSearch<VersionVehiculoData>(
                          asyncItems: (text) => vm.getversionVehiculo(text),
                          dropdownBuilder: (context, tipo) {
                            return Text(
                              tipo == null
                                  ? vm.versionVehiculo?.descripcion ??
                                      'Seleccione'
                                  : tipo.descripcion,
                              style: const TextStyle(fontSize: 15),
                            );
                          },
                          onChanged: (v) => vm.versionVehiculo = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  labelStyle:
                                      TextStyle(color: AppColors.brownDark),
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
                          validator: (v) {
                            if (v == null && vm.versionVehiculo == null) {
                              return 'Seleccione una versión';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // EDICION

                        DropdownSearch<EdicionVehiculo>(
                          asyncItems: (text) => vm.getEdiciones(text),
                          dropdownBuilder: (context, tipo) {
                            return Text(
                              tipo == null
                                  ? vm.edicionVehiculo?.descripcionEasyBank ??
                                      'Seleccione'
                                  : tipo.descripcionEasyBank ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );
                          },
                          onChanged: (v) => vm.edicionVehiculo = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  labelStyle:
                                      TextStyle(color: AppColors.brownDark),
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
                          validator: (v) {
                            if (v == null && vm.edicionVehiculo == null) {
                              return 'Seleccione una edición';
                            } else {
                              return null;
                            }
                          },
                        ),
                        // TIPO DE VEHICULO

                        // const SizedBox(height: 10),

                        DropdownSearch<TipoVehiculoData>(
                          asyncItems: (text) => vm.getTipoVehiculo(text),
                          dropdownBuilder: (context, tipo) {
                            return Text(
                              tipo == null
                                  ? vm.tipoVehiculo?.descripcion ??
                                      vm.solicitudCola
                                          ?.descripcionTipoVehiculoLocal ??
                                      'Seleccione'
                                  : tipo.descripcion,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );
                          },
                          onChanged: (v) => vm.tipoVehiculo = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  labelStyle:
                                      TextStyle(color: AppColors.brownDark),
                                  label: Text('Tipo'),
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
                          validator: (v) {
                            if (v == null && vm.tipoVehiculo == null) {
                              return 'Seleccione un tipo';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // const SizedBox(height: 10),

                        // SISTEMA DE TRANSMISIÓN

                        vm.vinData?.sistemaCambio != null &&
                                vm.vinData?.sistemaCambio != ''
                            ? BaseTextFieldNoEdit(
                                label: 'Sistema de Cambio',
                                initialValue: vm.vinData?.sistemaCambio,
                              )
                            : DropdownSearch<TransmisionesData>(
                                asyncItems: (text) => vm.getTransmisiones(text),
                                dropdownBuilder: (context, tipo) {
                                  return Text(
                                      tipo == null
                                          ? vm.transmision?.descripcion ??
                                              vm.solicitudCola
                                                  ?.descripcionSistemaTransmision ??
                                              'Seleccione'
                                          : tipo.descripcion,
                                      style: const TextStyle(fontSize: 15));
                                },
                                onChanged: (v) => vm.transmision = v,
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                labelStyle: TextStyle(
                                                    color: AppColors.brownDark),
                                                label:
                                                    Text('Sistema de Cambios'),
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
                                  if (v == null && vm.transmision == null) {
                                    return 'Seleccione un sistema de cambios';
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                        // const SizedBox(height: 10),

                        // SISTEMA DE TRACCION

                        vm.vinData?.traccion != null &&
                                vm.vinData?.traccion != ''
                            ? BaseTextFieldNoEdit(
                                label: 'Tracción',
                                initialValue: vm.vinData?.traccion,
                              )
                            : DropdownSearch<TraccionesData>(
                                asyncItems: (text) => vm.getTracciones(text),
                                dropdownBuilder: (context, tipo) {
                                  return Text(
                                      tipo == null
                                          ? vm.traccion?.descripcion ??
                                              vm.solicitudCola
                                                  ?.descripcionTraccion ??
                                              'Seleccione'
                                          : tipo.descripcion,
                                      style: const TextStyle(fontSize: 15));
                                },
                                onChanged: (v) => vm.traccion = v,
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                labelStyle: TextStyle(
                                                    color: AppColors.brownDark),
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
                                  if (v == null && vm.traccion == null) {
                                    return 'Seleccione una tracción';
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                        // const SizedBox(height: 10),

                        // Numero de puertas

                        vm.vinData?.numeroPuertas != null
                            ? BaseTextFieldNoEdit(
                                label: 'No. de Puertas',
                                initialValue:
                                    vm.vinData?.numeroPuertas.toString(),
                              )
                            : DropdownSearch<int>(
                                // asyncItems: (text) => vm.getTracciones(text),
                                items: const [2, 3, 4, 5],
                                dropdownBuilder: (context, nPuertas) {
                                  return Text(
                                      nPuertas == null
                                          ? vm.nPuertas?.toString() ??
                                              vm.solicitudCola?.noPuertas
                                                  .toString() ??
                                              'Seleccione'
                                          : nPuertas.toString(),
                                      style: const TextStyle(fontSize: 15));
                                },
                                onChanged: (v) => vm.nPuertas = v,
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                labelStyle: TextStyle(
                                                    color: AppColors.brownDark),
                                                label: Text('No. de Puertas'),
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
                                  if (v == null && vm.nPuertas == null) {
                                    return 'Seleccione número de puertas';
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                        // const SizedBox(height: 10),

                        // Numero de cilindros

                        vm.vinData?.numeroCilindros != null
                            ? BaseTextFieldNoEdit(
                                label: 'No. de Cilindros',
                                initialValue:
                                    vm.vinData?.numeroCilindros.toString(),
                              )
                            : DropdownSearch<int>(
                                // asyncItems: (text) => vm.getTracciones(text),
                                items: const [3, 4, 5, 6, 8, 10, 12],
                                dropdownBuilder: (context, nCilindros) {
                                  return Text(
                                      nCilindros == null
                                          ? vm.nCilindros?.toString() ??
                                              vm.solicitudCola?.noCilindros
                                                  .toString() ??
                                              'Seleccione'
                                          : nCilindros.toString(),
                                      style: const TextStyle(fontSize: 15));
                                },
                                onChanged: (v) => vm.nCilindros = v,
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                labelStyle: TextStyle(
                                                    color: AppColors.brownDark),
                                                label: Text('No. de Cilindros'),
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
                                  if (v == null && vm.nCilindros == null) {
                                    return 'Seleccione número de cilindros';
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                        // Fuerza Motriz
                        vm.vinData?.fuerzaMotriz != null
                            ? BaseTextFieldNoEdit(
                                label: 'Fuerza Motriz',
                                initialValue:
                                    vm.vinData!.fuerzaMotriz.toString(),
                              )
                            : BaseTextField(
                                label: 'Fuerza Motriz',
                                controller: vm.tcFuerzaMotriz,
                                maxLength: 7,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v?.trim() == '') {
                                    return 'Escriba la fuerza motriz';
                                  } else {
                                    return null;
                                  }
                                }),
                        BaseTextFieldNoEdit(
                          label: 'Estado del vehículo',
                          initialValue: vm.estado,
                        ),
                        BaseTextField(
                            label: 'Kilometraje',
                            keyboardType: TextInputType.number,
                            controller: vm.tcKilometraje,
                            maxLength: 9,
                            validator: (v) {
                              if (v?.trim() == '') {
                                return 'Escriba el Kilometraje';
                              } else {
                                return null;
                              }
                            }),
                        // const SizedBox(height: 10),

                        DropdownSearch<ColorVehiculo>(
                            asyncItems: (text) => vm.getColores(text),
                            dropdownBuilder: (context, tipo) {
                              return Text(
                                  tipo == null
                                      ? vm.colorVehiculo?.descripcion ??
                                          vm.solicitudCola?.descripcionColor ??
                                          'Seleccione'
                                      : tipo.descripcion,
                                  style: const TextStyle(fontSize: 15));
                            },
                            onChanged: (v) => vm.colorVehiculo = v,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            color: AppColors.brownDark),
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
                              if (v == null && vm.colorVehiculo == null) {
                                return 'Seleccione un color';
                              } else {
                                return null;
                              }
                            }),
                        BaseTextField(
                            label: 'Placa',
                            maxLength: 8,
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
