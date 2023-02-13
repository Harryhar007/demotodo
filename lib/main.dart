import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC5CxaajynOJNpiyokk3EYa7C1o0QzOBhQ",
      appId: "1:723055122752:android:0565e1598d4f61f69742a5",
      messagingSenderId: "723055122752",
      projectId: "demotodo-softareo",
    ),
  );


  runApp(MyApp());


}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark,primaryColor: Colors.blue,),

    );
  }
}


