import 'package:flutter/material.dart';
import 'dart:async';
import 'Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SplashScreen());
}

DatabaseReference userResf =
    FirebaseDatabase.instance.reference().child("users");

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Splach(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splach extends StatefulWidget {
  @override
  _SplachState createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.pink,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.0,
                    child: Image.asset('img/abc.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Note Taking App',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Alike'),
                  )
                ],
              ),
            ),
            SizedBox(height: 140),
            Container(
              height: 100,
              child: Column(
                children: [
                  CircularProgressIndicator(backgroundColor: Colors.white),
                  SizedBox(height: 15),
                  Text(
                    'Hello and Hi',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Satisfy'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
