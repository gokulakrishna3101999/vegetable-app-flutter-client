import 'dart:async';
import 'package:shop_final/backend.dart';
import 'package:flutter/material.dart';

FirebaseService firebaseService = new FirebaseService();

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    firebaseService.checkUserIsSignedIn(context);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).accentColor)),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: Center(
                    child: Image.asset('assets/splash.png',
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width * 0.35)
                    )
                    ),
              ],
            )
          ],
        ));
  }
}
