// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/providers/alarmas_provider.dart';
import 'package:tasaciones_app/core/providers/profile_permisos_provider.dart';
import 'package:tasaciones_app/views/acciones_solicitud/acciones_solicitud_view.dart';
import 'package:tasaciones_app/views/alarmas/alarmas_view.dart';
import 'package:tasaciones_app/views/notas/notas_view.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/consultar_modificar_view_model.dart';
import 'package:tasaciones_app/views/solicitudes/solicitud_estimacion/solicitud_estimacion_view.dart';
import 'package:tasaciones_app/views/solicitudes/solicitud_estimacion/solicitud_estimacion_view_model.dart';
import 'package:tasaciones_app/views/solicitudes/solicitud_tasacion/solicitud_tasacion_view.dart';
import 'package:tasaciones_app/views/solicitudes/trabajar_solicitud/trabajar_view_model.dart';

import '../core/authentication_client.dart';
import '../core/locator.dart';
import '../theme/theme.dart';
import '../views/solicitudes/cola_solicitudes/cola_solicitudes_view_model.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  Appbar(
      {Key? key,
      required this.titulo,
      required this.textSize,
      this.vmColaSolicitudes,
      required this.esColaSolicitud,
      required this.idSolicitud,
      this.vmConsultarModificar,
      required this.tipoPage,
      this.vmSolicitudEstimacion,
      this.vmTrabajar})
      : super(key: key);
  final String titulo;
  final double textSize;
  final _authenticationAPI = locator<AuthenticationClient>();
  final bool esColaSolicitud;
  final int idSolicitud;
  final ColaSolicitudesViewModel? vmColaSolicitudes;
  final ConsultarModificarViewModel? vmConsultarModificar;
  final SolicitudEstimacionViewModel? vmSolicitudEstimacion;
  final TrabajarViewModel? vmTrabajar;
  late ProfilePermisoResponse profilePermisoResponse;
  final String tipoPage;

  @override
  Widget build(BuildContext context) {
    final pref = _authenticationAPI.loadSession;
    final roles = pref.role;
    profilePermisoResponse =
        Provider.of<ProfilePermisosProvider>(context, listen: false)
            .profilePermisos;

    return AppBar(
      title: Text(
        titulo,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (roles.contains('OficialNegocios'))
          if (roles.contains('OficialNegocios'))
            esColaSolicitud
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '¿Qué tipo de solicitud\ndesea realizar?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    MaterialButton(
                                      minWidth: double.infinity,
                                      height: 50,
                                      onPressed: () {
                                        Provider.of<AlarmasProvider>(context,
                                                listen: false)
                                            .alarmas = [];
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                                context,
                                                SolicitudEstimacionView
                                                    .routeName)
                                            .then((v) {
                                          if (v != null) {
                                            vmColaSolicitudes?.onInit(context);
                                          }
                                        });
                                      },
                                      child: const Text(
                                        'Estimación',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      textColor: Colors.white,
                                      color: AppColors.newBrownDark,
                                    ),
                                    const SizedBox(height: 15),
                                    MaterialButton(
                                      height: 50,
                                      minWidth: double.infinity,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context,
                                                SolicitudTasacionView.routeName)
                                            .then((v) {
                                          if (v != null) {
                                            vmColaSolicitudes?.onInit(context);
                                          }
                                        });
                                      },
                                      child: const Text(
                                        'Tasación',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      textColor: Colors.white,
                                      color: AppColors.brown,
                                    ),
                                    const SizedBox(height: 15),
                                    MaterialButton(
                                      height: 50,
                                      minWidth: double.infinity,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(context,
                                            CupertinoPageRoute(
                                          builder: (_) {
                                            return const SolicitudTasacionView(
                                                incautado: true);
                                          },
                                        )).then((v) {
                                          if (v != null) {
                                            vmColaSolicitudes?.onInit(context);
                                          }
                                        });
                                      },
                                      child: const Text(
                                        'Tasación Incautado',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      textColor: Colors.white,
                                      color: AppColors.brownLight,
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    icon: SvgPicture.asset('assets/img/list.svg'),
                  )
                : const SizedBox(),
        esColaSolicitud
            ? tienePermiso("Visualizar Alarmas")
                ? Row(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlarmasView(
                                            showCreate: false,
                                            idSolicitud: idSolicitud,
                                          )),
                                ).whenComplete(() {
                                  if (tipoPage == "Cola") {
                                    vmColaSolicitudes?.getAlarma(context);
                                  }
                                });
                              },
                              icon: const Icon(
                                AppIcons.bell,
                                size: 24,
                              )),
                          Positioned(
                            top: 15,
                            left: 6,
                            child: Container(
                              child: Text(
                                  Provider.of<AlarmasProvider>(context,
                                          listen: false)
                                      .alarmas
                                      .length
                                      .toString(),
                                  style: const TextStyle(fontSize: 12)),
                              alignment: AlignmentDirectional.center,
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox()
            : Row(
                children: [
                  tienePermiso("Visualizar NotasSolicitud")
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotasView(
                                        showCreate: true,
                                        idSolicitud: idSolicitud,
                                      )),
                            );
                          },
                          icon: const Icon(
                            AppIcons.pencilAlt,
                            size: 24,
                          ))
                      : const SizedBox(),
                  tienePermiso("Visualizar Alarmas")
                      ? Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AlarmasView(
                                              showCreate: true,
                                              idSolicitud: idSolicitud,
                                            )),
                                  ).whenComplete(() {
                                    if (tipoPage == "Consultar Modificar") {
                                      vmConsultarModificar?.getAlarmas(context);
                                    }
                                    if (tipoPage == "Solicitud Estimacion") {
                                      vmSolicitudEstimacion
                                          ?.getAlarmas(context);
                                    }
                                    if (tipoPage == "Trabajar") {
                                      vmTrabajar?.getAlarmas(context);
                                    }
                                  });
                                },
                                icon: const Icon(
                                  AppIcons.bell,
                                  size: 24,
                                )),
                            Positioned(
                              top: 15,
                              left: 6,
                              child: Container(
                                child: Text(
                                    Provider.of<AlarmasProvider>(context,
                                            listen: false)
                                        .alarmas
                                        .length
                                        .toString(),
                                    style: const TextStyle(fontSize: 12)),
                                alignment: AlignmentDirectional.center,
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                  tienePermiso("Visualizar AccionesPendientes")
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccionesSolicitudView(
                                        idSolicitud: idSolicitud,
                                        showCreate: true,
                                      )),
                            );
                          },
                          icon: const Icon(
                            Icons.person_pin_circle_sharp,
                            size: 24,
                          ))
                      : const SizedBox(),
                ],
              ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
  bool tienePermiso(String permisoRequerido) {
    for (var permisoRol in profilePermisoResponse.data) {
      for (var permiso in permisoRol.permisos!) {
        if (permiso.descripcion == permisoRequerido) return true;
      }
    }
    return false;
  }
}
