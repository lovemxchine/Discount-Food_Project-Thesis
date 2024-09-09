import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/components/bottomNav.dart';
import 'package:mobile/user/service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  Future<void> storeUID(String uid, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', uid);
    await prefs.setString('user_role', role);
  }

  // Future<String?> getUID() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('uid');
  // }

  @override
  void initState() {
    super.initState();
    _signOutUser();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  onSubmitted: (String value) {
                    setState(() {
                      email = emailController.text;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.person, color: Color(0xFFFF6838)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFFF6838), width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF6838), // Custom border color
                        width: 2.0, // Custom border width
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  onSubmitted: (String value) {
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
                        borderSide: const BorderSide(
                            color: Color(0xFFFF6838), width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF6838), // Custom border color
                        width: 2.0, // Custom border width
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                        text: 'Sign In as ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF6838),
                            fontFamily: GoogleFonts.mitr().fontFamily),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Guest',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.mitr().fontFamily,
                                  color: Color(0xFFFF6838),
                                  fontSize: 16),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/guest');
                                })
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _signIn();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6838), // Button color
                    minimumSize: Size(600, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                    ),
                  ),
                  child: Text('Submit',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: GoogleFonts.mitr().fontFamily)),
                ),
                const SizedBox(height: 35),
                RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account ? ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: GoogleFonts.mitr().fontFamily),
                        children: <TextSpan>[
                      TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                              color: Color(0xFFFF6838),
                              fontSize: 16,
                              fontFamily: GoogleFonts.mitr().fontFamily),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/registerRole');
                            })
                    ]))
              ],
            )),
      ),
    );
  }

  void _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        print("This Email is registered");
        final url = Uri.parse("http://10.0.2.2:3000/authentication/signIn");
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'checkUID': user.uid,
          }),
        );
        print('User UID: ${user.uid}');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['userStatus'] == 'success') {
            await storeUID(user.uid, responseData['role']);
            switch (responseData['role']) {
              case 'customer':
                Navigator.pushNamed(context, '/customer');
                break;
              case 'shopkeeper':
                Navigator.pushNamed(context, '/shop');
                break;
              default:
                await _auth.signOut();
                break;
            }
            print('regis');
          } else if (responseData['userStatus'] == 'registerShop') {
            await _auth.signOut();
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        'รอการอนุมัติ',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: GoogleFonts.mitr().fontFamily),
                      ),
                      content:
                          const Text('อยู่ในขั้นตอนรอการอนุมัติจากผู้ดูแลระบบ'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, '/registerRole/shopkeeper');
                            Navigator.pop(context);
                          },
                          child: const Text('ยืนยัน'),
                        ),
                      ],
                    ));
          }
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      }
    } on FirebaseAuthException catch (e) {
      _auth.handleFirebaseAuthError(e);
      print(e.message);
    }
  }

  void _signOutUser() async {
    try {
      await _auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
