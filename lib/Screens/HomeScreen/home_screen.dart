import 'package:flutter/material.dart';

import '../AboutUsScreen/about_us_screen.dart';
import '../AllUserScreen/all_user_screen.dart';
import '../FavoriteScreen/favorite_users_screen.dart';
import '../RegisterScreen/register_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFC466B), Color(0xFF3F5EFB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Find Your Forever Match',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.03,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                    children: [
                      DashboardItem(
                        icon: Icons.person_add,
                        label: 'Add Profile',
                        color: Colors.pinkAccent,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterUserScreen()),
                            (route) => false,
                          );
                        },
                      ),
                      DashboardItem(
                        icon: Icons.group,
                        label: 'Browse Profiles',
                        color: Colors.deepPurpleAccent,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AllUserScreen()),
                                  (route) => false);
                        },
                      ),
                      DashboardItem(
                        icon: Icons.favorite,
                        label: 'Favorites',
                        color: Colors.redAccent,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FavoriteUsersScreen()),
                                  (route) => false);
                        },
                      ),
                      DashboardItem(
                        icon: Icons.info,
                        label: 'About Us',
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AboutUsScreen()),
                                (route) => false,
                          );
                        },
                      ),
                    ],
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

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DashboardItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> dashboardItems = [
  {
    'icon': Icons.person_add,
    'label': 'Add Profile',
    'color': Colors.pinkAccent,
  },
  {
    'icon': Icons.group,
    'label': 'Browse Profiles',
    'color': Colors.deepPurpleAccent,
  },
  {
    'icon': Icons.favorite,
    'label': 'Favorites',
    'color': Colors.redAccent,
  },
  {
    'icon': Icons.info,
    'label': 'About Us',
    'color': Colors.blueAccent,
  },
];
