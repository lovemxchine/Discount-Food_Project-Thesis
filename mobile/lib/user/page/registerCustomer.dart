import 'dart:ffi';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterCustomer extends StatefulWidget {
  const RegisterCustomer({super.key});

  @override
  State<RegisterCustomer> createState() => _RegisterCustomerState();
}
 

class _RegisterCustomerState extends State<RegisterCustomer> {
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar( 
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      )
      ,body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            color: const Color.fromARGB(255, 255, 255, 255), 
            child:  Center(
              child:Padding(
                padding: EdgeInsets.only(left: 40,right: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const Text('ตั้งค่าอีเมล์และรหัสผ่าน',
                      style: TextStyle(fontSize: 24)
                    ),
                    const SizedBox(height: 5,),
                    const Text('คุณสามารถใช้สิ่งนี้เพื่อเข้าสู่ระบบ เราจะแนะนำคุณตลอด\nกระบวนการเริ่มต้นใช้งานหลังจากบัญชีของคุณได้รับ\nแล้วสร้าง.',
                    style: TextStyle(color: Color.fromARGB(255, 134, 134, 134)),),
                    const SizedBox(height: 20,),
                    Container(
                      width: 300,
                      height: 40,
                      child: TextField(
                        style: TextStyle(fontSize: 14,color: const Color.fromARGB(255, 61, 61, 61)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0x00E5E5E5))
                          ),
                          hintText: 'name@example.com',
                          hintStyle: TextStyle(fontSize: 12,color: Color.fromARGB(255, 205, 205, 205)),
                          labelText: 'อีเมล',     
                          labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),

                        ),
                        contentPadding: EdgeInsets.all(10)
                        ),
                        )
                      ),
                      const SizedBox(height: 20,),
                                          Container(
                      width: 300,
                      height: 40,
                      child: TextField(
                        obscureText: true,
                        style: TextStyle(fontSize: 14,color: const Color.fromARGB(255, 61, 61, 61)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0x00E5E5E5))
                          ),

                          hintText: 'ป้อนรหัสผ่านที่ปลอดภัย',
                          hintStyle: TextStyle(fontSize: 12,color: Color.fromARGB(255, 205, 205, 205)),
                          labelText: 'รหัสผ่าน',     
                          labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.all(10)
                        ),
                        )
                      ),
                      const SizedBox(height: 60,),
                      if(emailController != '' && passwordController != '')
                      Container(
                        child:const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_downward),
                            SizedBox(width: 10,),
                            Text('เลื่อนเพื่อไปหน้าถัดไป',style: TextStyle(fontSize: 20),),
                            Icon(Icons.arrow_downward,color: Colors.transparent,),

                            ],),)
                    
                    ],
                ),)
              )
              ),
          Container(color: Colors.green, child: Center(child: Text('โซน 2'))),
          Container(color: Colors.blue, child: Center(child: Text('โซน 3'))),
          Container(color: Colors.yellow, child: Center(child: Text('โซน 4'))),
        ],
      )
      ,);
  }
}