import 'package:driver_demo/DatabaseUserID.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _passHidden = true;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailContr = TextEditingController();
  final TextEditingController passContr = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final mySQfLite = DatabaseUserID();


    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(key: formKey,
            child: Center(
              child: SingleChildScrollView(

                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Text("Login", style: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 42,
                    )),
                    const SizedBox(height: 40,),
                    TextFormField(
                        controller: emailContr,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          //hintText: "<your_ID_here>@eng.asu.edu.eg",
                          //floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)),
                              borderSide: BorderSide(
                                width: 1,)),
                          prefixIcon: Icon(Icons.email_rounded),
                        ),
                        validator: (valid) {
                          if (valid == null || valid.isEmpty) {
                            return ('Email required.');
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passContr,
                      obscureText: _passHidden,
                      decoration: InputDecoration(labelText: "Password",
                          //floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,),
                          ),
                          prefixIcon: const Icon(Icons.lock_rounded),
                          suffixIcon: IconButton(onPressed: () {
                            setState(() {
                              _passHidden = !_passHidden;
                            });
                          }, icon: Icon(_passHidden
                              ? Icons.visibility
                              : Icons.visibility_off),)


                      ),
                      validator: (valid) {
                        if (valid == null || valid.isEmpty) {
                          return ('Password required.');
                        }
                        return null;
                      },
                    ),


                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme
                            .of(context)
                            .primaryColorDark,
                      ),
                      // onPressed: () async {
                      //   if(formKey.currentState!.validate()) {
                      //     try{
                      //       await authService.signInWithEmailAndPassword(email: emailContr.text, password: passContr.text);}
                      //     catch (error){
                      //       final snackBar = SnackBar(content: Text('SALMA! Login error happened: ${error.toString()}'),);
                      //       if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      //       return;
                      //     }
                      //     debugPrint("All is good! Logged in.");
                      //     if(context.mounted) {
                      //       Navigator.pushReplacementNamed(context, "/Home");
                      //       mySQfLite.ifExistDB();
                      //       mySQfLite.insertUser(authService.user_email, authService.user_name);
                      //       final snackBar = SnackBar(content: Text('Welcome, ${authService.user_name}!'),);
                      //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      //
                      //     }
                      //     // formKey.currentState!.reset();
                      //   }
                      // },
                      onPressed: () async {
                        if(formKey.currentState!.validate()) {
                          if(await signInWithEmailAndPassword()){
                            debugPrint("All is good! Signed up.");
                            // await mySQfLite.ifExistDB();
                            setState(() {

                              debugPrint("current user listener updated, now updating local profile data...");
                              mySQfLite.insertUser(FirebaseAuth.instance.currentUser!.uid, FirebaseAuth.instance.currentUser!.email, FirebaseAuth.instance.currentUser!.displayName);

                            });
                            // await mySQfLite.ifExistDB();
                            if(context.mounted) {
                              Navigator.pushReplacementNamed(context, "/Home");
                              final snackBar = SnackBar(content: Text('Welcome, ${FirebaseAuth.instance.currentUser!.displayName}!'),);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            }
                          }

                        }
                      },
                      child: const Text("Login"),),

                    const SizedBox(height:10),
                    GestureDetector(
                        onTap: (){
                          debugPrint("Go to sign up page...");
                          while(Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          Navigator.pushNamed(context, "/SignUp");
                        },
                        child: Text(
                          "No account? Sign up here.",
                          style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,),),
                    ),


                  ],
                ),
              ),
            ),
          ),
        )


    );
  }

  Future<bool> signInWithEmailAndPassword() async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailContr.text,
          password: passContr.text
      );
      return true;
    } on FirebaseAuthException catch (e) {
      //TODO this works! but debug statements do not show...

      debugPrint("SALMA! Login error happened:${e.message}");
      final snackBar = SnackBar(content: Text('SALMA! Login error happened: ${e.toString()}'),);
      if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // else if (e.code == 'wrong-password') {
      //   print('Wrong password provided for that user.');
      // }

    }
    return false;

  }


}