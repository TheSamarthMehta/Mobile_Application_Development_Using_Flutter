import 'package:flutter/material.dart';

import '../../Database/database_helper.dart';
import '../../Models/user.dart';
import '../HomeScreen/home_screen.dart';

class FavoriteUsersScreen extends StatefulWidget {
  const FavoriteUsersScreen({super.key});

  @override
  State<FavoriteUsersScreen> createState() => _FavoriteUsersScreenState();
}

class _FavoriteUsersScreenState extends State<FavoriteUsersScreen> {
  List<User> favouriteUsers = [];

  @override
  void initState() {
    super.initState();
    _loadFavouriteUsers();
  }

  Future<void> _loadFavouriteUsers() async {
    final users = await MyDB().getFavouriteUsers(); // Fetch favorite users
    setState(() {
      favouriteUsers = users;
    });
  }

  Future<void> _toggleFavorite(User user) async {
    int newFavStatus = user.isFavorite == 1 ? 0 : 1; // Toggle between 1 and 0
    await MyDB().toggleFavorite(user.id!, newFavStatus);
    _loadFavouriteUsers(); // Refresh list after update
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
          "Favorite Users",
          style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              fontFamily: 'MyCustomFont'),
        ),
      ),
      body: favouriteUsers.isEmpty
          ? Center(
              child: Text('No Favorite User Found'),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: favouriteUsers.length,
              itemBuilder: (context, index) {
                final user = favouriteUsers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple[50],
                      child: Icon(
                        Icons.person,
                        color: Colors.deepPurple,
                        size: 30,
                      ),
                    ),
                    title: Text(user.userName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: IconButton(
                        onPressed: () => _toggleFavorite(user),
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                          size: 28,
                        )),
                  ),
                );
              }),
    );
  }
}
