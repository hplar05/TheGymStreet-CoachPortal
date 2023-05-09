import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_page/componets/exitdialog.dart';
import 'package:login_page/componets/onboarding_screen.dart';
import 'package:login_page/componets/splash_screen.dart';
import 'package:login_page/providers/clients_data.dart';
import 'package:login_page/providers/coaches_data.dart';
import 'package:login_page/providers/session_data.dart';
import 'pages/login_page.dart';
import 'package:login_page/pages/homepage.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Coach()),
        ChangeNotifierProvider(create: (_) => Client()),
        ChangeNotifierProvider(create: (_) => Session()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coach Subsystem App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnBoardingScreen(),
    );
  }
}
