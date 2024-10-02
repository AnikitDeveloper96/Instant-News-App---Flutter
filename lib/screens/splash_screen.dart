import 'package:flutter/material.dart';
import 'package:instantnews/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home/main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String splashscreen = "splashscreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSigningIn = false;

  _launchURL() async {
    Uri url = Uri.parse('https://in.linkedin.com/in/anikit-grover');
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, MainScreen.mainscreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF0D0821),
        body: Center(
          child: Image.asset('screenshots/splash_screen.png'),
        ));
  }
}
