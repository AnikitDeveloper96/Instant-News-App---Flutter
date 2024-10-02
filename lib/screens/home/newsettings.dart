import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/theme.dart';
import '../firebase_auth.dart';
import '../splash_screen.dart';

class NewsSettings extends StatefulWidget {
  static const String newsSettings = "newsSettings";
  const NewsSettings({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  // const NewsSettings({super.key});

  @override
  State<NewsSettings> createState() => _NewsSettingsState();
}

class _NewsSettingsState extends State<NewsSettings> {
  final bool _flutter = false;

  late User _user;
  bool _isSigningOut = false;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3.0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
                size: 30,
              )),
          title: const Text("Settings ",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, left: 24.0),
              child: const Text(
                "General",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
            // Card(
            //   color: Colors.white,
            //   child: SwitchListTile(
            //     title: const Text(
            //       'Dark Theme',
            //       style: TextStyle(
            //           color: Colors.black,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 18),
            //     ),
            //     value: themeChange.darkTheme,
            //     activeColor: Colors.blue,
            //     inactiveTrackColor: Colors.grey[300],
            //     onChanged: (bool value) {
            //       setState(() {
            //          themeChange.darkTheme = value;
            //       });
            //     },
            //   ),
            // ),
            _isSigningOut
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D0821)),
                  )
                : Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await Authentication.signOut(context: context);
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.pushReplacementNamed(
                            context, SplashScreen.splashscreen);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
            // GestureDetector(
            //   onTap: () {
            //     Authentication.signOut(context: context).then((value) =>
            //         Navigator.pushReplacementNamed(
            //             context, SplashScreen.splashscreen));
            //   },
            //   child: Container(
            //     margin:
            //         const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
            //     width: double.infinity,
            //     decoration: const BoxDecoration(
            //         color: Colors.blue,
            //         borderRadius: BorderRadius.all(Radius.circular(20.0))),
            //     child: const Padding(
            //       padding: EdgeInsets.all(18.0),
            //       child: Center(
            //         child: Text(
            //           "Signout",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w600,
            //               fontSize: 20),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ));
  }
}
