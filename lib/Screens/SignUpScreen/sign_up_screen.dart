import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimony_project/Screens/SignInScreen/sign_in_screen.dart';
import 'package:matrimony_project/Screens/WelcomeScreen/welcome_screen.dart';

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
  bool agreePersonalData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orange],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                    fontFamily: 'MyCustomFont'
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Create an account to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Full Name', _fullNameController,
                            TextInputType.name, _validateFullName),
                        const SizedBox(height: 16),
                        _buildTextField('Email', _emailController,
                            TextInputType.emailAddress, _validateEmail),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                            'Password', _passwordController, _isPasswordVisible,
                            () {
                          setState(
                              () => _isPasswordVisible = !_isPasswordVisible);
                        }),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                            'Confirm Password',
                            _confirmPasswordController,
                            _isConfirmPasswordVisible, () {
                          setState(() => _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible);
                        }),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: agreePersonalData,
                              onChanged: (bool? value) {
                                setState(() => agreePersonalData = value!);
                              },
                              activeColor: Colors.red,
                            ),
                            Expanded(
                              child: Text(
                                'I agree to the processing of Personal Details',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                  (route) => false,
                                );
                              }, // Navigate to Sign In
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType type, String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isVisible, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey),
          onPressed: toggleVisibility,
        ),
      ),
      validator:
          label == 'Password' ? _validatePassword : _validateConfirmPassword,
    );
  }

  String? _validateFullName(String? value) =>
      (value == null || value.trim().split(' ').length < 2)
          ? 'Enter full name'
          : null;

  String? _validateEmail(String? value) => (value == null ||
          !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value))
      ? 'Enter valid email'
      : null;

  String? _validatePassword(String? value) =>
      (value == null || value.length < 6)
          ? 'Password must be 6+ characters'
          : null;

  String? _validateConfirmPassword(String? value) =>
      (value != _passwordController.text) ? 'Passwords do not match' : null;

  void _registerUser() {
    if (_formKey.currentState!.validate() && agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registered Successfully'),
          duration: Duration(milliseconds: 500),
        ),
      );
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
          (route) => false,
        );
      });
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to the terms')));
    }
  }
}
