import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../HomeScreen/home_screen.dart';
import '../SignUpScreen/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool rememberPassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orangeAccent, Colors.orange],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: screenHeight * 0.02,
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.05,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.1),
                      topRight: Radius.circular(screenWidth * 0.1),
                    ),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome back',
                                style: TextStyle(
                                  fontFamily: 'MyCustomFont',
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Enter Email',
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03),
                                  ),
                                ),
                                validator: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: screenHeight * 0.025,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter Password',
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordVisible =
                                        !_isPasswordVisible;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: screenWidth * 0.02,
                                        top: screenHeight * 0.016,
                                      ),
                                      child: Text(
                                        _isPasswordVisible ? "Hide" : "Show",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                validator: _validatePassword,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: rememberPassword,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            rememberPassword = value!;
                                          });
                                        },
                                        activeColor: Colors.red,
                                      ),
                                      Text(
                                        'Remember me',
                                        style: TextStyle(
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _loginUser,
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.7,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      'Sign In With',
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.7,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Logo(Logos.facebook_f),
                                  Logo(Logos.twitter),
                                  Logo(Logos.google),
                                  Logo(Logos.apple)
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account?',
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()),
                                      );
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.05,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is Required';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Enter a Valid Email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _loginUser() {
    if (_formKey.currentState!.validate() && rememberPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Successfully'),
          duration: Duration(milliseconds: 500),
        ),
      );
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
      });
    } else if (!rememberPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Agree to the Processing the personal details'),
      ));
    }
  }
}