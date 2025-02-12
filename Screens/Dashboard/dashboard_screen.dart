import 'package:flutter/material.dart';
import 'package:foreverbandhan/Screens/AboutUs/about_us_screen.dart';
import 'package:foreverbandhan/Screens/AddUser/add_user_screen.dart';
import 'package:foreverbandhan/Screens/FavoriteUser/favorite_users_screen.dart';
import 'package:foreverbandhan/Screens/UserList/users_list_screen.dart';

List<Map<String, dynamic>> userList = [];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<DashboardItem> items = [
    DashboardItem(
        title: 'Add Users',
        icon: Icons.person_add,
        screen: AddUserScreen(
          userList: userList,
        )),
    DashboardItem(
      title: 'Users List',
      icon: Icons.list,
      screen: UsersListScreen(userList: userList),
    ),
    DashboardItem(
        title: 'Favourite Users',
        icon: Icons.favorite,
        screen: FavoriteUsersScreen(favouriteList: [])),
    DashboardItem(
      title: 'About Us',
      icon: Icons.info,
      screen: AboutUsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.orange.shade200, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              alignment: WrapAlignment.center,
              children: items.map((item) => DashBoardCard(item: item)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class DashBoardCard extends StatefulWidget {
  final DashboardItem item;

  const DashBoardCard({super.key, required this.item});

  @override
  State<DashBoardCard> createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () async {
          await _controller.forward();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.item.screen),
          );
          _controller.reset();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            color: isHovered ? Colors.deepOrange.shade500 : Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: isHovered ? Colors.black : Colors.white,
              width: 3.0,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.orange.shade700.withOpacity(0.7),
                      blurRadius: 10.0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(widget.item.icon,
                    size: 40, color: isHovered ? Colors.white : Colors.black),
              ),
              SizedBox(height: 12.0),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  widget.item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: isHovered ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Widget screen;

  DashboardItem(
      {required this.title, required this.icon, required this.screen});
}
