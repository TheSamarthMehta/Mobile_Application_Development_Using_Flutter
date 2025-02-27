import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../Database/database_helper.dart';
import '../../Models/user.dart';
import '../HomeScreen/home_screen.dart';

class RegisterUserScreen extends StatefulWidget {
  final User? user;

  const RegisterUserScreen({super.key, this.user});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formkey = GlobalKey<FormState>();

  // Controllers for each input field
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  // Variable to hold the selected gender
  String selectedGender = 'Male';

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _selectedDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime eighteenYearsAgo = DateTime(currentDate.year - 18, 12, 31);
    DateTime firstAllowedDate = DateTime(1950);

    // If a date is already selected, use it; otherwise, default to eighteenYearsAgo
    DateTime? previouslySelectedDate;
    if (_dobController.text.isNotEmpty) {
      previouslySelectedDate =
          DateFormat('dd/MM/yyyy').parse(_dobController.text);
    }

    DateTime initialYearPickerDate = previouslySelectedDate ?? eighteenYearsAgo;

    int? selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Year"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: YearPicker(
              firstDate: firstAllowedDate,
              lastDate: eighteenYearsAgo,
              initialDate: initialYearPickerDate,
              selectedDate: initialYearPickerDate,
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime.year);
              },
            ),
          ),
        );
      },
    );

    if (selectedYear != null) {
      DateTime initialDate = DateTime(selectedYear,
          previouslySelectedDate?.month ?? 1, previouslySelectedDate?.day ?? 1);

      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(selectedYear, 1, 1),
        lastDate: DateTime(selectedYear, 12, 31),
        helpText: "Select Month and Date",
      );

      if (selectedDate != null) {
        int age = currentDate.year - selectedDate.year;
        if (age >= 18 && age <= 80) {
          setState(() {
            _dobController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
            _ageController.text = age.toString();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Age must be at least 18 years old!"),
            ),
          );
        }
      }
    }
  }

  void _registerUser() async {
    try {
      if (_formkey.currentState?.validate() ?? false) {
        print("Validation Passed! Proceeding to register/update user.");

        final user = User(
          id: widget.user?.id,
          userName: _fullNameController.text,
          city: _cityController.text,
          state: _stateController.text,
          email: _emailController.text,
          mobileNumber: _mobileController.text,
          dateOfBirth: _dobController.text,
          gender: selectedGender,
          age: _ageController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          address: _addressController.text,
        );

        print("User data: ${user.toMap()}");

        int result;
        if (widget.user != null) {
          // Update existing user
          result = await MyDB().updateUser(user);
          if (result > 0) {
            print("User updated successfully with ID: $result");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User updated Successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            print("User update failed. No rows affected.");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update user.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Insert new user
          result = await MyDB().insertUser(user);
          if (result > 0) {
            print("User inserted successfully with ID: $result");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User added Successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            print("User insertion failed. No rows affected.");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add user.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }

        // Navigate to HomeScreen after successful registration/update
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print("Validation Failed!");
      }
    } catch (e) {
      print("Error inserting/updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetForm() {
    _formkey.currentState?.reset(); // Reset the form first

    setState(() {
      _fullNameController.text = "";
      _emailController.text = "";
      _mobileController.text = "";
      _dobController.text = "";
      _cityController.text = "";
      _stateController.text = "";
      _passwordController.text = "";
      _confirmPasswordController.text = "";

      selectedGender = 'Male';
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      _fullNameController.text = widget.user!.userName;
      _emailController.text = widget.user!.email;
      _mobileController.text = widget.user!.mobileNumber;
      _dobController.text = widget.user!.dateOfBirth;
      _ageController.text = widget.user!.age;
      _cityController.text = widget.user!.city;
      _stateController.text = widget.user!.state;
      _passwordController.text = widget.user!.password;
      _confirmPasswordController.text = widget.user!.confirmPassword;
      _addressController.text = widget.user!.address;
      selectedGender = widget.user!.gender;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.user != null;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(screenWidth * 0.1),
            bottomRight: Radius.circular(screenWidth * 0.1),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Registration',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.07,
            fontFamily: 'MyCustomFont',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            shadowColor: Colors.deepPurple.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ---------------------
                    // Full Name Field
                    // ---------------------
                    TextFormField(
                      controller: _fullNameController,
                      validator: _validateFullName,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Full Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                        CapitalizeEachWordFormatter(),
                      ],
                      textCapitalization: TextCapitalization.words,
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    // ---------------------
                    // Email Field
                    // ---------------------
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Email',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    // ---------------------
                    // Address Field
                    // ---------------------
                    TextFormField(
                      controller: _addressController,
                      validator: _validateAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.home,
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Address',
                        fillColor: Colors.white,
                        alignLabelWithHint: false,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      maxLines: 3,
                      maxLength: 100,
                      keyboardType: TextInputType.streetAddress,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    // ---------------------
                    // Date Of Birth Field
                    // ---------------------
                    TextFormField(
                      validator: _validateDob,
                      controller: _dobController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Date of Birth",
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.deepPurple,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      onTap: () => _selectedDate(context),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    // ---------------------
                    // Age Field
                    // ---------------------
                    TextFormField(
                      controller: _ageController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Age',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    // ---------------------
                    // Mobile Phone Field
                    // ---------------------
                    TextFormField(
                      controller: _mobileController,
                      validator: _validatePhone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Mobile',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    TextFormField(
                      controller: _stateController,
                      validator: _validateState,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.deepPurple,
                        ),
                        hintText: 'State',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    TextFormField(
                      controller: _cityController,
                      validator: _validateCity,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.deepPurple,
                        ),
                        hintText: 'City',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GenderButton(
                            gender: 'Male',
                            isSelected: selectedGender == 'Male',
                            onTap: () {
                              setState(() {
                                selectedGender = 'Male';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Expanded(
                          child: GenderButton(
                            gender: 'Female',
                            isSelected: selectedGender == 'Female',
                            onTap: () {
                              setState(() {
                                selectedGender = 'Female';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Expanded(
                          child: GenderButton(
                            gender: 'Other',
                            isSelected: selectedGender == 'Other',
                            onTap: () {
                              setState(() {
                                selectedGender = 'Other';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    // ---------------------
                    // Password Field
                    // ---------------------
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      validator: _validatePassword,
                      maxLength: 16,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Password',
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.deepPurple,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    // ---------------------
                    // Confirm Password Field
                    // ---------------------
                    TextFormField(
                      obscureText: !_isConfirmPasswordVisible,
                      validator: _validateConfirmPassword,
                      maxLength: 16,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Confirm Password',
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.deepPurple,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white, // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                ),
                              ),
                              onPressed: _registerUser,
                              child: Text(
                                isEditing ? 'Edit' : 'Register',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white, // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                ),
                              ),
                              onPressed: _resetForm,
                              // Assuming you have a reset function
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
          ),
        ),
      ),
    );
  }
  String? _validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'State is required';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? _validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date Of Birth is required';
    }
    return null;
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

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}

class GenderButton extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderButton({
    super.key,
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurple),
        ),
        alignment: Alignment.center,
        child: Text(
          gender,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class CapitalizeEachWordFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = newValue.text
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
