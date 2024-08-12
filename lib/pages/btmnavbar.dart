import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketit/pages/approvepage.dart';
import 'package:marketit/pages/homepage.dart';
import 'package:marketit/pages/messagespage.dart';
import 'package:marketit/pages/notificationspage.dart';
import 'package:marketit/pages/profilepage.dart';
import 'package:marketit/pages/savedpage.dart';
import 'package:marketit/pages/sell_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late final User? currentUser;
  int _currentPage = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    initializeCurrentUser();
    _initializePages();
  }

  void initializeCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void _initializePages() {
    _pages = [
      const HomePage(),
      SavedPage(),
      const SellPage(),
    AdminApprovalPage(),
      NotificationPage(),
          const ProfilePage()
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              //color: Colors.orange,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite ),
            label: 'saved',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add,
            //    color: Colors.orange
            ),
            label: 'sell',
          ),
            BottomNavigationBarItem(
             icon: Icon(Icons.admin_panel_settings, ),
              label: 'admin',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, ),
            label: 'notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person,
            //    color: Colors.orange
            ),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
