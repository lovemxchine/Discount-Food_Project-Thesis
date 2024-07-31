import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const  Login({super.key});

  @override
  State<Login> createState() => _LoginState();

}

class _LoginState extends State<Login> {
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
                  color: Color(0xFFFF6838)
                    ),
                  ),            
                ),
              ),
              const SizedBox( height: 20,),
              ElevatedButton(
            onPressed: () {
              // request api to login
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
            ],
          )
        ),
      ),
    );
  }
}