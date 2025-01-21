import 'package:crud/utils/string_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserEntryFromPage extends StatefulWidget {
  Map<String, dynamic>? userDetail;

  UserEntryFromPage({super.key, this.userDetail});

  @override
  State<UserEntryFromPage> createState() => _UserEntryFormPageState();

}

class _UserEntryFormPageState extends State<UserEntryFromPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

  List<String> cities = ['Ahmedabad', 'Surat', 'Rajkot', 'Vadodara'];
  String? selectedCity;

  int findIndex(List<String> cities, selectedCity) {
    for (int i = 0; i < cities.length; i++) {
      if (selectedCity.toString().toLowerCase() ==
          cities[i].toString().toLowerCase()) {
        return i;
      }
    }
    return 0;
  }
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('DATA TO SENT :: ${widget.userDetail}');
    }
    if (widget.userDetail != null) {
      nameController.text = widget.userDetail![NAME].toString();
      emailController.text = widget.userDetail![EMAIL].toString();
      phoneController.text = widget.userDetail![PHONE].toString();
        if (kDebugMode) {
          print(
            'NAME ::: ${nameController.text} :: EMAIl ::: ${emailController.text}');
        }
    }
    selectedCity = widget.userDetail != null
        ? cities[findIndex(cities, widget.userDetail![CITY])]
        : cities[0];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          widget.userDetail == null ? 'Register User' : 'Edit User',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Valid Name';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    labelText: 'Enter your name',
                    labelStyle: TextStyle(color: Colors.red),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.close,
                        size: 16,
                      ),
                    ),
                    fillColor: Colors.red,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Email Address';
                    }
                    if (!RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value)) {
                      return 'Enter Valid Email address';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[A-Z]'))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Phone Number';
                    }
                    if (value.length != 10) {
                      return 'Enter Valid Phone Number';
                    }
                    return null;
                  },
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButton(
                  value: selectedCity,
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Map<String, dynamic> map = {};
                    map[NAME] = nameController.text.toString();
                    map[EMAIL] = emailController.text.toString();
                    map[PHONE] = phoneController.text.toString();
                    map[CITY] = selectedCity.toString();
                    Navigator.pop(context, map);

                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return CupertinoAlertDialog(
                    //       title: Text('Delete'),
                    //       content: Text('Are you sure want to save?'),
                    //       actions: [
                    //         TextButton(onPressed: () {}, child: Text('yes')),
                    //         TextButton(onPressed: () {}, child: Text('no')),
                    //       ],
                    //     );
                    //   },
                    // );
                  },
                  child: Text(
                    widget.userDetail == null ? 'Submit' : 'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}