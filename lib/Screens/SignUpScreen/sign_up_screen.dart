import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

import '../SignInScreen/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool agreePersonalData = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
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
                      topRight: Radius.circular(screenWidth * 0.1),
                      topLeft: Radius.circular(screenWidth * 0.1),
                    ),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        // get started form
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  fontFamily: 'MyCustomFont',
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              TextFormField(
                                controller: _fullNameController,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  hintText: 'Enter Full Name',
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
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.03)),
                                ),
                                validator: _validateFullName,
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'[0-9]')),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.025,
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
                                    borderSide: BorderSide(
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
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !_isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  hintText: 'Enter Confirm Password',
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
                                        _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: screenWidth * 0.02,
                                        top: screenHeight * 0.016,
                                      ),
                                      child: Text(
                                        _isConfirmPasswordVisible
                                            ? "Hide"
                                            : "Show",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                validator: _validateConfirmPassword,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: agreePersonalData,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        agreePersonalData = value!;
                                      });
                                    },
                                    activeColor: Colors.red,
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: screenWidth * 0.04),
                                        children: [
                                          TextSpan(
                                            text: 'I agree to the processing of',
                                          ),
                                          TextSpan(
                                              text: ' Personal Details',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              )
                                          )
                                        ],
                                      ),
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
                                  onPressed: _registerUser,
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 18),
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
                              // already have an account
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
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
                                                SignInScreen()),
                                      );
                                    },
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    // Split the name by spaces
    List<String> nameParts = value.trim().split(' ');

    // Check if there are at least two parts (first and last name)
    if (nameParts.length < 2) {
      return 'Please enter your first and last name';
    }

    // Check if any part is too short (e.g., single letter)
    if (nameParts.any((part) => part.length < 2)) {
      return 'Each name part should have at least 2 letters';
    }

    return null; // No validation errors
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _registerUser() {
    if (_formKey.currentState!.validate() && agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Register Successfully'),
          duration: Duration(milliseconds: 500),
        ),
      );
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
              (route) => false,
        );
      });
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Agree to the Processing the personal details'),
      ));
    }
  }
}