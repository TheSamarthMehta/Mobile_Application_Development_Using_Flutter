import 'package:flutter/material.dart';
import 'package:foreverbandhan/Screens/Login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _visible = true;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.pink.shade500,
          Colors.purple.shade500,
          Colors.white
        ])),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2
                  ),
                  image: DecorationImage(
                      image: AssetImage('assets/images/ForeverBandhan.png'),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(seconds: 2),
                child: Text(
                  'Welcome To ForeverBandhan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
