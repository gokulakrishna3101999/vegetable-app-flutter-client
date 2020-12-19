import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_final/order.dart';
import 'backend.dart';
import 'profile.dart';
import 'home_screen.dart';

FirebaseService firebaseService = new FirebaseService();

class Checkout extends StatefulWidget {
  final orderID;
  final info;
  final price;

  Checkout({this.orderID, this.info, this.price});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(title: Text('Checkout')),
      body: ListView(
        children: <Widget>[
          Card(
              child: Column(children: <Widget>[
            ListTile(
              title: Text('Order ID',
                  style: GoogleFonts.getFont('Montserrat',
                      fontWeight: FontWeight.bold)),
              subtitle:
                  Text(widget.orderID, style: GoogleFonts.getFont('Lato')),
            ),
            ListTile(
              title: Text('Phone Number',
                  style: GoogleFonts.getFont('Montserrat',
                      fontWeight: FontWeight.bold)),
              subtitle: (phone != null)
                  ? Text(phone, style: GoogleFonts.getFont('Lato'))
                  : Text('Add phone number to place order',
                      style: GoogleFonts.getFont('Lato', color: Colors.red)),
            ),
            ListTile(
              title: Text('Address',
                  style: GoogleFonts.getFont('Montserrat',
                      fontWeight: FontWeight.bold)),
              subtitle: (address != null)
                  ? Text(address, style: GoogleFonts.getFont('Lato'))
                  : Text('Add address to place order',
                      style: GoogleFonts.getFont('Lato', color: Colors.red)),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Profile()));
              },
              child: Text('Add/Edit Details',
                  style: GoogleFonts.getFont('Montserrat')),
            ),
            SizedBox(height: 10)
          ])),
          Card(
              child: ExpansionTile(
                  title: Text('View Items',
                      style: GoogleFonts.getFont('Montserrat',
                          fontWeight: FontWeight.bold)),
                  children: <Widget>[
                for (var i = 0; i < widget.info.documents.length; i++)
                  Row(children: [
                    Expanded(
                        child: ListTile(
                            title: Text(widget.info.documents[i]['name'],
                                style: GoogleFonts.getFont('Montserrat')))),
                    Expanded(
                        child: ListTile(
                            title: Text(widget.info.documents[i]['qty'],
                                style: GoogleFonts.getFont('Lato'),
                                textAlign: TextAlign.center))),
                    Expanded(
                        child: ListTile(
                            title: Text('₹' + widget.info.documents[i]['price'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.getFont('Lato'))))
                  ])
              ])),
          Card(
              child: Column(children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Items',
                        style: GoogleFonts.getFont('Montserrat',
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(child: ListTile()),
                Expanded(
                    child: ListTile(
                        title: Text(widget.info.documents.length.toString(),
                            style: GoogleFonts.getFont('Lato',
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                      title: Text('Total',
                          style: GoogleFonts.getFont('Montserrat',
                              fontWeight: FontWeight.bold))),
                ),
                Expanded(child: ListTile()),
                Expanded(
                    child: ListTile(
                        title: Text('₹ ' + widget.price.toString(),
                            style: GoogleFonts.getFont('Lato',
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)))
              ],
            ),
            Builder(
              builder: (context) => RaisedButton(
                onPressed: () {
                  if (phone != null && address != null) {
                    firebaseService.checkout(
                        widget.info, widget.price.toString());
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Orders()));
                  } else {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).accentColor,
                        duration: Duration(seconds: 1),
                        content: Text('Add your details'),
                      ),
                    );
                  }
                },
                child: Text('Place Order',
                    style: GoogleFonts.getFont('Montserrat')),
              ),
            ),
            SizedBox(height: 10)
          ]))
        ],
      ),
    );
  }
}
