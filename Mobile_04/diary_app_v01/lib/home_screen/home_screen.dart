import 'package:diary_app/calendar_screen/calendar_screen.dart';
import 'package:diary_app/home_screen/home_content.dart/home_content.dart';
import 'package:diary_app/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeContent(),
    CalendarScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(76, 177, 81, 1),
        body: Expanded(child: _screens[_currentIndex]),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: GNav(
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              haptic: true, // haptic feedback
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(
                  color: Colors.white, width: 1), // tab button border
              tabBorder: Border.all(
                  color: Colors.white60, width: 1), // tab button border
              tabShadow: [
                BoxShadow(
                    color: Color.fromRGBO(76, 177, 81, 0.5), blurRadius: 8)
              ], // tab button shadow
              gap: 6, // the tab button gap between icon and text
              color: Colors.white70, // unselected icon color
              activeColor: Colors.white, // selected icon and text color
              iconSize: 25, // tab button icon size
              // tabBackgroundColor:
              //     Colors.purple.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(
                  horizontal: 25, vertical: 10), // navigation bar padding
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.calendar_month,
                  text: 'Calendar',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                )
              ]),
        ),
      ),
    );
  }
}
