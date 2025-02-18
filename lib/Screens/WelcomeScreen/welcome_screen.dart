import 'package:flutter/material.dart';
import '../SignInScreen/sign_in_screen.dart';
import '../SignUpScreen/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get device dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
              Colors.orange
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Welcome text section
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1, // Responsive horizontal padding
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome Back!\n',
                            style: TextStyle(
                              fontSize: screenHeight * 0.05, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'MyCustomFont',
                            ),
                          ),
                          TextSpan(
                            text: '\nEnter The Details',
                            style: TextStyle(
                              fontSize: screenHeight * 0.025, // Responsive font size
                              color: Colors.white,
                              fontFamily: 'MyCustomFont',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Spacing between the text and buttons
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              // Buttons section
              Container(
                height: screenHeight * 0.12, // Proportional bottom container height
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenHeight * 0.025, // Responsive font size
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyCustomFont',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenHeight * 0.025, // Responsive font size
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyCustomFont',
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
