import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ApiService apiService = ApiService();
  late Future<List<User>> users;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  int? selectedUserId;

  @override
  void initState() {
    super.initState();
    users = apiService.fetchUsers();
  }

  void refreshUsers() {
    setState(() {
      users = apiService.fetchUsers();
    });
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    selectedUserId = null;
  }

  void submitUser() {
    final String name = nameController.text;
    final String email = emailController.text;

    if (name.isNotEmpty && email.isNotEmpty) {
      if (selectedUserId == null) {
        apiService.createUser(User(name: name, email: email)).then((_) => refreshUsers());
      } else {
        apiService.updateUser(selectedUserId!, User(name: name, email: email)).then((_) => refreshUsers());
      }
      clearFields();
    }
  }

  void editUser(User user) {
    setState(() {
      selectedUserId = user.id;
      nameController.text = user.name;
      emailController.text = user.email;
    });
  }

  void deleteUser(int id) {
    apiService.deleteUser(id).then((_) => refreshUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Fields
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitUser,
              child: Text(selectedUserId == null ? 'Create User' : 'Update User'),
            ),
            const SizedBox(height: 20),

            // User List
            Expanded(
              child: FutureBuilder<List<User>>(
                future: users,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data![index];
                        return ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => editUser(user),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteUser(user.id!),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
