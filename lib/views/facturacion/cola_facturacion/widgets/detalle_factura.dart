import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/views/facturacion/cola_facturacion/cola_facturacion_view_model.dart';
import 'package:tasaciones_app/views/solicitudes/base_widgets/base_text_field_widget.dart';
import 'package:tasaciones_app/widgets/app_buttons.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../../core/models/facturacion/detalle_aprobacion_factura.dart';
import '../../../../core/models/facturacion/detalle_factura.dart';
import '../../../../core/providers/permisos_provider.dart';
import '../../../../core/providers/profile_permisos_provider.dart';
import '../../../../theme/theme.dart';
import '../../../solicitudes/trabajar_solicitud/widgets/forms/estimacion/estimacion_valoracion.dart';

class DetalleFacturaPage extends StatefulWidget {
  static const routeName = 'detalleFactura';
  const DetalleFacturaPage({required this.vm, required this.estado, Key? key})
      : super(key: key);
  final ColaFacturacionViewModel vm;
  final int estado;

  @override
  State<DetalleFacturaPage> createState() => _DetalleFacturaPageState();
}

class _DetalleFacturaPageState extends State<DetalleFacturaPage> {
  bool pendienteAprobar = false;
  @override
  void initState() {
    if (widget.vm.detalleAprobacionFactura
            .firstWhere((e) => e.idAprobador == widget.vm.profile!.id)
            .estadoAprobacion ==
        119) {
      pendienteAprobar = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final heightAppbar = MediaQuery.of(context).padding.top + kToolbarHeight;
    final permisos = Provider.of<ProfilePermisosProvider>(context).permisos;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
            title: Text('Factura No. ${widget.vm.detalleFactura.noFactura}')),
        floatingActionButton: (widget.vm.detalleFactura.estadoFactura == 5)
            ? Visibility(
                visible: permisos.any((e) => e.id == 231),
                child: FloatingActionButton.extended(
                  onPressed: () => widget.vm.goToReporte(
                      context, widget.vm.detalleFactura.noFactura!),
                  label: const Text('Exportar pdf',
                      style: TextStyle(color: Colors.white)),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
                    initialValue: widget.vm.detalleFactura.suplidor,
                    border: false,
                  ),
                  BaseTextFieldNoEdit(
                    label: 'RNC:',
                    initialValue: widget.vm.detalleFactura.rnc,
                    border: false,
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Dirección:',
                    initialValue: widget.vm.detalleFactura.direccion,
                    border: false,
                  ),
                  BaseTextFieldNoEdit(
                    label: 'Entidad:',
                    initialValue: widget.vm.detalleFactura.entidad,
                    border: false,
                  ),
                  BaseTextFieldNoEdit(
                    label: 'NCF:',
                    initialValue: widget.vm.detalleFactura.ncf,
                    border: false,
                  ),
                  const SizedBox(height: 10),
                  if (widget.vm.detalleFactura.detalleSucursales!.isNotEmpty)
                    _sucursales(),
                  // const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: BaseTextFieldNoEdit(
                          label: 'Honorarios:',
                          initialValue:
                              // '${NumberFormat('#,###.0#', 'es').format(vm.detalleFactura.honorarios)} RD\$',
                              widget.vm.fmf
                                  .copyWith(
                                      amount:
                                          widget.vm.detalleFactura.honorarios)
                                  .output
                                  .symbolOnLeft,
                          border: false,
                        ),
                      ),
                      Expanded(
                        child: BaseTextFieldNoEdit(
                          label: 'SubTotal:',
                          initialValue:
                              // '${NumberFormat('#,###.0#', 'es').format(vm.detalleFactura.subTotal)} RD\$',
                              widget.vm.fmf
                                  .copyWith(
                                      amount: widget.vm.detalleFactura.subTotal)
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
                          label: 'Itbis:',
                          initialValue:
                              // '${NumberFormat('#,###.0#', 'es').format(vm.detalleFactura.itbis)} RD\$',
                              widget.vm.fmf
                                  .copyWith(
                                      amount: widget.vm.detalleFactura.itbis)
                                  .output
                                  .symbolOnLeft,
                          border: false,
                        ),
                      ),
                      Expanded(
                        child: BaseTextFieldNoEdit(
                          label: 'Total General:',
                          initialValue:
                              // '${NumberFormat('#,###.0#', 'es').format(vm.detalleFactura.totalGeneral)} RD\$',
                              widget.vm.fmf
                                  .copyWith(
                                      amount:
                                          widget.vm.detalleFactura.totalGeneral)
                                  .output
                                  .symbolOnLeft,
                          border: false,
                        ),
                      ),
                    ],
                  ),
                  if (widget.vm.isAprobTasacion &&
                      (widget.estado == 117 || widget.estado == 4))
                    _ncf(context),
                  if (widget.estado != 117) _historialAprobacion(),
                  if (widget.vm.isAprobFacturas &&
                      widget.estado == 4 &&
                      pendienteAprobar)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Visibility(
                            visible: permisos.any((e) => e.id == 362),
                            child: AppButton(
                                text: 'Rechazar',
                                onPressed: () {
                                  Dialogs.confirm(context,
                                      tittle: 'Rechazar Factura',
                                      description:
                                          '¿Está seguro de rechazar la factura No. ${widget.vm.detalleFactura.noFactura}?',
                                      confirm: () async {
                                    await widget.vm.rechazarFactura(context,
                                        noFactura: widget
                                            .vm.detalleFactura.noFactura!);
                                    setState(() {});
                                  });
                                },
                                color: AppColors.brownDark),
                          ),
                          Visibility(
                            visible: permisos.any((e) => e.id == 361),
                            child: AppButton(
                                text: 'Aprobar',
                                onPressed: () {
                                  Dialogs.confirm(context,
                                      tittle: 'Aprobar Factura',
                                      description:
                                          '¿Está seguro de aprobar la factura No. ${widget.vm.detalleFactura.noFactura}?',
                                      confirm: () async {
                                    await widget.vm.aprobarFactura(context,
                                        noFactura: widget
                                            .vm.detalleFactura.noFactura!);
                                    setState(() {});
                                  });
                                },
                                color: AppColors.green),
                          ),
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

  Widget _historialAprobacion() {
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
            ...widget.vm.detalleAprobacionFactura.map((e) => builRow([
                  e.nombreAprobador ?? 'No disponible',
                  e.descripcionEstado ?? 'No disponible',
                  e.fecha?.year == 1
                      ? '-'
                      : DateFormat.yMMMd('es').format(e.fecha!).toUpperCase()
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
            key: widget.vm.formKey,
            child: BaseTextField(
              label: 'NCF',
              maxLength: 11,
              controller: widget.vm.tcNCf,
              textCapitalization: TextCapitalization.characters,
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
            onPressed: () => widget.vm.actualizarNCF(context,
                noFactura: widget.vm.detalleFactura.noFactura!),
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
        ...widget.vm.detalleFactura.detalleSucursales!.map((e) {
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
                      _itemTasacion(
                          'Fecha',
                          DateFormat.yMMMd('es')
                              .format(t.fechaTransaccion!)
                              .toUpperCase()),
                      _itemTasacion('Cliente', t.nombreCliente ?? ''),
                      _itemTasacion('Cédula', t.cedulaCliente ?? ''),
                      _itemTasacion(
                        'Costo',
                        widget.vm.fmf
                            .copyWith(amount: t.costo)
                            .output
                            .symbolOnLeft,
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
                      _itemTasacion(
                          'Fecha',
                          DateFormat.yMMMd('es')
                              .format(t.fechaTransaccion!)
                              .toUpperCase()),
                      _itemTasacion('Cliente', t.nombreCliente ?? ''),
                      _itemTasacion('Cédula', t.cedulaCliente ?? ''),
                      _itemTasacion(
                          'Costo',
                          widget.vm.fmf
                              .copyWith(amount: t.costo)
                              .output
                              .symbolOnLeft),
                      _divider(),
                    ],
                  );
                }),
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFieldNoEdit(
                        label: 'Honorarios',
                        initialValue: widget.vm.fmf
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
                            widget.vm.fmf
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
                            widget.vm.fmf
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
