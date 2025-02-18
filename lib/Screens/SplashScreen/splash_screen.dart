import 'dart:async';
import 'package:flutter/material.dart';

import '../WelcomeScreen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  String _displayText = "";
  final String _fullText = "ForeverBandhan";
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateToNextScreen();
    _startTypingAnimation();
  }
  //Method Implement in this Screen
  void _startTypingAnimation() {
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_textIndex < _fullText.length) {
        setState(() {
          _displayText += _fullText[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });
  }
  //Method Implement Over in this Screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orangeAccent,
              Colors.redAccent,
              Colors.blueAccent
            ],
          ),
        ),
        child: Stack(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(seconds: 2),
                  child: Text(
                    _displayText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'MyCustomFont',
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 55,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(seconds: 2),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  strokeWidth: 3,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
