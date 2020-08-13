import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:firebase_database/firebase_database.dart';

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  String email, number, name;
  final fb = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  void _validateInputs1() {
    if (_formKey1.currentState.validate()) {
// If all data are correct then save data to out variables
      _formKey1.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference().child("Userdata");
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey1,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(
              image: AssetImage("ASSETS/index.jpeg"),
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 470.0),
              child: Center(
                child: Text(
                  "Email",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Full Name",
                          prefixIcon: Icon(Icons.person),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                        initialValue: "",
                        keyboardType: TextInputType.text,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Text is empty';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          name = val;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter Email",
                          prefixIcon: Icon(Icons.email),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                        initialValue: "",
                        keyboardType: TextInputType.text,
                        validator: validateEmail1,
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "ENTER NO",
                          prefixIcon: Icon(Icons.contact_phone),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                        initialValue: "",
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val.length <= 9) return 'Empty or less then 10';
                          return null;
                        },
                        onChanged: (val) {
                          number = val;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        height: 45,
                        minWidth: 350,
                        color: Colors.teal,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          "Sent",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: () async {
                          _validateInputs1();

                          if (validateEmail1(email) == "varified") {
                            String username = 'sender email'; //Your Email;
                            String password =
                                'sender password'; //Your Email's password;

                            final smtpServer = gmail(username, password);
                            // Creating the Gmail server

                            // Create our email message.
                            final message = Message()
                              ..from = Address(username)
                              ..recipients
                                  .add('ps9956651@gmail.com') //recipent email
                              // ..ccRecipients.addAll([
                              //   'ps9956651@gmail.com',
                              //   'ps9956651@gmail.com'
                              // ]) //cc Recipents emails
                              // ..bccRecipients.add(Address(
                              //     'ps9956651@gmail.com')) //bcc Recipents emails
                              ..subject =
                                  'Test Dart Mailer library :: 😀 :: ${DateTime.now()}' //subject of the email
                              ..text =
                                  'UserName::$name \nEmail Add ::$email\nNumber::$number';

                            try {
                              final sendReport =
                                  await send(message, smtpServer);
                              print('Message sent: ' +
                                  sendReport
                                      .toString()); //print if the email is sent
                              Toast.show(
                                "Mail Sent",
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.TOP,
                              );
                            } on MailerException catch (e) {
                              print('Message not sent. \n' +
                                  e.toString()); //print if the email is not sent
                              // e.toString() will show why the email is not sending
                            }
                          }

                          ref.child("Data").set({
                            "name": name,
                            "password": number,
                            "email": email,
                          });
                        },
                        splashColor: Colors.redAccent,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String validateEmail1(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regexp = new RegExp(pattern);
  if (!regexp.hasMatch(value))
    return 'Enter Valid Email';
  else
    return 'varified';
}
