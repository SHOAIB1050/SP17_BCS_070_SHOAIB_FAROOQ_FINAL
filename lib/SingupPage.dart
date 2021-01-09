import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home.dart';
import 'main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Singup extends StatefulWidget {
  @override
  _SingupState createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  TextEditingController nameTextEditingController = TextEditingController();
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
                IconButton(icon: Icon(Icons.person), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          controller: nameTextEditingController,
                          decoration: InputDecoration(hintText: 'Name'),
                        )))
              ],
            ),
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
                      regesterNewUser(context);
                    }
                  },
                  color: Colors.teal[700],
                  child: Text(
                    'SingUp',
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
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Center(
              child: RichText(
                text: TextSpan(
                    text: 'Already have an account?',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  Login ',
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
  void regesterNewUser(BuildContext context) async {
    //DATA STORE ON FORESTORE
    await Firebase.initializeApp();
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text);
    User user = result.user;
    await user.updateProfile(displayName: nameTextEditingController.text);
    print(user);
    if (user != null) {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentReference ref = _firestore.collection('users').doc(user.uid);
      ref.set({
        'UID': user.uid,
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
      });
    }

    if (user != null) {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
      };
      userResf.child(user.uid).set(userDataMap);
      displayToastMessage(
          "Congratulations Your Account has been Created", context);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Singup()));
    } else {
      displayToastMessage("New user has not been Created", context);
    }
  }

  movetolastScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Singup()));
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
