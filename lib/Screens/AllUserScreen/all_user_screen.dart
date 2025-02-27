import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Database/database_helper.dart';
import '../../Models/user.dart';
import '../HomeScreen/home_screen.dart';
import '../RegisterScreen/register_user_screen.dart';
import '../UsersDetailsScreen/user_detail_screen.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  final MyDB _dbHelper = MyDB();
  List<User> _users = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  /// *Toggle Favorite Status*
  Future<void> _toggleFavorite(User user) async {
    user.isFavorite = user.isFavorite == 1 ? 0 : 1;
    await _dbHelper.updateUser(user);
    _fetchUsers();
  }

  /// *Block (Delete) User*
  Future<void> _blockUser(int userId) async {
    await _dbHelper.deleteUser(userId);
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    List<User> users = await _dbHelper.getAllUsers();
    setState(() {
      _users = List.from(users);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(screenWidth * 0.1),
            bottomLeft: Radius.circular(screenWidth * 0.1),
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
          "All Users",
          style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              fontFamily: 'MyCustomFont'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: CupertinoSearchTextField(
              placeholder: "Search users...",
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _users.isEmpty
                ? Center(child: Text("No Users Found"))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      User user = _users[index];
                      if (_searchQuery.isNotEmpty &&
                          !user.userName
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase())) {
                        return SizedBox.shrink();
                      }
                      return UserCard(
                        user: user,
                        onFavoriteToggle: () => _toggleFavorite(user),
                        onBlock: () => _blockUser(user.id!),
                        userName: user.userName,
                        age: user.age,
                        city: user.city,
                        state: user.state,
                        isFavorite: user.isFavorite == 1,
                        mobileNumber: user.mobileNumber,
                        email: user.email,
                      );
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterUserScreen(),
            ),
          );
          _fetchUsers();
        },
        icon: Icon(Icons.add),
        label: Text('Add User'),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String userName;
  final String age;
  final String city;
  final String mobileNumber;
  final String state;
  final String email;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBlock;
  final User user;

  const UserCard({
    super.key,
    required this.userName,
    required this.age,
    required this.city,
    required this.state,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onBlock,
    required this.mobileNumber,
    required this.email,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailScreen(user: user),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.purpleAccent[100],
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$age years',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterUserScreen(
                                user: user), // Pass user to edit
                          ),
                        ).then((_) {
                          // Refresh users after editing
                          (context as Element).markNeedsBuild();
                        });
                        if (kDebugMode) {
                          print("Edit user");
                        }
                      } else if (value == 'delete') {
                        // Show Cupertino Alert Dialog for confirmation
                        _showDeleteDialog(context, onBlock);
                        // Call the onBlock function passed from AllUserScreen
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(height: 30, thickness: 1),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.yellow, size: 20),
                  SizedBox(width: 8),
                  Text('$state $city', style: TextStyle(fontSize: 14)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(mobileNumber, style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.purpleAccent, size: 20),
                  SizedBox(width: 8),
                  Text(email, style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, VoidCallback onDelete) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            CupertinoDialogAction(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: Text("Delete", style: TextStyle(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }
}