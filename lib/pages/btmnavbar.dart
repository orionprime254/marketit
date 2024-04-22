import 'package:flutter/material.dart';
import 'package:marketit/pages/savedpage.dart';
import 'package:marketit/pages/sell_page.dart';

import 'homepage.dart';
import 'messagespage.dart';
import 'notificationspage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    HomePage(),
    SavedPage(),
    SellPage(),
    NotificationPage(),
    MessagePage()

  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar:
      BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: _onTabTapped,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.orange,
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.orange), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.orange), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.orange),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.message_sharp, color: Colors.orange),
            label: ''),
        //  BottomNavigationBarItem(icon: Icon(Icons.person,color: Colors.orange), label: ''),
      ],
    )
    ,
    );
  }
}
