import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasaciones_app/views/solicitudes/solicitud_estimacion/solicitud_estimacion_view.dart';
import 'package:tasaciones_app/views/solicitudes/solicitud_tasacion/solicitud_tasacion_view.dart';

import '../theme/theme.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({
    Key? key,
    required this.titulo,
    required this.textSize,
  }) : super(key: key);
  final String titulo;
  final double textSize;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titulo,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
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
                              Navigator.pushNamed(
                                  context, SolicitudTasacionView.routeName);
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
                            onPressed: () {},
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
        ),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/img/notification.svg')),
            /*Positioned(
              top: 15,
              left: 6,
              child: Container(
                child: const Text("5", style: TextStyle(fontSize: 12)),
                alignment: AlignmentDirectional.center,
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),*/
          ],
        ),
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
