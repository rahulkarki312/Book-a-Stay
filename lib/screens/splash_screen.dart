import 'package:flutter/material.dart';
// import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routename = '/splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _initSplash();
    super.initState();
  }

  Future<void> _initSplash() async {
    await Future.delayed(Duration(seconds: 3)).then((value) =>
        Navigator.of(context).pushReplacementNamed("AuthScreen.routeName"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
          flex: 0,
          fit: FlexFit.tight,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.10,
            margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 70),
            padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 14.0),
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.white),
              borderRadius: BorderRadius.circular(50),
              color: Colors.black,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: const Center(
              child: Text(
                'Book a stay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const CircularProgressIndicator(),
      ]),
    );
  }
}
