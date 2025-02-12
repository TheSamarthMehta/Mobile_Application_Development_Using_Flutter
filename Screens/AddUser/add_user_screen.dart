import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foreverbandhan/DataBase/DatabaseHelper/database_helper.dart';
import 'package:foreverbandhan/Screens/Dashboard/dashboard_screen.dart';
import 'package:intl/intl.dart';

class AddUserScreen extends StatefulWidget {
  List<Map<String, dynamic>> userList;
  Map<String, dynamic>? user;
  int? index;

  AddUserScreen({super.key, required this.userList, this.user, this.index});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();
  final _casteController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      _nameController.text = widget.user!["Name"];
      _emailController.text = widget.user!["Email"];
      _phoneController.text = widget.user!["Phone"];
      _dobController.text = widget.user!["DOB"];
      _ageController.text = widget.user!["Age"];
      gender = widget.user!["Gender"];
      hobbies = List<String>.from(widget.user!["Hobbies"]);
      _cityController.text = widget.user!["City"];
      _casteController.text = widget.user!["Caste"];
      _passwordController.text = widget.user!["Password"];
      _confirmPasswordController.text = widget.user!["ConfirmPassword"];
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    _casteController.dispose();
    super.dispose();
  }

  //Gender Selection
  String gender = 'Male';

  // Hobbies Selection
  List<String> hobbies = [];
  List<String> availableHobbies = [
    "Reading",
    "Travelling",
    "Music",
    "Sports",
    "Dancing",
    "Sleeping/Napping ",
  ];

  String? ageErrorMessage; // For showing age validation error

  // Pick DOB and Calculate Age
  Future<void> _pickDateOfBirth(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      int age = DateTime.now().year - pickedDate.year;

      if (age >= 18) {
        setState(() {
          _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          _ageController.text = age.toString();
        });
      } else {
        //Show a dialog or snack bar for validation error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Age must be at least 18 years old!")),
        );
      }
    }
  }

  // Validate and Save User
  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      int age = int.tryParse(_ageController.text) ?? 0;
      if (age < 18) {
        setState(() {
          ageErrorMessage = "Age must be at least 20 years old!";
        });
        return;
      }

      Map<String, dynamic> userData = {
        "Name": _nameController.text,
        "Email": _emailController.text,
        "Phone": _phoneController.text,
        "DOB": _dobController.text,
        "Age": _ageController.text,
        "Gender": gender,
        "Hobbies": hobbies,
        "City": _cityController.text,
        "Caste": _casteController.text,
        "Password": _passwordController.text,
        "ConfirmPassword": _confirmPasswordController.text,
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.index != null
              ? "User Updated Successfully!"
              : "User Added Successfully!"),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 1),
        ),
      );
      Future.delayed(Duration(seconds: 1), () {
        if(widget.index != null) {
          widget.userList[widget.index!] = userData;
        } else {
          widget.userList.add(userData);
        }
        Navigator.pop(context, userData);
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!RegExp(r"[a-zA-Z\'s-]{3,50}$").hasMatch(value)) {
      return 'Please Enter Valid Full Name';
    }
    return null;
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
    if (value.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    for (int i = 0; i < value.length; i++) {
      if (value.codeUnitAt(i) < 48 || value.codeUnitAt(i) > 57) {
        // ASCII values for '0' and '9'
        return 'Phone number must contain only digits';
      }
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

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Update User' : 'Add User'),
        centerTitle: true,
      ),
      body: Card(
        margin: const EdgeInsets.all(10),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      validator: _validatePhone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Date of Birth",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickDateOfBirth(context),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _ageController,
                      readOnly: true,
                      decoration: InputDecoration(labelText: "Age"),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text("Gender: "),
                        Radio(
                          value: "Male",
                          groupValue: gender,
                          onChanged: (value) =>
                              setState(() => gender = value.toString()),
                        ),
                        Text("Male"),
                        Radio(
                          value: "Female",
                          groupValue: gender,
                          onChanged: (value) =>
                              setState(() => gender = value.toString()),
                        ),
                        Text("Female"),
                      ],
                    ),
                    Text("Hobbies:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: availableHobbies.map((hobby) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: hobbies.contains(hobby),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    hobbies.add(hobby);
                                  } else {
                                    hobbies.remove(hobby);
                                  }
                                });
                              },
                            ),
                            Text(hobby),
                          ],
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: "City",
                        suffixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _casteController,
                      decoration: InputDecoration(labelText: "Caste"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      obscureText: !_isPasswordVisible,
                      validator: _validatePassword,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          icon: Icon(_isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: _saveUser,
                      child: Text(isEditing ? 'Edit User' : 'Save User'),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
