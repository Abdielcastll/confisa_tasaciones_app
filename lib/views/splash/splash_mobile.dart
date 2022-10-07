part of splash_view;

class _SplashMobile extends StatelessWidget {
  final SplashViewModel vm;

  const _SplashMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/icon.png',
                width: MediaQuery.of(context).size.width * .25),
            const SizedBox(height: 20),
            const Text(
              'Tasaciones App',
              style: TextStyle(
                color: AppColors.brownDark,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
