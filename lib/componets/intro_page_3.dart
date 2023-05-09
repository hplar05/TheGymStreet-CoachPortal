import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Stack(
        children: [
        Center(
            child: Image.asset(
              'lib/images/3.gif',
              width: MediaQuery.of(context).size.width,
            ),
          ),
          const Positioned(
            top: 150, // Adjust the position as needed
            left: 0,
            right: 0,
            child: Text(
              'Start Your Fitness Coach\n Journey Today!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
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
