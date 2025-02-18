import 'package:flutter/material.dart';
import 'package:shaadi_app/Screens/about_us_screen.dart';
import 'package:shaadi_app/Screens/AllUserScreen/all_user_screen.dart';
import 'package:shaadi_app/Screens/FavoriteScreen/favorite_users_screen.dart';
import 'package:shaadi_app/Screens/RegisterScreen/register_user_screen.dart';

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
            colors: [Colors.orangeAccent, Colors.orange],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: screenHeight * 0.02,
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.05,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.1),
                      topRight: Radius.circular(screenWidth * 0.1),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Find Your Forever match with us',
                            style: TextStyle(
                              fontFamily: 'MyCustomFont',
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Expanded(
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                          Text('Navigating to Add Profile'),
                                          duration: Duration(milliseconds: 500),
                                        ),
                                      );
                                      Future.delayed(
                                          Duration(milliseconds: 300), () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RegisterUserScreen()),
                                        );
                                      });
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
                                ]),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                        ],
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 15),
            Text(
              label,
              style: const TextStyle(
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