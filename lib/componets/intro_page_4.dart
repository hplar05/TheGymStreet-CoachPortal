import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'lib/images/gif4.gif',
              width: MediaQuery.of(context).size.width / 0,
              height: MediaQuery.of(context).size.height / 0,
            ),
          ),
          const Positioned(
            top: 110, // Adjust the position as needed
            left: 0,
            right: 0,
            child: Text(
              'Start Your Fitness Coach\n Journey Today!',
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
