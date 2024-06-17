import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_api_app/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  });
}
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    // final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/splash_pic.jpg',
              fit: BoxFit.cover,
              // width: width*0.9,
              height: height * 0.5,
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              'Top Headlines',
              style: GoogleFonts.montserrat(
                  letterSpacing: .4,
                  color: Color.fromARGB(255, 96, 99, 134),
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            const SpinKitChasingDots(
              color: Colors.blue,
              size: 45,
            ),
          ],
        ),
      ),
    );
  }
}
