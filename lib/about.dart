import 'package:flutter/material.dart';
import 'drawer.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('About')),
      drawer: Navdrawer(),
      body: ListView(
      children: <Widget> [
       Image.asset('assets/splash.png'),
       Divider(height: 1.0, color: Colors.black),
       ListTile(
         title: Text('App version'),
         subtitle: Text('1.0.0')),
       Divider(height: 1.0, color: Colors.black),
       ListTile(
         title: Text('Contact'),
         subtitle: Text('believeinsurya@gmail.com'),  
       ),
       Divider(height: 1.0, color: Colors.black)      
      ]
      )
    );
  }
}
