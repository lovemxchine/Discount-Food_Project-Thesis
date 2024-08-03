import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile/user/service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();

}

class _SignInState extends State<SignIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';

  
  @override
  void initState(){
    super.initState();

  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                onSubmitted: (String value){
                  setState(() {
                    email = emailController.text;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.person, color: Color(0xFFFF6838)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:const  BorderSide(
                      color: Color(0xFFFF6838),
                      width: 2.0
                    )
                    ),
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:const BorderSide(
                      color: Color(0xFFFF6838), // Custom border color
                      width: 2.0, // Custom border width
                    ),
                  ),
                ),
           
              ),  
              const SizedBox( height: 20,),
              TextField(
                controller: passwordController,
                onSubmitted: (String value){
                  setState(() {
                    password = passwordController.text;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFFF6838)),
                  hintText: 'Password',
                  // labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:const BorderSide(
                      color: Color(0xFFFF6838),
                      width: 2.0
                    )
                    ),focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:const BorderSide(
                      color: Color(0xFFFF6838), // Custom border color
                      width: 2.0, // Custom border width
                    ),
                  ),
                ),
            
              ),  
              const SizedBox( height: 30,),
              Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text:const TextSpan(
                    text: 'Sign In as Guest ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFF6838)
                    ),
                  ),            
                ),
              ),
              const SizedBox( height: 20,),
              ElevatedButton(
            onPressed: () {
              _signIn(); 
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6838), // Button color
              minimumSize: Size(600, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
            ),
            child:const  Text(
              'Submit', 
              style: TextStyle(
                fontSize: 16,
                color: Colors.white)),
          ),
          const SizedBox(height: 35),
          RichText(text: TextSpan(
            text: 'Don\'t have an account ? ',
            style:const  TextStyle(
              color: Colors.black,
              fontSize: 16
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Sign Up',
                style:const TextStyle(
                  color: Color(0xFFFF6838),
                  fontSize: 16
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/registerRole');
                  }
              )
            ]
          ))
            ],
          )
        ),
      ),
    );
  }
  void _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

   try{ User? user = await _auth.signInWithEmailAndPassword(email, password); 

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences
          .getInstance(); //สร้างตัวแปรสำหรับ sharedpreference
      print("Login is successfully signed");
    }
    } on FirebaseAuthException catch (e) {
      _auth.handleFirebaseAuthError(e);
      print(e.message);
    }   
  }
}

  