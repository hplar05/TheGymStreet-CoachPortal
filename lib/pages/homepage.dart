import 'package:flutter/material.dart';
import 'package:login_page/pages/navpages/account.dart';
import 'package:login_page/pages/navpages/clients.dart';
import 'package:login_page/pages/navpages/home.dart';
import 'package:login_page/pages/navpages/workoutlib.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // ignore: unused_element
  void _navigateBottomBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    const CoachHome(),
    const CoachClients(),
    const CoachWorkoutlib(),
    const CoachAccount(),
  ];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF004aad),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: const Color(0xFF004aad),
          unselectedItemColor: Colors.white,
          elevation: 0.0,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Icon(Icons.home),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: _currentIndex == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Icon(Icons.people),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Icon(Icons.fitness_center),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: _currentIndex == 3 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Icon(Icons.person),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}