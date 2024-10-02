import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../splash_screen.dart';
import 'foryou.dart';
import 'headlines.dart';

class MainScreen extends StatefulWidget {
  static const String mainscreen = "mainscreen";

  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final bool _isSigningOut = false;

  List<String> strings = ["For you", "Headlines"];
  List<IconData> icons = [
    Icons.yard_outlined,
    Icons.view_headline_sharp,
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SplashScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: RichText(
            text: TextSpan(
              text: 'Instant ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D0821),
                  fontSize: 24.0),
              children: <TextSpan>[
                TextSpan(
                    text: 'News',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0821),
                        fontSize: 24.0)),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: _selectedIndex == 0 ? ForYou() : Headlines(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.whiteColor,
          currentIndex: _selectedIndex,
          elevation: 0.1,
          iconSize: 30.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.blackColor,
          unselectedItemColor: AppColors.blackColor.withOpacity(.5),
          selectedLabelStyle: TextStyle(
              color: AppColors.blackColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
              color: AppColors.blackColor.withOpacity(.5),
              fontSize: 16,
              fontWeight: FontWeight.w500),
          onTap: _onItemTapped,
          items: List.generate(
            icons.length,
            (index) => BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  icons[index],
                ),
              ),
              label: strings[index],
            ),
          ),
        ));
  }
}
