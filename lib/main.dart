import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        buttonColor: Theme.of(context).accentColor,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurpleAccent,
          textTheme: ButtonTextTheme.primary,
          colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white)),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.deepPurpleAccent,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          textTheme: TextTheme(
            headline6: GoogleFonts.getFont('Lato',fontSize: 20, color: Colors.white)
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
