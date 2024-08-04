import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/components/textFieldComponent.dart';
import 'package:mobile/user/service/auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class RegisterCustomer extends StatefulWidget {

  @override
  State<RegisterCustomer> createState() => _RegisterCustomerState();
}
 

class _RegisterCustomerState extends State<RegisterCustomer> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  bool firstPageValidate = false;
  bool secondPageValidate = false;
  bool thirdPageValidate = false;
  bool fourthPageValidate = false;

  @override
  void initState(){
    super.initState();
    emailController.addListener(checkFields);
    passwordController.addListener(checkFields);
    nameController.addListener(checkFields);
    surnameController.addListener(checkFields);
    telController.addListener(checkFields);
    birthdayController.addListener(checkFields);
    
  }

 void checkFields() {
    setState(() {
      firstPageValidate = emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
      secondPageValidate = nameController.text.isNotEmpty && surnameController.text.isNotEmpty&& telController.text.isNotEmpty && birthdayController.text.isNotEmpty; 

    });
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
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          SingleChildScrollView(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255), 
              child:Center(
                child:Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40),
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
                        child: buildBorderTextField(emailController, 'อีเมล', 'name@example.com',false),
                        ),
                        const SizedBox(height: 20,),
                                            Container(
                        width: 300,
                        height: 40,
                        child: buildBorderTextField(passwordController, 'รหัสผ่าน', 'ป้อนรหัสผ่านที่ปลอดภัย',true),
                        ),
                        const SizedBox(height: 380,),
                        if(firstPageValidate)
                        const ClipRect(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_downward,color: Colors.grey,),
                                SizedBox(width: 10,),
                                Text('เลื่อนเพื่อไปหน้าถัดไป',style: TextStyle(fontSize: 20,color: Colors.grey),),
                                Icon(Icons.arrow_downward,color: Colors.transparent,),
                          
                                ],),
                        )
                      
                      ],
                  ),)
                )
                ),
          ),
          if(firstPageValidate) 
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 40,right: 40),
              child: Container(
                color: Colors.white, 
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      const SizedBox(height: 20),
                      const Text(
                        'ข้อมูลบัญชี',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'เราจะแสดงข้อมูลด้านล่างในโปรไฟล์ของคุณในการแอพ',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      buildUnderlineTextField(nameController, 'ชื่อ', 'ชื่อ', false),
                      const SizedBox(height: 16),
                      buildUnderlineTextField(surnameController, 'นามสกุล', 'นามสกุล', false),
                      const SizedBox(height: 16),
                      buildUnderlineTextField(telController, 'เบอร์โทรศัพท์', 'เบอร์โทรศัพท์', false),
                      const SizedBox(height: 16),
                      buildDateField(birthdayController, context),
                      const SizedBox(height: 280),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280,
                            child: ElevatedButton(
                              onPressed: ()async {
                                _signUp();
                              },
                              style: ElevatedButton.styleFrom(              
                                backgroundColor: Color.fromARGB(135, 199, 199, 199),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child:const Text('บันทึก',style: TextStyle(color: Color.fromARGB(255, 60, 60, 60),fontSize: 16),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if(firstPageValidate) Container(color: Colors.blue, child: const Center(child: Text('โซน 3'))),
          if(firstPageValidate) Container(color: Colors.yellow, child: const Center(child: Text('โซน 4'))),
        ],
      )
      ,);
  }
Future<void> _signUp() async {
  String email = emailController.text;
  String password = passwordController.text;
  String name = nameController.text;
  String surname = surnameController.text;
  String tel = telController.text;
  String birthday = birthdayController.text;
  
  print(birthday);
  
  try { 
    // User? user = await _auth.signUpWithEmailAndPassword(email, password);
    // if (user != null) {
    //   print('Sign up success');
    //   print(user);
    //   print(user.uid);
    //   print('hello world');
      
      final url = Uri.parse("http://192.168.1.43:8080/api/register/customer"); // ปรับ URL ให้ถูกต้อง
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "uid": "abcdefg", // value.uid
          "email": email,
          "name": name,
          "surname": surname,
          "tel": tel,
          "birthday": birthday,
        }),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    // }
  } on FirebaseAuthException catch (e) {
    _auth.handleFirebaseAuthError(e);
    print(e.message);
  }   
}

}
