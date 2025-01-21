import 'package:crud/abc/user.dart';
import 'package:crud/design/add_edit/user_entry_form.dart';
import 'package:crud/utils/string_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPage();
}

class _UserListPage extends State<UserListPage> {
  final User _user = User();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredUsers = [];
  bool isGrid = false;

  @override
  void initState() {
    super.initState();
    _filteredUsers = _user.userList; // Initially show all users
    _searchController.addListener(() {
      _filterUsers(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredUsers = _user.userList;
      });
    } else {
      setState(() {
        _filteredUsers = _user.userList
            .where((user) =>
        user[NAME].toLowerCase().contains(query.toLowerCase()) ||
            user[EMAIL].toLowerCase().contains(query.toLowerCase()) ||
            user[CITY].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'User List',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isGrid = false;
                });
              },
              icon: const Icon(
                Icons.list,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  isGrid = true;
                });
              },
              icon: const Icon(
                Icons.grid_3x3,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UserEntryFromPage();
                  },
                )).then((value) {
                  if (value != null) {
                    _user.userList.add(value);
                    _filterUsers(_searchController.text); // Update filtered list
                  }
                });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          _filteredUsers.isEmpty
              ? const Expanded(
            child: Center(
                child: Text(
                  'No User Found',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                )),
          )
              : (isGrid
              ? Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                return getListGridItem(index);
              },
              itemCount: _filteredUsers.length,
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return getListGridItem(index);
              },
              itemCount: _filteredUsers.length,
            ),
          )),
        ],
      ),
    );
  }

  Widget getListGridItem(int i) {
    final user = _filteredUsers[i];
    return Card(
      elevation: 10,
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return UserEntryFromPage(
                userDetail: user,
              );
            },
          )).then((value) {
            if (value != null) {
              _user.updateUser(
                name: value[NAME],
                email: value[EMAIL],
                phoneNumber: value[PHONE],
                id: _user.userList.indexOf(user),
                city: value[CITY],
              );
              _filterUsers(_searchController.text); // Update filtered list
            }
          });
        },
        leading: Image.asset('assets/images/User.png'),
        trailing: Wrap(
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('DELETE'),
                      content: const Text('Are you sure you want to delete?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _user.deleteUser(_user.userList.indexOf(user));
                            _filterUsers(_searchController.text); // Update filtered list
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 25,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
        title: Wrap(
          direction: Axis.vertical,
          children: [
            Text(
              '${user[NAME]}',
              style: const TextStyle(fontSize: 25, color: Colors.black),
            ),
            Text(
              '${user[CITY]} | ${user[EMAIL]}',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
