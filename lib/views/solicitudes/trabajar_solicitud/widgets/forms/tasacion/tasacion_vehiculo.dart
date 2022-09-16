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
        vm.vinData = null;
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
                    initialValue: vm.solicitudData?.marca ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Modelo',
                    initialValue: vm.solicitudData?.modelo ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Año',
                    initialValue: vm.solicitudData?.ano.toString(),
                  ),
                  if (vm.vinData?.serie != null)
                    BaseTextFieldNoEdit(
                      label: 'Serie',
                      initialValue: vm.vinData?.serie ?? '',
                    ),
                  if (vm.vinData?.trim != null)
                    BaseTextFieldNoEdit(
                      label: 'Trim',
                      initialValue: vm.vinData?.trim ?? '',
                    ),
                  if (vm.vinData != null)
                    Column(
                      children: [
                        DropdownSearch<VersionVehiculoData>(
                          asyncItems: (text) => vm.getversionVehiculo(text),
                          dropdownBuilder: (context, tipo) {
                            return Text(
                              tipo == null ? 'Seleccione' : tipo.descripcion,
                              style: const TextStyle(fontSize: 15),
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
                          validator: (v) {
                            if (v == null) {
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
                          validator: (v) {
                            if (v == null) {
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
                            return Text(
                              tipo == null
                                  ? vm.vinData?.tipoVehiculo ?? 'Seleccione'
                                  : tipo.descripcion,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );
                          },
                          onChanged: (v) => vm.tipoVehiculo = v,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
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
                            if (v == null && vm.vinData?.tipoVehiculo == null) {
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
                            return Text(
                                tipo == null
                                    ? vm.vinData?.sistemaCambio ?? 'Seleccione'
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
                          validator: (v) {
                            if (v == null &&
                                vm.vinData?.sistemaCambio == null) {
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
                            return Text(
                                tipo == null
                                    ? vm.vinData?.traccion ?? 'Seleccione'
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
                          validator: (v) {
                            if (v == null && vm.vinData?.traccion == null) {
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
                                    ? '${vm.vinData?.numeroPuertas ?? 'Seleccione'}'
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
                          validator: (v) {
                            if (v == null &&
                                vm.vinData?.numeroPuertas == null) {
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
                                    ? '${vm.vinData?.numeroCilindros ?? 'Seleccione'}'
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
                          validator: (v) {
                            if (v == null &&
                                vm.vinData?.numeroCilindros == null) {
                              return 'Seleccione número de cilindros';
                            } else {
                              return null;
                            }
                          },
                        ),

                        // Fuerza Motriz

                        BaseTextField(
                            label: 'Fuerza motriz',
                            controller: vm.tcFuerzaMotriz,
                            keyboardType: TextInputType.number,
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
                          label: 'Estado del vehículo',
                          initialValue: vm.estado,
                        ),
                        BaseTextField(
                            label: 'Kilometraje',
                            keyboardType: TextInputType.number,
                            controller: vm.tcKilometraje,
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
                        BaseTextField(
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
