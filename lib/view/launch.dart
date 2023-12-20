import 'dart:async';
import 'package:driver_demo/helpers/Wrapper.dart';
import 'package:flutter/material.dart';



class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  _LaunchPageState createState() => _LaunchPageState();
}
class _LaunchPageState extends State<LaunchPage> {
  @override
  initState() {
    super.initState();
    Timer(const Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                const Wrapper()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: SizedBox(
            height:100, width:100,
            // child: Text("logo here"),
            child: Image.asset("assets/handasa_logo.png"),
          )
      ),
    );
  }
}