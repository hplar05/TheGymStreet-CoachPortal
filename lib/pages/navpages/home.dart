import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:login_page/providers/coaches_data.dart';
import 'package:provider/provider.dart';
import '../../providers/clients_data.dart';

class CoachHome extends StatefulWidget {
  const CoachHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CoachHomeState createState() => _CoachHomeState();
}

class _CoachHomeState extends State<CoachHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Column(children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF004aad), Color(0xFF2f7eb8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(70),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 17),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hi, ${context.watch<Coach>().fname} ${context.watch<Coach>().mname} ${context.watch<Coach>().lname}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        radius: 53,
                        backgroundColor: Color.fromARGB(255, 181, 48, 4),
                        child: Text(
                          '${context.watch<Coach>().fname.substring(0, 1)}${context.watch<Coach>().lname.substring(0, 1)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Coach Dashboard',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 55),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                ),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                childAspectRatio: 1.3,
                children: [
                  _buildDashboardItem(
                    'Total Clients',
                    '3',
                    Icons.person_outline,
                    const Color(0xFF004aad),
                  ),
                  _buildDashboardItem(
                    'Workouts',
                    '18',
                    Icons.fitness_center,
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10), // Move text up by changing the height
                  Text(
                    'Clients Feedbacks',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'I enjoyed the workout session',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'I enjoyed the workout session',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'I enjoyed the workout session',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ]));
  }

  Widget _buildDashboardItem(
    String title,
    String subtitle,
    IconData iconData,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            // Wrap the Text widget with Center
            child: Text(
              subtitle,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 50,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
