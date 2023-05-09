import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:login_page/pages/homepage.dart';
import 'package:login_page/providers/coaches_data.dart';
import 'package:login_page/componets/my_button.dart';
import 'package:login_page/componets/my_textfield.dart';
import 'package:login_page/componets/onboarding_screen.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dio = Dio();
  

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void coachLogin(String email, password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      var response = await dio.post(
          'https://sbit3j-service.onrender.com/v1/coach/auth/login',
          data: formData);

      if (response.statusCode == 200) {
        var data = response.data;

        context.read<Coach>().storeProfile(
            data['access']['token'],
            data['data']['id'],
            data['data']['firstName'],
            data['data']['middleName'],
            data['data']['lastName'],
            data['data']['gender'],
            data['data']['phone'],
            data['data']['email']);

        // ignore: use_build_context_synchronously
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>const HomePage(),
          ),
        );
      } else {}
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wrong Email and Password'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004aad),
        automaticallyImplyLeading: false,
        elevation: 0.0, // Set elevation to 0.0 to remove the shadow
      ),
      backgroundColor: const Color(0xFF004aad),
      // Rest of your scaffold content
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 90),

              // logo
              Image.asset(
                'lib/images/logo.png',
                height: 150.0,
                width: 400.0,
              ),

              const SizedBox(height: 30),

              const Text(
                "All progress takes place outside \n the comfort zone. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 30),

              // username textfield
              MyTextField(
                controller: emailController,
                hinText: 'Enter Email',
                obscureText: false,
              ),

              const SizedBox(height: 15),

              // password textfield
              MyTextField(
                controller: passwordController,
                hinText: 'Enter Password',
                obscureText: true,
              ),

              const SizedBox(height: 40),

              // sign in button
              Stack(
                alignment: Alignment.center,
                children: [
                  MyButton(
                    onTap: () {
                      if (emailController.text.trim().isEmpty ||
                          passwordController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please fill up all fields'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {},
                            ),
                          ),
                        );
                      } else {
// Call login function
                        coachLogin(emailController.text.trim(),
                            passwordController.text.trim());
                      }
                    },
                    text: 'Sign In',
                  ),
                ],
              ),
              const SizedBox(height: 75),
              _isLoading
                  ? const CircularProgressIndicator() // Show progress indicator while logging in
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}


