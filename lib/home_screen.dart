import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'drawer.dart';
import 'backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String name = '',
    price = '',
    image = '',
    cname = '',
    email = '',
    address = '',
    id = '',
    picture = '',
    phone = '',
    provider = '';

FirebaseService firebaseService = new FirebaseService();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  Stream products = Firestore.instance.collection("products").snapshots();

  retreiveUserDetails() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String uid;
    try {
      if (firebaseAuth.currentUser() != null) {
        final FirebaseUser user = await firebaseAuth.currentUser();
        uid = user.uid.toString();
        Firestore.instance
            .collection("users")
            .document(uid)
            .get()
            .then((datasnapshot) {
          setState(() {
            provider = user.providerData[1].providerId;
            cname = datasnapshot.data['username'];
            email = datasnapshot.data['email'];
            id = datasnapshot.data['id'];
            picture = datasnapshot.data['profilePicture'];
            address = datasnapshot.data['address'];
            phone = (provider == "google.com")
                ? datasnapshot.data['phone']
                : user.phoneNumber;
          });
        });
      }
    } catch (e) {
       Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    retreiveUserDetails();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Market Place'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  showSearch(
                      context: context, delegate: Search(products: products));
                }),
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewCart()));
              },
            )
          ],
        ),
        drawer: Navdrawer(),
        body: new NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: new TabBar(
                      controller: _controller,
                      labelColor: Theme.of(context).accentColor,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        new Tab(
                          child: AutoSizeText(
                            'VEGETABLES',
                            maxLines: 1,
                            style: GoogleFonts.getFont('Montserrat'),
                          ),
                        ),
                        new Tab(
                            child: AutoSizeText('FRUITS',
                                maxLines: 1,
                                style: GoogleFonts.getFont('Montserrat')))
                      ]),
                )
              ];
            },
            body: Container(
              child: new TabBarView(controller: _controller, children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("products")
                      .where("productType", isEqualTo: "vegetable")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTileItem(
                                  name: snapshot.data.documents[index]['Name'],
                                  image: snapshot.data.documents[index]
                                      ['Image'],
                                  price: snapshot.data.documents[index]
                                      ['Price']);
                            },
                          );
                  },
                ),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("products")
                      .where("productType", isEqualTo: "fruit")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTileItem(
                                  name: snapshot.data.documents[index]['Name'],
                                  image: snapshot.data.documents[index]
                                      ['Image'],
                                  price: snapshot.data.documents[index]
                                      ['Price']);
                            },
                          );
                  },
                ),
              ]),
            )));
  }
}

class Search extends SearchDelegate {
  final Stream products;

  Search({this.products});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: products,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final results = snapshot.data.documents.where((DocumentSnapshot data) =>
            data.data['Name'].toString().toLowerCase().contains(query));
        return GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: results
                .map<Widget>((a) => ListTileItem(
                    name: a.data['Name'],
                    image: a.data['Image'],
                    price: a.data['Price']))
                .toList());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: products,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final results = snapshot.data.documents.where((DocumentSnapshot data) =>
            data.data['Name'].toString().toLowerCase().contains(query));
        return GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: results
                .map<Widget>((a) => ListTileItem(
                    name: a.data['Name'],
                    image: a.data['Image'],
                    price: a.data['Price']))
                .toList());
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    StreamBuilder(
      stream: products,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final results = snapshot.data.documents.where((DocumentSnapshot data) =>
            data.data['Name'].toString().toLowerCase().contains(query));
        return GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: results
                .map<Widget>((a) => ListTileItem(
                    name: a.data['Name'],
                    image: a.data['Image'],
                    price: a.data['Price']))
                .toList());
      },
    );
  }
}

class ListTileItem extends StatefulWidget {
  final name;
  final image;
  final price;

  ListTileItem({this.name, this.image, this.price});

  @override
  _ListTileItemState createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  int _itemcount = 1;
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        child: Column(children: <Widget>[
          Expanded(
            child: CachedNetworkImage(imageUrl: widget.image),
          ),
          visible == true
              ? ListTile(
                  title: AutoSizeText(widget.name,
                      maxLines: 1, style: GoogleFonts.getFont('Domine')),
                  subtitle: Text('₹' + widget.price.toString(),
                      style: GoogleFonts.getFont('Domine')),
                  trailing: InkWell(
                    child: Icon(Icons.add_circle,
                        size: 35.0, color: Theme.of(context).accentColor),
                    onTap: () {
                      setState(() {
                        visible = false;
                      });
                      firebaseService.addcart(
                          widget.name,
                          widget.image,
                          widget.price.toString(),
                          _itemcount.toString(),
                          cname,
                          address);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Row(
                          children: <Widget>[
                            Icon(Icons.add_shopping_cart),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.04),
                            Text("Added To Cart"),
                          ],
                        ),
                        action: SnackBarAction(
                            label: 'UNDO',
                            textColor: Colors.white,
                            onPressed: () {
                              firebaseService.cancelOrders(
                                  context, widget.name);
                            }),
                      ));
                    },
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (_itemcount != 1) {
                            setState(() {
                              _itemcount--;
                            });
                            firebaseService.addcart(
                                widget.name,
                                widget.image,
                                widget.price.toString(),
                                _itemcount.toString(),
                                cname,
                                address);
                          } else if (_itemcount == 1) {
                            setState(() {
                              visible = true;
                            });
                            firebaseService.cancelOrders(context, widget.name);
                          }
                        }),
                    Text(_itemcount.toString()),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _itemcount++;
                          });
                          firebaseService.addcart(
                              widget.name,
                              widget.image,
                              widget.price.toString(),
                              _itemcount.toString(),
                              cname,
                              address);
                        })
                  ],
                )
        ]));
  }
}
