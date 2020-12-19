import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'backend.dart';
import 'drawer.dart';
import 'home_screen.dart';

FirebaseService firebaseService = new FirebaseService();

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController phonecontroller =
      new TextEditingController(text: (phone.length==13)?phone.substring(3,phone.length):phone);
  TextEditingController addresscontroller =
      new TextEditingController(text: address);

  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      drawer: Navdrawer(),
      appBar: AppBar(title: Text('Profile')),
      body: ListView(
        shrinkWrap: false, children: [
        Card(
          margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
          child: Form(
            key: formKey2,
            child: Column(children: <Widget>[
              Image.asset('assets/profile.jpg', fit: BoxFit.cover),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: TextFormField(
                  controller: phonecontroller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.call)),
                  validator: (value) {
                    if (value.isEmpty) return 'Required';
                    if (value.length > 10 || value.length < 10)
                      return 'Enter a 10-digit valid phone number';
                    else
                      return null;
                  },
                  maxLength: 10,
                  autovalidate: true,
                ),
              ),
               SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: TextFormField(
                  controller: addresscontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.home),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Required';
                    else
                      return null;
                  },
                  autovalidate: true,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Builder(
                builder: (context) => RaisedButton(
                    onPressed: () {
                      FormState formstate1 = formKey2.currentState;
                      if (formstate1.validate()) {
                        address = addresscontroller.text;
                        phone = phonecontroller.text;
                        firebaseService.updateDetails(
                            addresscontroller.text, phonecontroller.text);
                        formstate1.save();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1),
                            content: Row(
                              children: <Widget>[
                                Icon(Icons.check),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04),
                                Text('Saved'),
                              ],
                            )));
                      }
                    },
                    child: Text('SAVE', style: GoogleFonts.getFont('Montserrat'))),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ]),
          ),
        ),
      ]),
    );
  }
}
