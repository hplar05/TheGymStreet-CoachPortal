import 'package:flutter/material.dart';
import 'package:login_page/componets/splash_screen.dart';
import 'package:login_page/providers/coaches_data.dart';
import 'package:provider/provider.dart';

class CoachAccount extends StatefulWidget {
  const CoachAccount({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CoachAccountState createState() => _CoachAccountState();
}

class _CoachAccountState extends State<CoachAccount> {
  final double coverHeight = 280;
  final double profileHeight = 144;
  void logout() {
    // Call clearProfile() when logging out

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          content: const SizedBox(
            height: 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Perform logout action here
                Provider.of<Coach>(context, listen: false).clearProfile();
                // Clear user session data
                // Redirect user to login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
          buildAbout(),
          buildAboutbody(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.asset(
          'lib/images/profilec.png',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

 Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: const AssetImage("lib/images/coach.png"),
      );

  Widget buildContent() => Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            context.watch<Coach>().email,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'The Gym Street Coach',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFacebookIcon(Icons.facebook_sharp),
              const SizedBox(
                width: 8,
              ),
              buildSettingsIcon(Icons.phone_callback),
              const SizedBox(
                width: 8,
              ),
              buildLogoutIcon(Icons.exit_to_app_outlined),
              const SizedBox(
                width: 0,
              ),
            ],
          ),
        ],
      );

  Widget buildAbout() => Column(
        children: <Widget>[
          const SizedBox(
            height: 65,
          ),
          Align(
            alignment: Alignment.centerLeft,
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: const Text(
                " About",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const SizedBox(height: 0),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 3,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      );

  Widget buildAboutbody() => Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.center,
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: const Text(
                " A fitness coach works as a personal trainer \nto help clients lose weight, gain muscle, and \naccomplish other fitness goals.",
                style: TextStyle(fontSize: 21),
              ),
            ),
          ),
        ],
      );

  Widget buildFacebookIcon(IconData icon) => CircleAvatar(
        radius: 23,
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(child: Icon(icon, size: 30)),
          ),
        ),
      );
  Widget buildSettingsIcon(IconData icon) => CircleAvatar(
        radius: 23,
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(child: Icon(icon, size: 30)),
          ),
        ),
      );

  Widget buildLogoutIcon(IconData icon) => CircleAvatar(
        radius: 23,
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              logout();
            },
            child: Center(child: Icon(icon, size: 30)),
          ),
        ),
      );
}
