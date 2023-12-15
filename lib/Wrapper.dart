//controls which screen to show first

import 'package:driver_demo/DatabaseUserID.dart';
import 'package:driver_demo/Driver.dart';
import 'package:driver_demo/home.dart';
import 'package:driver_demo/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class Wrapper extends StatelessWidget{
//   const Wrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     return StreamBuilder<Driver?>(
//       stream: authService.user,
//       builder: (_, AsyncSnapshot<Driver?> snapshot){
//         if(snapshot.connectionState == ConnectionState.active){
//           final Driver? driver = snapshot.data;
//           return (driver == null)? const LoginPage() : const HomePage();
//         }
//         else{
//           return const Scaffold(body:Center(child:CircularProgressIndicator(),),);
//         }
//       },
//     );
//
//   }
//
//
// }


class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  var auth = FirebaseAuth.instance;
  var isLoggedIn = false;

  _checkLoggedIn() async{
    auth.authStateChanges().listen((User? user) {
      // if(user == null){
      // }
      if (user != null && mounted){
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  @override
  void initState() {
    _checkLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoggedIn)? const HomePage() : const LoginPage();
  }
}
