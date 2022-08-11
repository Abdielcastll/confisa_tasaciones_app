import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/colores_vehiculos_response.dart';
import 'package:tasaciones_app/core/models/tipo_vehiculo_response.dart';
import 'package:tasaciones_app/core/models/transmisiones_response.dart';

import '../../../../../core/models/tracciones_response.dart';
import '../../../../../theme/theme.dart';
import '../../solicitud_estimacion_view_model.dart';
import '../base/base_form_widget.dart';
import '../base/base_text_field_widget.dart';

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
      iconBack: AppIcons.closeCircle,
      labelBack: 'Atrás',
      onPressedBack: () {
        vm.currentForm = 1;
        vm.vinData = null;
      },
      iconNext: AppIcons.save,
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
                      onChanged: (value) => vm.numeroVIN = value,
                      validator: vm.noVINValidator,
                      initialValue: 'KNAGN418BEA447872',
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
                  onPressed: () {},
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
                    initialValue: vm.solicitud.marca ?? '',
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Modelo',
                    initialValue: vm.solicitud.modelo ?? '',
                  ),
                  /*
              BaseTextFieldNoEdit(
                label: 'Edición Referencia',
                initialValue: vm.vinData?.trim ?? '',
              ),
              BaseTextFieldNoEdit(
                label: 'Serie Referencia',
                initialValue: vm.vinData?.serie ?? '',
              ),*/
                  BaseTextFieldNoEdit(
                    label: 'Año',
                    initialValue: vm.solicitud.ano ?? '',
                  ),
                  if (vm.vinData != null)
                    Column(
                      children: [
                        vm.vinData!.tipoVehiculo != null
                            ? BaseTextFieldNoEdit(
                                label: 'Tipo',
                                initialValue: vm.vinData!.tipoVehiculo,
                              )
                            : DropdownSearch<TipoVehiculoData>(
                                asyncItems: (text) => vm.getTipoVehiculo(text),
                                dropdownBuilder: (context, tipo) {
                                  return Text(
                                    tipo == null
                                        ? 'Seleccione'
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
                        vm.vinData!.sistemaCambio != null
                            ? BaseTextFieldNoEdit(
                                label: 'Sistema de cambio',
                                initialValue: vm.vinData!.sistemaCambio,
                              )
                            : DropdownSearch<TransmisionesData>(
                                asyncItems: (text) => vm.getTransmisiones(text),
                                dropdownBuilder: (context, tipo) {
                                  return Text(
                                      tipo == null
                                          ? 'Seleccione'
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
                        vm.vinData!.traccion != null
                            ? BaseTextFieldNoEdit(
                                label: 'Tracción',
                                initialValue: vm.vinData!.traccion,
                              )
                            : DropdownSearch<TraccionesData>(
                                asyncItems: (text) => vm.getTracciones(text),
                                dropdownBuilder: (context, tipo) {
                                  return Text(
                                      tipo == null
                                          ? 'Seleccione'
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
                        vm.vinData!.numeroPuertas != null
                            ? BaseTextFieldNoEdit(
                                label: 'No. de puertas',
                                initialValue: vm.vinData!.numeroPuertas,
                              )
                            : DropdownSearch<int>(
                                // asyncItems: (text) => vm.getTracciones(text),
                                items: const [2, 3, 4, 5],
                                dropdownBuilder: (context, nPuertas) {
                                  return Text(
                                      nPuertas == null
                                          ? 'Seleccione'
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
                        vm.vinData!.numeroCilindros != null
                            ? BaseTextFieldNoEdit(
                                label: 'No. de cilindros',
                                initialValue: vm.vinData!.numeroCilindros,
                              )
                            : DropdownSearch<int>(
                                // asyncItems: (text) => vm.getTracciones(text),
                                items: const [3, 4, 5, 6, 8, 10, 12],
                                dropdownBuilder: (context, nCilindros) {
                                  return Text(
                                      nCilindros == null
                                          ? 'Seleccione'
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
                        BaseTextField(
                            label: 'Fuerza motriz',
                            initialValue: vm.vinData?.fuerzaMotriz ?? '',
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
                            initialValue: '',
                            keyboardType: TextInputType.number,
                            onChanged: (v) => vm.kilometraje = v,
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
                                      ? 'Seleccione'
                                      : tipo.descripcion,
                                  style: const TextStyle(fontSize: 15));
                            },
                            onChanged: (v) => vm.colorVehiculo = v,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        label: Text('Color'),
                                        border: UnderlineInputBorder())),
                            // dropdownDecoratorProps: DropDownDecoratorProps(
                            //     dropdownSearchDecoration:
                            //         InputDecoration(border: UnderlineInputBorder())),
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
                            initialValue: '',
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

            // Form(
            //   key: vm.formKey,
            //   child: BaseTextField(
            //     label: 'No. de solicitud de crédito',
            //     hint: 'Ingrese el número de solicitud',
            //     keyboardType: TextInputType.number,
            //     onChanged: (value) => vm.numeroSolicitud = value,
            //     validator: vm.noSolicitudValidator,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
