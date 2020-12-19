import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawer.dart';


class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(title: Text('Orders')),
        drawer: Navdrawer(),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("orders")
                .where('userId', isEqualTo: id)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.height * 0.01,
                          left: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                  color: Theme.of(context).accentColor,
                                  child: ListTile(
                                  title: Text('Order ID', style: GoogleFonts.getFont('Montserrat', color: Colors.white)),
                                  subtitle: Text(snapshot.data.documents[index]['orderId'].toString(), style: GoogleFonts.getFont('Montserrat',color: Colors.white))
                                  )
                                  )
                                  )
                              ],
                            ),
                            ExpansionTile(
                                  title: Text('Item List',style: GoogleFonts.getFont('Montserrat', fontWeight: FontWeight.bold)),
                                  trailing: Text('TAP TO VIEW',style: GoogleFonts.getFont('Lato')),
                                  children: [
                                for(var i=0;i<snapshot.data.documents[index]['itemQty'].length;i++)
                                Row(
                                 children: [
                                   Expanded(child: ListTile(title: Text(snapshot.data.documents[index]['itemNames'][i],style: GoogleFonts.getFont('Montserrat')))),
                                   Expanded(child: ListTile(title: Text(snapshot.data.documents[index]['itemQty'][i], textAlign: TextAlign.center))),
                                   Expanded(child: ListTile(title: Text('₹'+(double.parse(snapshot.data.documents[index]['itemPrices'][i]) * double.parse(snapshot.data.documents[index]['itemQty'][i])).toString(), textAlign: TextAlign.center)))              
                                 ],
                                )
                                ]
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: ListTile(
                                    title: Text('Items',style:GoogleFonts.getFont('Montserrat', fontWeight: FontWeight.bold)))),
                                Expanded(
                                    child: ListTile(
                                    title: Text(snapshot.data.documents[index]['itemQty'].length.toString(),
                                    style: GoogleFonts.getFont('Lato',color: Colors.blue), textAlign: TextAlign.left)
                                  ),
                                ),
                                Expanded(
                                    child: ListTile(
                                    title: Text('Total',style:GoogleFonts.getFont('Montserrat',fontWeight: FontWeight.bold),textAlign: TextAlign.center))),
                                Expanded(    
                                    child: ListTile(
                                    title: Text('₹'+snapshot.data.documents[index]['totalPrice'].toString(),
                                          style: GoogleFonts.getFont('Lato',color: Colors.blueAccent),textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ));
                  });
            }));
  }
}
