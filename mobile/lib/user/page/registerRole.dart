import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterRole extends StatelessWidget {
  const RegisterRole({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             ElevatedButton(
            onPressed: () {
             // Navigator.push(context, MaterialPageRoute(builder: (context) => Register())); 
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6838), // Button color
              minimumSize: Size(300, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
            ),
            child:const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                 size: 50,Icons.person,color: Colors.white,),
                SizedBox(width: 20,),
                Text(
                  'สมัครสมาชิกทั่วไป', 
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white)
                    ),
              ],
            ),
          ),
          SizedBox(height: 20,)
          ,ElevatedButton(
            onPressed: () {
             // Navigator.push(context, MaterialPageRoute(builder: (context) => Register())); 
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6838), // Button color
              minimumSize: Size(300, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
            ),
               child:const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                 size: 50,Icons.store,color: Colors.white,),
                SizedBox(width: 20,),
                Text(
                  'สมัครสมาชิกร้านค้า', 
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white)
                    ),
              ],
            ),
          ),
           const SizedBox(height: 80),
          RichText(text: TextSpan(
            text: 'You already have an account ? ',
            style:const  TextStyle(
              color: Color(0xFFFF6838),
              fontSize: 16
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Sign In',
                style:const TextStyle(
                  color: Color.fromARGB(255, 255, 82, 29),
                  fontSize: 18
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/signIn');
                  }
              )
            ]
          ))
          ],),
        ),
      ),
    );
    
  }
}