import 'package:flutter/material.dart';
import 'package:shop_final/backend.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_final/phone_auth.dart';

FirebaseService firebaseService = new FirebaseService();
FirebaseMessaging fcm = new FirebaseMessaging();
String token, value;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  getToken() async {
    value = await fcm.getToken();
    setState(() {
      token = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
      child: SingleChildScrollView(
          child: Card(
              margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              child: Column(
                children: <Widget>[
                  Image.asset('assets/login.jpg',
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.45 ),
           StreamBuilder(
                      stream: FirebaseAuth.instance.onAuthStateChanged,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Column(
                            children: [
                                ListTile(
                              title: Text(
                                'SIGN IN TO CONTINUE',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ListTile(
                              leading: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 32,
                                      maxHeight: 32,
                                    ),
                                    child: Image.asset('assets/google.png', fit: BoxFit.cover),
                                  ),
                              title: Text('Google'),
                              subtitle:
                                  Text('Sign in with your Google account'),
                              onTap: () {
                                firebaseService.handleSignIn(context, token);
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.phone_android,
                                color: Colors.black,
                              ),
                              title: Text('Phone number'),
                              subtitle: Text('Sign in with your phone number'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PhoneAuthentication(token: token)));
                              },
                            ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Column(
                              children: [
                                ListTile(),
                                CircularProgressIndicator(),
                                ListTile()
                              ],
                            ),
                          );
                        }
                      })
                ],
              ))),
    )
  );
  }
}
