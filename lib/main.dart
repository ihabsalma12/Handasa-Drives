import 'package:driver_demo/services/AuthService.dart';
import 'package:driver_demo/services/BottomSheetProvider.dart';
import 'package:driver_demo/view/add.dart';
import 'package:driver_demo/view/home.dart';
import 'package:driver_demo/view/launch.dart';
import 'package:driver_demo/view/login.dart';
import 'package:driver_demo/view/route_riders.dart';
import 'package:driver_demo/view/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';




Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(
    MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),
          ChangeNotifierProvider.value(value: BottomSheetProvider()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,),
            useMaterial3: true,
            brightness: Brightness.light,
            // primarySwatch: Colors.blue,
            // primaryColor: Colors.blue,
            // primaryColorDark: Colors.blue.shade800,
            // primaryColorLight: Colors.blue.shade300,
            // scaffoldBackgroundColor: Colors.white,

            fontFamily: "SometypeMono",),
          debugShowCheckedModeBanner: false,
          initialRoute: '/Launch',
          routes:{
            "/Launch": (context) => const LaunchPage(),
            "/Login": (context) => const LoginPage(),
            "/SignUp": (context) => const SignUpPage(),
            "/Home": (context) => const HomePage(), // to view all my routes
            "/RouteRiders": (context) => const RouteRidersPage(),// to confirm riders of a particular route
            "/Add": (context) => const AddPage() // to add a new ride
          },
        ),
      ),

  );

}
