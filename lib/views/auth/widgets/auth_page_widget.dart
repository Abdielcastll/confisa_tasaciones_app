import 'package:flutter/material.dart';

class AuthPageWidget extends StatelessWidget {
  const AuthPageWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 150,
              child: Image.asset('assets/img/header.png', fit: BoxFit.none),
            ),
            Container(
                height: MediaQuery.of(context).size.height - 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/img/fondo.png'),
                      fit: BoxFit.cover),
                ),
                child: child),
            SizedBox(
              height: 150,
              child: Image.asset('assets/img/footer.png', fit: BoxFit.cover),
            )
          ],
        ),
      ),
    );
  }
}
