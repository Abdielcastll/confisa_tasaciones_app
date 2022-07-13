import 'package:flutter/material.dart';

import '../../../core/models/profile_response.dart';
import '../../../theme/theme.dart';
import '../../../widgets/app_buttons.dart';

class CardProfileWidget extends StatelessWidget {
  const CardProfileWidget({required this.profile, Key? key}) : super(key: key);

  final Profile? profile;
  final TextStyle styleContent = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.brownLight2,
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(25, 50, 25, 0),
      child: Column(
        children: [
          Row(
            children: [
              _noImage(context),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.nombreCompleto ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      profile?.email ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          const Divider(
            thickness: 1.2,
            color: Colors.white,
          ),
          Text('Información',
              style: styleContent.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoItem('Empresa', 'xxxxxx'),
                      _infoItem('Teléfono', profile?.phoneNumber ?? ''),
                      _infoItem('Cédula', 'xxxxxxx'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoItem('Status', 'xxxxxxxx'),
                      _infoItem('Dirección', 'xxxxxxxx'),
                      Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit_note_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppButtonLogin(
              text: 'Permisos', onPressed: () {}, color: AppColors.orange),
          AppButtonLogin(
              text: 'Cambiar Contraseña',
              onPressed: () {},
              color: AppColors.brownDark),
        ],
      ),
    );
  }

  Widget _infoItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Text('$title: ',
              style: styleContent.copyWith(fontWeight: FontWeight.w600)),
          Text(content, style: styleContent),
        ],
      ),
    );
  }

  Widget _noImage(BuildContext context) {
    return ClipOval(
      child: Container(
        height: MediaQuery.of(context).size.width * .25,
        width: MediaQuery.of(context).size.width * .25,
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Image.asset(
          'assets/img/no-avatar.png',
          color: Colors.grey,
        ),
      ),
    );
  }
}
