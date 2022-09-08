// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/views/alarmas/alarmas_view.dart';
import 'package:tasaciones_app/views/notas/notas_view.dart';
import 'package:tasaciones_app/views/solicitudes/solicitud_estimacion/solicitud_estimacion_view.dart';
import 'package:tasaciones_app/views/solicitudes/solicitud_tasacion/solicitud_tasacion_view.dart';

import '../core/authentication_client.dart';
import '../core/locator.dart';
import '../theme/theme.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
// <<<<<<< HEAD
//   Appbar({
//     Key? key,
//     required this.titulo,
//     required this.textSize,
//   }) : super(key: key);
//   final String titulo;
//   final double textSize;
// =======
  Appbar(
      {Key? key,
      required this.titulo,
      required this.textSize,
      required this.alarmas,
      required this.esColaSolicitud,
      required this.idSolicitud})
      : super(key: key);
  final String titulo;
  final double textSize;
  final List<AlarmasData>? alarmas;
  final _authenticationAPI = locator<AuthenticationClient>();
  final bool esColaSolicitud;
  final int idSolicitud;
// >>>>>>> 54fea58bf1ebd9fae1f7632f65f5438839711932
  @override
  Widget build(BuildContext context) {
    final pref = _authenticationAPI.loadSession;
    final roles = pref.role;

    return AppBar(
      title: Text(
        titulo,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
// <<<<<<< HEAD
        if (roles.contains('OficialNegocios'))
          /*IconButton(
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
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, SolicitudEstimacionView.routeName);
                              },
                              child: const Text(
                                'Estimación',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
=======*/
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
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context,
                                            SolicitudEstimacionView.routeName);
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
                                            SolicitudTasacionView.routeName);
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
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (_) {
                                              return const SolicitudTasacionView(
                                                  incautado: true);
                                            },
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Tasación de Incauto',
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
                            );
                          },
                          icon: const Icon(
                            AppIcons.bell,
                            size: 24,
                          )),
                      Positioned(
                        top: 15,
                        left: 6,
                        child: Container(
                          child: Text(alarmas!.length.toString(),
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
            : Row(
                children: [
                  IconButton(
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
                      )),
                  Stack(
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
                            );
                          },
                          icon: const Icon(
                            AppIcons.bell,
                            size: 24,
                          )),
                      Positioned(
                        top: 15,
                        left: 6,
                        child: Container(
                          child: Text(alarmas!.length.toString(),
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
                  ),
                ],
              ),
// >>>>>>> 54fea58bf1ebd9fae1f7632f65f5438839711932
        // IconButton(
        //     onPressed: () {},
        //     icon: SvgPicture.asset('assets/img/settings.svg')),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
