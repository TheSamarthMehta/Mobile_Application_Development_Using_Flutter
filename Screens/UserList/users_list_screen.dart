import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foreverbandhan/Screens/AddUser/add_user_screen.dart';


class UsersListScreen extends StatefulWidget {
  List<Map<String, dynamic>> userList;
  // final VoidCallback onFavouriteToggle; // Callback to update favorites in Dashboard

  UsersListScreen({super.key, required this.userList,});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();

}

class _UsersListScreenState extends State<UsersListScreen> {
  late List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> favouriteUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    users = widget.userList;
    filteredUsers = users;
    searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users
          .where((user) =>
          user["Name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToAddUserScreen(
      {Map<String, dynamic>? user, int? index}) async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUserScreen(
          userList: widget.userList,
          user: user,
          index: index,
        ),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        if (index != null) {
          users[index] = updatedUser; // Update existing user
        } else {
          users.add(updatedUser); // Add new user
        }
        _filterUsers();
      });
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      widget.userList[index]['isFavorite'] = !(widget.userList[index]['isFavorite'] ?? false);
      // widget.onFavouriteToggle(); // ✅ Update Dashboard favorite list

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.userList[index]['isFavorite']
            ? "Added to Favourites Successfully!"
            : "Removed from Favourites!"),
        duration: Duration(milliseconds: 300),
      ));
      _filterUsers();
    });
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
      _filterUsers();
      // widget.onFavouriteToggle(); // ✅ Ensure removal updates Dashboard favorite list
    });
  }

  void _showUserDialog(Map<String, dynamic> user, int index) {
    showAboutDialog(
      context: context,
      applicationIcon: CircleAvatar(
        radius: 30,
        child: Text(user["Name"][0], style: TextStyle(fontSize: 24)),
      ),
      applicationName: user["Name"],
      applicationVersion: "User Details",
      children: [
        Text("📧 Email: ${user["Email"]}", style: TextStyle(fontSize: 16)),
        Text("📞 Phone: ${user["Phone"]}", style: TextStyle(fontSize: 16)),
        Text("🎂 Age: ${user["Age"]}", style: TextStyle(fontSize: 16)),
        Text("🏙 City: ${user["City"]}", style: TextStyle(fontSize: 16)),
        Text("⚥ Gender: ${user["Gender"]}", style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToAddUserScreen(user: user, index: index);
            },
            child: Text("Edit", style: TextStyle(fontSize: 16, color: Colors.blue)),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User List"),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search User',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: filteredUsers.isEmpty
                  ? const Center(
                child: Text("No User Found"),
              )
                  : ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  var user = filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.all(5),
                    elevation: 5,
                    child: ListTile(
                      onTap: () => _showUserDialog(user, index),
                      leading: CircleAvatar(child: Text(user["Name"][0])),
                      title: Text(user["Name"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${user["Name"]}"),
                          Text("Phone: ${user["Phone"]}"),
                          Text("Age: ${user["Age"]}"),
                          Text("City: ${user["City"]}"),
                          Text("Gender: ${user["Gender"]}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              user['isFavorite'] == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: user['isFavorite'] ?? false
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () => _toggleFavorite(index),
                          ),
                          IconButton(
                            icon:
                            const Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('DELETE'),
                                      content: const Text(
                                          'Are you sure you want to delete?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteUser(index);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No'),
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _navigateToAddUserScreen(),
        //   child: const Icon(Icons.add),
        // ),
        );
    }
}
