import 'package:flutter/material.dart';

class FavoriteUsersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favouriteList;

  const FavoriteUsersScreen({super.key, required this.favouriteList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Users"),
        centerTitle: true,
      ),
      body: favouriteList.isEmpty
          ? const Center(child: Text('No Favourite Users'))
          : ListView.builder(
        itemCount: favouriteList.length,
        itemBuilder: (context, index) {
          var user = favouriteList[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(child: Text(user["Name"][0])),
              title: Text(user["Name"]),
              subtitle: Text("Email: ${user["Email"]}"),
            ),
          );
        },
      ),
    );
  }
}

