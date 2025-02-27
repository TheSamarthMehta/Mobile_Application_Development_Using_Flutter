import 'package:flutter/material.dart';
import 'package:matrimony_project/Screens/AllUserScreen/all_user_screen.dart';
import '../../Models/user.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(screenWidth * 0.1),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AllUserScreen()),
                (route) => false,
          ),
        ),
        backgroundColor: Colors.black,
        title: Text(
          "User Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
            fontFamily: 'MyCustomFont'
          ),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
              child: Icon(Icons.person, color: Colors.deepPurple, size: 50),
            ),
            SizedBox(height: 15),
            Text(
              widget.user.userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(Icons.edit, Colors.blue, () {
                  // Handle Edit
                }),
                SizedBox(width: 15), // Adjust spacing
                _buildIconButton(Icons.delete, Colors.red, () {
                  // Handle Delete
                }),
                SizedBox(width: 15),
                _buildIconButton(
                  widget.user.isFavorite == 1
                      ? Icons.favorite
                      : Icons.favorite_border,
                  Colors.red,
                  () {
                    // Handle Favorite Toggle
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildInfoCard("About", [
              _buildInfoRow("Name", widget.user.userName),
              _buildInfoRow("Gender", widget.user.gender),
              _buildInfoRow("Date of Birth", widget.user.dateOfBirth),
            ]),
            _buildInfoCard("Address Details", [
              _buildInfoRow("Address", widget.user.address),
              _buildInfoRow("City", widget.user.city),
              _buildInfoRow("State", widget.user.state),
            ]),
            _buildInfoCard("Contact Details", [
              _buildInfoRow("Mobile", widget.user.mobileNumber),
              _buildInfoRow("Email", widget.user.email),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent)),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}


Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 50, // Fixed width for uniformity
      height: 50, // Fixed height for square shape
      decoration: BoxDecoration(
        color: color.withOpacity(0.15), // Soft background color
        shape: BoxShape.circle, // Keep circular shape
        // Removed borderRadius since it conflicts with BoxShape.circle
      ),
      child: Center(
        child: Icon(icon, color: color, size: 28), // Properly aligned icon
      ),
    ),
  );
}

