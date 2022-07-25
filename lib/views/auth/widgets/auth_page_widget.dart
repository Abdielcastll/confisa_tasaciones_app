import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Image.asset('assets/img/logo-confisa.png'),
            ),

            Container(
                height: MediaQuery.of(context).size.height - 130,
                color: AppColors.white,
                child: Center(child: child)),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   color: AppColors.brownDark,
            //   height: 140,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       const SizedBox(width: 20),
            //       Image.asset(
            //         'assets/img/Contacts17.png',
            //         height: 18,
            //       ),
            //       const SizedBox(width: 20),
            //       Image.asset(
            //         'assets/img/Email-1.png',
            //         height: 22,
            //       ),
            //       Expanded(
            //           child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Image.asset(
            //               'assets/img/Facebook-17.png',
            //               height: 22,
            //             ),
            //             const SizedBox(width: 10),
            //             Image.asset('assets/img/Instagram-17.png', height: 22),
            //           ],
            //         ),
            //       )),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
