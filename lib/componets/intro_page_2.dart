import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:login_page/providers/coaches_data.dart';

class IntroPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[100],
      child: Stack(
        children: [
        Center(
            child: Image.asset(
              'lib/images/gif2.gif',
              width: MediaQuery.of(context).size.width,
            ),
          ),
          const Positioned(
            top: 165,
            left: 0,
            right: 0,
            child: Text(
              'Help your clients achieve their goals\n by providing them with appropriate\n workouts and sessions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
