import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
import 'Window_after_login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            height: 330,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage('img/abc.png'))),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.email), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          controller: emailTextEditingController,
                          decoration: InputDecoration(hintText: 'Email'),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.lock), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          obscureText: true,
                          controller: passwordTextEditingController,
                          decoration: InputDecoration(hintText: 'Password'),
                        ))),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 50,
                width: 150,
                child: RaisedButton(
                  onPressed: () {
                    if (!emailTextEditingController.text.contains("@")) {
                      displayToastMessage(
                          'Email Address is not Valid', context);
                    } else if (passwordTextEditingController.text.isEmpty) {
                      displayToastMessage('Password is Necessary', context);
                    } else {
                      loginAuthenticationUser(context);
                    }
                  },
                  color: Colors.teal[700],
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SingupPage()));
            },
            child: Center(
              child: RichText(
                text: TextSpan(
                    text: 'Don\'t have an account?',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  SIGN UP ',
                        style: TextStyle(
                            color: Colors.pink, fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAuthenticationUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text)
        .catchError((erMsg) {
      displayToastMessage("Error " + erMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      userResf.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WindowAfierLogin()));
          displayToastMessage(
              "Congratulations Your logged successfully", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage("Not Record found this user", context);
        }
      });
    } else {
      displayToastMessage("Error exist", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
