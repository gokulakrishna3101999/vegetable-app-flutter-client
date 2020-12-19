import 'backend.dart';
import 'home_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

String phone, token;
TextEditingController phonecontroller = TextEditingController();

class PhoneAuthentication extends StatefulWidget {
  final token;

  PhoneAuthentication({this.token});

  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  FirebaseService phoneSignin = new FirebaseService();

  @override
  void initState() {
    super.initState();
    phoneSignin.getUser().then((user) {
      if (user != null)
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    });
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
            children: [
              Image.asset('assets/phone.jpg',
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.45),
              ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text('PHONE AUTHENTICATION')),
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
                ),
              ),
              Row(children: <Widget>[
                Expanded(child: Container()),
                Builder(
                    builder: (context) => FlatButton(
                        onPressed: () {
                          if (phonecontroller.text.length == 10)
                            firebaseService.signInWithPhone(
                                '+91' + phonecontroller.text.toString(),
                                context,
                                token);
                          else {
                            print("Invalid");
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Invalid Phone Number',
                              ),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        },
                        child: Text('CONTINUE')))
              ])
            ],
          ),
        )),
      ),
    );
  }
}
