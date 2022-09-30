import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasaciones_app/views/facturacion/cola_facturacion/cola_facturacion_view_model.dart';
import 'package:tasaciones_app/views/solicitudes/base_widgets/base_text_field_widget.dart';
import 'package:tasaciones_app/widgets/app_buttons.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../../core/models/facturacion/detalle_aprobacion_factura.dart';
import '../../../../core/models/facturacion/detalle_factura.dart';
import '../../../../theme/theme.dart';
import '../../../solicitudes/trabajar_solicitud/widgets/forms/estimacion/estimacion_valoracion.dart';

class DetalleFacturaPage extends StatelessWidget {
  static const routeName = 'detalleFactura';
  const DetalleFacturaPage(
      {required this.detalleFactura,
      required this.detalleAprobacionFactura,
      required this.vm,
      required this.estado,
      Key? key})
      : super(key: key);
  final DetalleFactura detalleFactura;
  final List<DetalleAprobacionFactura> detalleAprobacionFactura;
  final ColaFacturacionViewModel vm;
  final int estado;

  @override
  Widget build(BuildContext context) {
    final heightAppbar = MediaQuery.of(context).padding.top + kToolbarHeight;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(title: Text('Factura No. ${detalleFactura.noFactura}')),
        body: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppColors.brownDark, width: 1.5)),
          margin: const EdgeInsets.all(10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - heightAppbar,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
                  BaseTextFieldNoEdit(
                    label: 'Suplidor:',
                    initialValue: detalleFactura.suplidor,
                    border: false,
                  ),
                  BaseTextFieldNoEdit(
                    label: 'RNC:',
                    initialValue: detalleFactura.rnc,
                    border: false,
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Dirección:',
                    initialValue: detalleFactura.direccion,
                    border: false,
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Entidad:',
                    initialValue: detalleFactura.entidad,
                    border: false,
                  ),
                  BaseTextFieldNoEdit(
                    label: 'NCF:',
                    initialValue: detalleFactura.ncf,
                    border: false,
                  ),
                  const SizedBox(height: 10),
                  if (detalleFactura.detalleSucursales!.isNotEmpty)
                    _sucursales(),
                  // const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: BaseTextFieldNoEdit(
                          label: 'Itbis:',
                          initialValue:
                              // '${NumberFormat('#,###.0#', 'es').format(detalleFactura.itbis)} RD\$',
                              vm.fmf
                                  .copyWith(amount: detalleFactura.itbis)
                                  .output
                                  .symbolOnLeft,
                          border: false,
                        ),
                      ),
                      Expanded(
                        child: BaseTextFieldNoEdit(
                          label: 'Honorarios:',
                          initialValue:
                              // '${NumberFormat('#,###.0#', 'es').format(detalleFactura.honorarios)} RD\$',
                              vm.fmf
                                  .copyWith(amount: detalleFactura.honorarios)
                                  .output
                                  .symbolOnLeft,
                          border: false,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: BaseTextFieldNoEdit(
                          label: 'SubTotal:',
                          initialValue:
                              // '${NumberFormat('#,###.0#', 'es').format(detalleFactura.subTotal)} RD\$',
                              vm.fmf
                                  .copyWith(amount: detalleFactura.subTotal)
                                  .output
                                  .symbolOnLeft,
                          border: false,
                        ),
                      ),
                      Expanded(
                        child: BaseTextFieldNoEdit(
                          label: 'Total General:',
                          initialValue:
                              // '${NumberFormat('#,###.0#', 'es').format(detalleFactura.totalGeneral)} RD\$',
                              vm.fmf
                                  .copyWith(amount: detalleFactura.totalGeneral)
                                  .output
                                  .symbolOnLeft,
                          border: false,
                        ),
                      ),
                    ],
                  ),
                  if (vm.isAprobTasacion && (estado == 117 || estado == 4))
                    _ncf(context),
                  if (estado != 117) _historialAprobacion(),
                  if (vm.isAprobFacturas && estado == 4)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton(
                              text: 'Rechazar',
                              onPressed: () {
                                Dialogs.confirm(context,
                                    tittle: 'Rechazar Factura',
                                    description:
                                        '¿Está seguro de rechazar la factura No. ${detalleFactura.noFactura}?',
                                    confirm: () => vm.rechazarFactura(context,
                                        noFactura: detalleFactura.noFactura!));
                              },
                              color: AppColors.brownDark),
                          AppButton(
                              text: 'Aprobar',
                              onPressed: () {
                                Dialogs.confirm(context,
                                    tittle: 'Aprobar Factura',
                                    description:
                                        '¿Está seguro de aprobar la factura No. ${detalleFactura.noFactura}?',
                                    confirm: () => vm.aprobarFactura(context,
                                        noFactura: detalleFactura.noFactura!));
                              },
                              color: AppColors.green),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _historialAprobacion() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          'Historial de aprobación',
          style: TextStyle(
            color: AppColors.brownDark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: AppColors.brownDark),
          columnWidths: const {
            0: FractionColumnWidth(0.50),
            1: FractionColumnWidth(0.25),
            2: FractionColumnWidth(0.25),
          },
          children: [
            builRow(
              ['Aprobador', 'Estado', 'Fecha'],
              isHeader: true,
            ),
            ...detalleAprobacionFactura.map((e) => builRow([
                  e.nombreAprobador ?? 'No disponible',
                  e.descripcionEstado ?? 'No disponible',
                  DateFormat.yMd('es').format(e.fecha!)
                ])),
          ],
        ),
      ],
    );
  }

  Widget _ncf(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .60,
          child: Form(
            key: vm.formKey,
            child: BaseTextField(
              label: 'NCF',
              maxLength: 10,
              keyboardType: TextInputType.number,
              initialValue: detalleFactura.ncf ?? '',
              validator: (v) {
                if (v!.trim() == '') {
                  return 'Ingrese NCF';
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
        AppButton(
            text: 'Actualizar NCF',
            onPressed: () =>
                vm.actualizarNCF(context, noFactura: detalleFactura.noFactura!),
            color: AppColors.brownDark),
      ],
    );
  }

  Widget _sucursales() {
    return Column(
      children: [
        const Text(
          'Sucursales',
          style: TextStyle(
            color: AppColors.brownDark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        ...detalleFactura.detalleSucursales!.map((e) {
          return Container(
            margin: const EdgeInsets.only(top: 5, bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration:
                BoxDecoration(border: Border.all(color: AppColors.brownDark)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseTextFieldNoEdit(
                  label: 'Nombre Sucursal:',
                  initialValue: e.nombreSucursal,
                  border: false,
                ),
                const SizedBox(height: 10),
                if (e.tasacionesReserva!.isNotEmpty)
                  const Text(
                    'Tasaciones Reserva',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.brownDark,
                      fontSize: 15,
                    ),
                  ),
                ...e.tasacionesReserva!.map((t) {
                  return Column(
                    children: [
                      _divider(),
                      _itemTasacion('No. Tasación', t.noTasacion.toString()),
                      _itemTasacion('Id Crédito', t.idCredito.toString()),
                      _itemTasacion('Fecha',
                          DateFormat.yMd('es').format(t.fechaTransaccion!)),
                      _itemTasacion('Cliente', t.nombreCliente ?? ''),
                      _itemTasacion('Cédula', t.cedulaCliente ?? ''),
                      _itemTasacion(
                        'Costo',
                        vm.fmf.copyWith(amount: t.costo).output.symbolOnLeft,
                      ),
                      _divider(),
                    ],
                  );
                }),
                const SizedBox(height: 10),
                if (e.tasacionesGastos!.isNotEmpty)
                  const Text(
                    'Tasaciones Gastos',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.brownDark,
                      fontSize: 15,
                    ),
                  ),
                ...e.tasacionesGastos!.map((t) {
                  return Column(
                    children: [
                      _divider(),
                      _itemTasacion('No. Tasación', t.noTasacion.toString()),
                      _itemTasacion('Id Crédito', t.idCredito.toString()),
                      _itemTasacion('Fecha',
                          DateFormat.yMd('es').format(t.fechaTransaccion!)),
                      _itemTasacion('Cliente', t.nombreCliente ?? ''),
                      _itemTasacion('Cédula', t.cedulaCliente ?? ''),
                      _itemTasacion('Costo',
                          vm.fmf.copyWith(amount: t.costo).output.symbolOnLeft),
                      _divider(),
                    ],
                  );
                }),
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFieldNoEdit(
                        label: 'Honorarios',
                        initialValue: vm.fmf
                            .copyWith(amount: e.honorarios)
                            .output
                            .symbolOnLeft,
                        border: false,
                      ),
                    ),
                    Expanded(
                      child: BaseTextFieldNoEdit(
                        label: 'Total Reservas',
                        initialValue:
                            // '${NumberFormat('#,###.0#', 'es').format(e.totalReservas)} RD\$',
                            vm.fmf
                                .copyWith(amount: e.totalReservas)
                                .output
                                .symbolOnLeft,
                        border: false,
                      ),
                    ),
                    Expanded(
                      child: BaseTextFieldNoEdit(
                        label: 'Total Gastos',
                        initialValue:
                            // '${NumberFormat('#,###.0#', 'es').format(e.totalGastos)} RD\$',
                            vm.fmf
                                .copyWith(amount: e.totalGastos)
                                .output
                                .symbolOnLeft,
                        border: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        })
      ],
    );
  }

  Divider _divider() => const Divider(thickness: 1.2);

  Widget _itemTasacion(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.brownDark,
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(value))
        ],
      ),
    );
  }
}
