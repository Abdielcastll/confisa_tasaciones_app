import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';

import '../../../../../../core/models/ediciones_vehiculo_response.dart';
import '../../../../../../core/models/tracciones_response.dart';
import '../../../../../../core/models/versiones_vehiculo_response.dart';
import '../../../../../../theme/theme.dart';
import '../../../../base_widgets/base_form_widget.dart';
import '../../../../base_widgets/base_text_field_widget.dart';
import '../../../trabajar_view_model.dart';

class VehiculoTasacionForm extends StatelessWidget {
  const VehiculoTasacionForm(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final TrabajarViewModel vm;

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
      onPressedNext: () => vm.goToCondiciones(context),
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
                      enabled: vm.vinData == null && vm.tcVIN.text.isEmpty,
                      textCapitalization: TextCapitalization.characters,
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
                    if (vm.vinData == null && vm.isNewVin) {
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
                    if (vm.vinData == null && vm.isNewVin) {
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
                    initialValue: vm.solicitud.descripcionMarca ??
                        vm.vinData?.marca ??
                        '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Modelo',
                    initialValue: vm.solicitud.descripcionModelo ??
                        vm.vinData?.modelo ??
                        '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Año',
                    initialValue: vm.solicitud.ano?.toString() ??
                        vm.vinData?.ano.toString() ??
                        '',
                  ),
                  if (vm.vinData?.serie != null || vm.showForm)
                    BaseTextFieldNoEdit(
                      label: 'Serie',
                      initialValue: vm.vinData?.serie == ''
                          ? 'No Disponible'
                          : vm.vinData?.serie ?? 'No Disponible',
                    ),
                  if (vm.vinData?.serie != null || vm.showForm)
                    BaseTextFieldNoEdit(
                      label: 'Trim',
                      initialValue: vm.vinData?.trim == ''
                          ? 'No Disponible'
                          : vm.vinData?.trim ?? 'No Disponible',
                    ),
                  if (vm.vinData?.serie != null || vm.showForm)
                    Column(
                      children: [
                        DropdownSearch<VersionVehiculoData>(
                          asyncItems: (text) => vm.getversionVehiculo(text),
                          dropdownBuilder: (context, tipo) {
                            return Text(
                              tipo == null
                                  ? vm.versionVehiculo?.descripcion ??
                                      vm.solicitud.descripcionVersion ??
                                      'Seleccione'
                                  : tipo.descripcion,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );

                            // return Text(
                            //   tipo == null
                            //       ? vm.solicitud.descripcionVersion ??
                            //           vm.versionVehiculo?.descripcion ??
                            //           'Seleccione'
                            //       : tipo.descripcion,
                            //   style: const TextStyle(fontSize: 15),
                            // );
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
                            if (v == null &&
                                vm.versionVehiculo == null &&
                                vm.solicitud.descripcionVersion == null) {
                              return 'Seleccione una versión';
                            } else {
                              return null;
                            }
                          },
                        ),

                        DropdownSearch<EdicionVehiculo>(
                          asyncItems: (text) => vm.getEdiciones(text),
                          dropdownBuilder: (context, tipo) {
                            return Text(
                              tipo == null
                                  ? vm.edicionVehiculo?.descripcionEasyBank ??
                                      vm.solicitud.descripcionEdicion ??
                                      'Seleccione'
                                  : tipo.descripcionEasyBank ?? '',
                              style: const TextStyle(fontSize: 15),
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
                            if (v == null &&
                                vm.edicionVehiculo == null &&
                                vm.solicitud.descripcionEdicion == null) {
                              return 'Seleccione una edición';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // TIPO DE VEHICULO

                        DropdownSearch<TipoVehiculoData>(
                          asyncItems: (text) => vm.getTipoVehiculo(text),
                          dropdownBuilder: (context, tipo) {
                            final String? vin = vm.vinData?.tipoVehiculo == ''
                                ? 'Seleccione'
                                : vm.vinData?.tipoVehiculo;
                            return Text(
                              tipo == null
                                  ? vm.tipoVehiculo?.descripcion ??
                                      vin ??
                                      vm.solicitud
                                          .descripcionTipoVehiculoLocal ??
                                      'Seleccione'
                                  : tipo.descripcion,
                              style: const TextStyle(fontSize: 15),
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
                            if (v == null &&
                                (vm.vinData?.tipoVehiculo == null ||
                                    vm.vinData?.tipoVehiculo == '') &&
                                vm.tipoVehiculo == null &&
                                vm.solicitud.descripcionTipoVehiculoLocal ==
                                    null) {
                              return 'Seleccione un tipo';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // SISTEMA DE TRANSMISIÓN

                        DropdownSearch<TransmisionesData>(
                          asyncItems: (text) => vm.getTransmisiones(text),
                          dropdownBuilder: (context, tipo) {
                            final String? vin = vm.vinData?.sistemaCambio == ''
                                ? 'Seleccione'
                                : vm.vinData?.sistemaCambio;
                            return Text(
                                tipo == null
                                    ? vm.transmision?.descripcion ??
                                        vin ??
                                        vm.solicitud
                                            .descripcionSistemaTransmision ??
                                        'Seleccione'
                                    : tipo.descripcion,
                                style: const TextStyle(fontSize: 15));
                          },
                          onChanged: (v) => vm.transmision = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  labelStyle:
                                      TextStyle(color: AppColors.brownDark),
                                  label: Text('Sistema de Cambios'),
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
                            if (v == null &&
                                (vm.vinData?.sistemaCambio == null ||
                                    vm.vinData?.sistemaCambio == '') &&
                                vm.traccion == null &&
                                vm.solicitud.descripcionSistemaTransmision ==
                                    null) {
                              return 'Seleccione un sistema de cambios';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // SISTEMA DE TRACCION

                        DropdownSearch<TraccionesData>(
                          asyncItems: (text) => vm.getTracciones(text),
                          dropdownBuilder: (context, tipo) {
                            final String? vin = vm.vinData?.traccion == ''
                                ? 'Seleccione'
                                : vm.vinData?.traccion;
                            return Text(
                                tipo == null
                                    ? vm.traccion?.descripcion ??
                                        vin ??
                                        vm.solicitud.descripcionTraccion ??
                                        'Seleccione'
                                    : tipo.descripcion,
                                style: const TextStyle(fontSize: 15));
                          },
                          onChanged: (v) => vm.traccion = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  labelStyle:
                                      TextStyle(color: AppColors.brownDark),
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
                          validator: (v) {
                            if (v == null &&
                                (vm.vinData?.traccion == null ||
                                    vm.vinData?.traccion == '') &&
                                vm.traccion == null &&
                                vm.solicitud.descripcionTraccion == null) {
                              return 'Seleccione una tracción';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // Numero de puertas

                        DropdownSearch<int>(
                          // asyncItems: (text) => vm.getTracciones(text),
                          items: const [2, 3, 4, 5],
                          dropdownBuilder: (context, nPuertas) {
                            return Text(
                                nPuertas == null
                                    ? vm.nPuertas?.toString() ??
                                        '${vm.vinData?.numeroPuertas ?? vm.solicitud.noPuertas?.toString() ?? 'Seleccione'}'
                                    : nPuertas.toString(),
                                style: const TextStyle(fontSize: 15));
                          },
                          onChanged: (v) => vm.nPuertas = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  labelStyle:
                                      TextStyle(color: AppColors.brownDark),
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
                          validator: (v) {
                            if (v == null &&
                                vm.vinData?.numeroPuertas == null &&
                                vm.nPuertas == null &&
                                vm.solicitud.noPuertas == null) {
                              return 'Seleccione número de puertas';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // Numero de cilindros

                        DropdownSearch<int>(
                          // asyncItems: (text) => vm.getTracciones(text),
                          items: const [3, 4, 5, 6, 8, 10, 12],
                          dropdownBuilder: (context, nCilindros) {
                            return Text(
                                nCilindros == null
                                    ? vm.nCilindros?.toString() ??
                                        '${vm.vinData?.numeroCilindros ?? vm.solicitud.noCilindros ?? 'Seleccione'}'
                                    : nCilindros.toString(),
                                style: const TextStyle(fontSize: 15));
                          },
                          onChanged: (v) => vm.nCilindros = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  labelStyle:
                                      TextStyle(color: AppColors.brownDark),
                                  label: Text('No. de Cilindros'),
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
                          validator: (v) {
                            if (v == null &&
                                vm.vinData?.numeroCilindros == null &&
                                vm.nCilindros == null &&
                                vm.solicitud.noCilindros == null) {
                              return 'Seleccione número de cilindros';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // Fuerza Motriz

                        BaseTextField(
                            label: 'Fuerza Motríz',
                            controller: vm.tcFuerzaMotriz,
                            keyboardType: TextInputType.number,
                            maxLength: 7,
                            validator: (v) {
                              if (v?.trim() == '') {
                                return 'Escriba la fuerza motriz';
                              } else if (v!.trim().contains(' ')) {
                                return 'Inválido';
                              } else {
                                return null;
                              }
                            }),
                        BaseTextFieldNoEdit(
                          label: 'Estado del Vehículo',
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
                              } else if (v!.trim().contains(' ')) {
                                return 'Inválido';
                              } else {
                                return null;
                              }
                            }),

                        DropdownSearch<ColorVehiculo>(
                            asyncItems: (text) => vm.getColores(text),
                            dropdownBuilder: (context, tipo) {
                              return Text(
                                  tipo == null
                                      ? vm.colorVehiculo?.descripcion ??
                                          vm.solicitud.descripcionColor ??
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
                              if (v == null &&
                                  vm.colorVehiculo == null &&
                                  vm.solicitud.descripcionColor == null) {
                                return 'Seleccione un color';
                              } else {
                                return null;
                              }
                            }),
                        BaseTextField(
                            label: 'Placa',
                            textCapitalization: TextCapitalization.characters,
                            controller: vm.tcPlaca,
                            maxLength: 8,
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
