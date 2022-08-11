import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasaciones_app/theme/theme.dart';

class AuthPageWidget extends StatelessWidget {
  const AuthPageWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 25),
              child: SvgPicture.asset(
                'assets/img/banco.svg',
                width: 100,
                height: 100,
              ),
            ),
            const Center(
              child: Text(
                'TASACIONES APP',
                style: TextStyle(
                  color: AppColors.brownDark,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height - 186,
                color: AppColors.white,
                // color: Colors.blueGrey,
                child: Center(child: child)),
          ],
        ),
      ),
    );
  }
}
