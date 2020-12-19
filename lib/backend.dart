import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'authenticate.dart';
import 'home_screen.dart';

class FirebaseService {
//google sign in
  Future handleSignIn(BuildContext context, String deviceToken) async {
    GoogleSignIn googleSignIn = new GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if (documents.length == 0) {
        //adding user to the table or relation
        Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .setData({
          "id": firebaseUser.uid,
          "username": firebaseUser.displayName,
          "profilePicture": firebaseUser.photoUrl,
          "email": firebaseUser.email,
          "address": null,
          "phone": null,
          "deviceToken": deviceToken,
        });
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Login Failed')));
    }
  }

  //update user address and phone
  void updateDetails(
      String address, String phone) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseUser user = await firebaseAuth.currentUser();
    String uid = user.uid.toString();
    DocumentSnapshot documentSnapshot =
        await Firestore.instance.collection("users").document(uid).get();
    String deviceToken = documentSnapshot.data['deviceToken'].toString();
    Firestore.instance.collection("users").document(uid).updateData({
      "id": uid,
      "address": address.toString(),
      "phone": phone.toString(),
      "deviceToken": deviceToken,
    });
  }

  //google sign in
  void checkUserIsSignedIn(BuildContext context) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseUser user = await firebaseAuth.currentUser();
    if (user != null)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    else
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

//signout method
  void signOut(BuildContext context) {
    GoogleSignIn googleSignIn = new GoogleSignIn();
    googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  //add to cart
  void addcart(String vname, String vimage, String vrate, String vqty,
      String customer, String location) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.currentUser().then((firebaseUser) {
      Firestore.instance.collection(firebaseUser.uid).document(vname).setData({
        "name": vname,
        "image": vimage,
        "price": vrate,
        "qty": vqty,
        "userID": firebaseUser.uid
      });
    });
  }

  checkout(QuerySnapshot snapshot, String sum) {
    var id = Uuid();
    var orderId = id.v1().toString();
    List<String> names = List<String>();
    List<String> prices = List<String>();
    List<String> quantity = List<String>();
    for (var i = 0; i < snapshot.documents.length; i++) {
      names.add(snapshot.documents[i]['name'].toString());
      prices.add(snapshot.documents[i]['price'].toString());
      quantity.add(snapshot.documents[i]['qty'].toString());
    }
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      Firestore.instance.collection("orders").document(orderId).setData({
        "orderId": orderId,
        "userId": firebaseUser.uid,
        "itemNames": names,
        "itemPrices": prices,
        "itemQty": quantity,
        "totalPrice": sum
      });
    });
  }

  //cancelling orders
  void cancelOrders(BuildContext context, String vname) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.currentUser().then((firebaseUser) {
      Firestore.instance.collection(firebaseUser.uid).document(vname).delete();
    });
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Row(
          children: <Widget>[
            Icon(Icons.delete_forever),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Text('Deleted'),
          ],
        ),
        duration: Duration(seconds: 1)));
  }

  //phone authentication
  signInWithPhone(String phone, BuildContext context, String deviceToken) async {
    CircularProgressIndicator();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    Firestore firestore = Firestore.instance;
    final phoneNumberController = new TextEditingController();
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential authCredential) async {
          FirebaseUser firebaseUser =
              (await firebaseAuth.signInWithCredential(authCredential)).user;
          if (firebaseUser != null) {
            final QuerySnapshot result = await Firestore.instance
                .collection("users")
                .where("id", isEqualTo: firebaseUser.uid)
                .getDocuments();
            final List<DocumentSnapshot> documents = result.documents;

            if (documents.length == 0) {
              //adding user to the table or relation
              firestore.collection("users").document(firebaseUser.uid).setData({
                "id": firebaseUser.uid,
                "deviceToken": deviceToken.toString(),
                "phone": phone.toString(),
                "address": null});
            }
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
          } else {
            print("Login Failed");
          }
          //actual process ends
        },
        verificationFailed: (AuthException exception) {
          return exception.toString();
        },
        codeSent: (String verificationId, [int forceResendToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text('Your OTP', textAlign: TextAlign.center),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'OTP',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    actions: [
                      FlatButton(
                          color: Colors.white,
                          onPressed: () async {
                            var credentials = PhoneAuthProvider.getCredential(
                                verificationId: verificationId,
                                smsCode: phoneNumberController.text.trim());
                            // actual process starts
                            FirebaseUser firebaseUser = (await firebaseAuth
                                    .signInWithCredential(credentials))
                                .user;
                            if (firebaseUser != null) {
                              final QuerySnapshot result = await Firestore
                                  .instance
                                  .collection("users")
                                  .where("id", isEqualTo: firebaseUser.uid)
                                  .getDocuments();
                              final List<DocumentSnapshot> documents =
                                  result.documents;

                              if (documents.length == 0) {
                                //adding user to the table or relation
                                firestore
                                    .collection("users")
                                    .document(firebaseUser.uid)
                                    .setData({
                                  "id": firebaseUser.uid,
                                  "deviceToken": deviceToken.toString(),
                                  "phone": phone.toString(),
                                  "address": null
                                });
                              }
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage()));
                            } else {
                              print("Login Failed");
                            }
                            //actual process ends
                          },
                          child: Text('SUBMIT'))
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Timeout");
        });
  }

  //return the current user
  Future<FirebaseUser> getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.currentUser();
  }
}
