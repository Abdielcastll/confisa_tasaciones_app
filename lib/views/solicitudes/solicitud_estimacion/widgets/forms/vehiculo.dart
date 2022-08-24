import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
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
        vm.vinData = null;
      },
      iconNext: Icons.arrow_forward_ios,
      labelNext: 'Siguiente',
      // onPressedNext: () => vm.solicitudCredito(context),
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
                  if (vm.vinData != null)
                    Column(
                      children: [
                        DropdownSearch<VersionVehiculoData>(
                          asyncItems: (text) => vm.getversionVehiculo(text),
                          dropdownBuilder: (context, tipo) {
                            return Text(
                              tipo == null ? 'Seleccione' : tipo.descripcion,
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
                          validator: (v) {
                            if (v == null) {
                              return 'Seleccione una versión';
                            } else {
                              return null;
                            }
                          },
                        ),
                        // TIPO DE VEHICULO

                        const SizedBox(height: 10),
                        vm.vinData?.tipoVehiculo != null &&
                                vm.vinData?.tipoVehiculo != ''
                            ? BaseTextFieldNoEdit(
                                label: 'Tipo',
                                initialValue: vm.vinData?.tipoVehiculo ?? '',
                              )
                            : DropdownSearch<TipoVehiculoData>(
                                asyncItems: (text) => vm.getTipoVehiculo(text),
                                dropdownBuilder: (context, tipo) {
                                  return Text(
                                    tipo == null
                                        ? vm.solicitudCola
                                                ?.descripcionTipoVehiculoLocal ??
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

                        vm.vinData?.sistemaCambio != null &&
                                vm.vinData?.sistemaCambio != ''
                            ? BaseTextFieldNoEdit(
                                label: 'Sistema de cambio',
                                initialValue: vm.vinData?.sistemaCambio,
                              )
                            : DropdownSearch<TransmisionesData>(
                                asyncItems: (text) => vm.getTransmisiones(text),
                                dropdownBuilder: (context, tipo) {
                                  return Text(
                                      tipo == null
                                          ? vm.solicitudCola
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
                                                label:
                                                    Text('Sistema de cambios'),
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
                                          ? vm.solicitudCola
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

                        vm.vinData?.numeroPuertas != null &&
                                vm.vinData?.numeroPuertas != ''
                            ? BaseTextFieldNoEdit(
                                label: 'No. de puertas',
                                initialValue: vm.vinData?.numeroPuertas,
                              )
                            : DropdownSearch<int>(
                                // asyncItems: (text) => vm.getTracciones(text),
                                items: const [2, 3, 4, 5],
                                dropdownBuilder: (context, nPuertas) {
                                  return Text(
                                      nPuertas == null
                                          ? vm.solicitudCola?.noPuertas
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

                        vm.vinData?.numeroCilindros != null &&
                                vm.vinData?.numeroCilindros != ''
                            ? BaseTextFieldNoEdit(
                                label: 'No. de cilindros',
                                initialValue: vm.vinData?.numeroCilindros,
                              )
                            : DropdownSearch<int>(
                                // asyncItems: (text) => vm.getTracciones(text),
                                items: const [3, 4, 5, 6, 8, 10, 12],
                                dropdownBuilder: (context, nCilindros) {
                                  return Text(
                                      nCilindros == null
                                          ? vm.solicitudCola?.noCilindros
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
                                                label: Text('No. de cilindros'),
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

                        BaseTextField(
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
                          initialValue: vm.estado,
                        ),
                        BaseTextField(
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

                        DropdownSearch<ColorVehiculo>(
                            asyncItems: (text) => vm.getColores(text),
                            dropdownBuilder: (context, tipo) {
                              return Text(
                                  tipo == null
                                      ? vm.solicitudCola?.descripcionColor ??
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
