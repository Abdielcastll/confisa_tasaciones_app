import 'package:flutter/material.dart';
import 'package:tasaciones_app/views/Perfil_de_usuario/perfil_view_model.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_buttons.dart';

class CardProfileWidget extends StatelessWidget {
  const CardProfileWidget(this.vm, {Key? key}) : super(key: key);

  final PerfilViewModel vm;
  final TextStyle styleContent =
      const TextStyle(color: Colors.white, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.brownLight,
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(25, 50, 25, 0),
      child: Column(
        children: [
          vm.tieneFoto ? Text(vm.fotoPerfil!.descripcion) : _noImage(context),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: vm.editable()
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        vm.editName
                            ? _textFieldEdit(
                                fontSize: 20,
                                onChanged: vm.onChangedName,
                                keyboardType: TextInputType.name,
                              )
                            : Expanded(
                                child: Text(
                                  vm.profile?.nombreCompleto ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                        Visibility(
                          visible: vm.editable(),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_note_sharp,
                              color: Colors.white,
                            ),
                            onPressed: () => vm.editName = !vm.editName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: vm.editable()
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          vm.editEmail
                              ? _textFieldEdit(
                                  fontSize: 18,
                                  onChanged: vm.onChangedEmail,
                                  keyboardType: TextInputType.emailAddress,
                                )
                              : Text(
                                  vm.profile?.email ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w600,
                                  ),
                                ),
                          Visibility(
                            visible: vm.editable(),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit_note_sharp,
                                color: Colors.white,
                              ),
                              onPressed: () => vm.editEmail = !vm.editEmail,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...vm.session.role.map((e) {
            return Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            );
          }),
          const SizedBox(height: 15),
          const Divider(
            thickness: 1.2,
            color: Colors.white,
          ),
          Text('Información',
              style: styleContent.copyWith(
                  fontSize: 22, fontWeight: FontWeight.w600)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vm.profile?.phoneNumber != null)
                  SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                            child: vm.editPhone
                                ? Row(
                                    children: [
                                      Text('Teléfono:  ',
                                          style: styleContent.copyWith(
                                              fontWeight: FontWeight.w600)),
                                      Expanded(
                                        child: _textFieldEdit(
                                          fontSize: 16,
                                          onChanged: vm.onChangedPhone,
                                          keyboardType: TextInputType.phone,
                                        ),
                                      ),
                                    ],
                                  )
                                : _infoItem(
                                    'Teléfono', vm.profile?.phoneNumber ?? '')),
                        Visibility(
                          visible: vm.editable(),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_note_sharp,
                              color: Colors.white,
                            ),
                            onPressed: () => vm.editPhone = !vm.editPhone,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (vm.profile?.empresa != null)
                  SizedBox(
                    child: _infoItem('Empresa', 'xxxxxx'),
                    height: 30,
                  ),
                SizedBox(
                  child: _infoItem('Estado',
                      vm.profile?.isActive == true ? 'Activo' : 'Inactivo'),
                  height: 30,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: vm.editable(),
            child: AppButtonLogin(
                text: 'Cambiar Contraseña',
                onPressed: () {
                  vm.editEmail = false;
                  vm.editName = false;
                  vm.editPhone = false;
                  vm.currentPage = 1;
                },
                color: AppColors.brownDark),
          ),
        ],
      ),
    );
  }

  TextField _textFieldEdit({
    required void Function(String)? onChanged,
    required double fontSize,
    required TextInputType keyboardType,
  }) {
    return TextField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        filled: true,
        isDense: true,
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
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
    return Stack(
      children: [
        ClipOval(
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
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: ClipOval(
              child: Container(
                padding: const EdgeInsets.all(5),
                height: 35,
                width: 35,
                color: AppColors.brown,
                child: IconButton(
                  icon: const Icon(
                    Icons.add_a_photo_rounded,
                    size: 20,
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ),
            ))
      ],
    );
  }
}
