import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_final/backend.dart';
import 'home_screen.dart';
import 'cart.dart';
import 'profile.dart';
import 'order.dart';
import 'about.dart';

FirebaseService firebaseService = new FirebaseService();

class Navdrawer extends StatefulWidget {
  
  @override
  _NavdrawerState createState() => _NavdrawerState();
}

class _NavdrawerState extends State<Navdrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).orientation == Orientation.portrait 
               ? MediaQuery.of(context).size.width * 0.70
               : MediaQuery.of(context).size.width * 0.60,
        child: Drawer(
        child: ListView(padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: (provider=="google.com") 
                        ? Text(cname, maxLines: 1, style: GoogleFonts.getFont('Lato'))
                        : Text('SURI\'S VEGETABLE SHOP',maxLines: 1, style: GoogleFonts.getFont('Lato')),
            accountEmail: (provider=="google.com") 
                        ? Text(email, maxLines: 1, style: GoogleFonts.getFont('Lato'))
                        : Text(phone, maxLines:1, style: GoogleFonts.getFont('Lato')),
            currentAccountPicture: GestureDetector(
              child: ClipOval(
                child: (provider=="google.com") 
                        ? Image.network(picture)
                        : Image.asset('assets/splash.png'),        
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: AutoSizeText('HOME',
                  style: GoogleFonts.getFont('Lato'),
                  maxLines: 1),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ViewCart()));
            },
            child: ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.black),
              title: AutoSizeText('MY CART',
                  style: GoogleFonts.getFont('Lato'),
                  maxLines: 1),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            child: ListTile(
              leading: Icon(Icons.account_circle, color: Colors.black),
              title: AutoSizeText('PROFILE',
                  style: GoogleFonts.getFont('Lato'), 
                  maxLines: 1),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Orders()));
            },
            child: ListTile(
              leading: Icon(Icons.store, color: Colors.black),
              title: AutoSizeText('ORDERS',
                  style: GoogleFonts.getFont('Lato'),
                  maxLines: 1),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About()));
            },
            child: ListTile(
              leading: Icon(Icons.info, color: Colors.black),
              title: AutoSizeText('ABOUT',
                  style: GoogleFonts.getFont('Lato'),
                  maxLines: 1),
            ),
          ),
          InkWell(
            onTap: () {
              firebaseService.signOut(context);
            },
            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: AutoSizeText('SIGN OUT',
                  style: GoogleFonts.getFont('Lato',color: Colors.red),
                  maxLines: 1),
            ),
          ),
        ]),
      ),
    );
  }
}
