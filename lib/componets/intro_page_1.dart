import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_page/providers/coaches_data.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100],
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'lib/images/gif1.gif',
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 1,
            ),
          ),
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Consumer<Coach>(
              builder: (context, coach, _) {
                return const Text(
                  'Welcome to the GYM STREET\nFitness Coach App!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
