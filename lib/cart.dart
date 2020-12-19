import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'home_screen.dart';
import 'checkout.dart';
import 'backend.dart';
import 'drawer.dart';

FirebaseService firebaseService = new FirebaseService();
String vname, vimage, vrate, vqty, customer, location, productID;
var rate = 0.00, qty, price = 0.00;

class ViewCart extends StatefulWidget {
  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      drawer: Navdrawer(),
      appBar: AppBar(title: Text('My Cart')),
      body: StreamBuilder(
          stream: Firestore.instance.collection(id).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else {
              price = 0.00;
              for (DocumentSnapshot snap in snapshot.data.documents) {
                price += double.parse(snap['price']) * int.parse(snap['qty']);
              }
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height * 0.01,
                                right:
                                    MediaQuery.of(context).size.height * 0.01),
                            child: Card(
                                elevation: 25.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 3,
                                              child: Image.network(
                                                  snapshot.data
                                                      .documents[index]['image']
                                                      .toString(),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.20)),
                                          Expanded(
                                              flex: 7,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        AutoSizeText(
                                                            snapshot.data
                                                                    .documents[
                                                                index]['name'],
                                                            style: GoogleFonts
                                                                .getFont(
                                                                    'Montserrat',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18.0),
                                                            maxLines: 1),
                                                        AutoSizeText(
                                                            '₹' +
                                                                (int.parse(snapshot.data.documents[index][
                                                                            'price']) *
                                                                        int.parse(snapshot.data.documents[index]
                                                                            [
                                                                            'qty']))
                                                                    .toString(),
                                                            style: GoogleFonts
                                                                .getFont('Lato',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18.0),
                                                            maxLines: 1)
                                                      ]),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: <Widget>[
                                                            IconButton(
                                                                icon: Icon(Icons
                                                                    .remove),
                                                                onPressed: () {
                                                                  if ((int.parse(snapshot
                                                                              .data
                                                                              .documents[index]['qty']) -
                                                                          1) !=
                                                                      0) {
                                                                    firebaseService.addcart(
                                                                        snapshot.data.documents[index]
                                                                            [
                                                                            'name'],
                                                                        snapshot.data.documents[index]
                                                                            [
                                                                            'image'],
                                                                        snapshot.data.documents[index]
                                                                            [
                                                                            'price'],
                                                                        (int.parse(snapshot.data.documents[index]['qty']) - 1)
                                                                            .toString(),
                                                                        snapshot.data.documents[index]
                                                                            [
                                                                            'customerName'],
                                                                        snapshot
                                                                            .data
                                                                            .documents[index]['location']);
                                                                  }
                                                                }),
                                                            Text(snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                    ['qty']
                                                                .toString()),
                                                            IconButton(
                                                                icon: Icon(
                                                                    Icons.add),
                                                                onPressed: () {
                                                                  firebaseService.addcart(
                                                                      snapshot.data.documents[index][
                                                                          'name'],
                                                                      snapshot.data.documents[index]
                                                                          [
                                                                          'image'],
                                                                      snapshot.data.documents[
                                                                              index]
                                                                          [
                                                                          'price'],
                                                                      (int.parse(snapshot.data.documents[index]['qty']) +
                                                                              1)
                                                                          .toString(),
                                                                      snapshot.data
                                                                              .documents[index]
                                                                          [
                                                                          'customerName'],
                                                                      snapshot
                                                                          .data
                                                                          .documents[index]['location']);
                                                                })
                                                          ],
                                                        ),
                                                      ),
                                                      Builder(
                                                        builder: (context) =>
                                                            RaisedButton(
                                                          onPressed: () {
                                                            print(snapshot);
                                                            firebaseService
                                                                .cancelOrders(
                                                                    context,
                                                                    snapshot.data
                                                                            .documents[index]
                                                                        [
                                                                        'name']);
                                                          },
                                                          child: Text("DELETE",
                                                              style: GoogleFonts
                                                                  .getFont(
                                                                      'Montserrat')),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ]))),
                          );
                        }),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        AutoSizeText(snapshot.data.documents.length.toString() +
                            ' Items',style: GoogleFonts.getFont('Lato',fontSize: 17)),
                        AutoSizeText('₹ ' + price.toString(), style: GoogleFonts.getFont('Lato',fontSize: 17)),
                        RaisedButton(
                            onPressed: () {
                              if (snapshot.data.documents.length > 0) {
                                var uuid = Uuid();
                                var id = uuid.v1().toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Checkout(
                                                orderID: id,
                                                info: snapshot.data,
                                                price: price)));
                              } else
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Row(
                                      children: <Widget>[
                                        Icon(Icons.shopping_basket),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                        Text('Add Items to Checkout'),
                                      ],
                                    ),
                                    duration: Duration(seconds: 1),
                                    ));
                            },
                            child: Text('CHECKOUT', style: GoogleFonts.getFont('Montserrat'))),
                      ],
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}
