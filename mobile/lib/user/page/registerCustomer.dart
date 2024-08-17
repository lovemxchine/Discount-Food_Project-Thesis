import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/components/textFieldComponent.dart';
import 'package:mobile/user/service/auth.dart';
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
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(checkFields);
    passwordController.addListener(checkFields);
    nameController.addListener(checkFields);
    surnameController.addListener(checkFields);
    telController.addListener(checkFields);
    birthdayController.addListener(checkFields);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void checkFields() {
    setState(() {
      firstPageValidate =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
      secondPageValidate = nameController.text.isNotEmpty &&
          surnameController.text.isNotEmpty &&
          telController.text.isNotEmpty &&
          birthdayController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<bool> _onWillPop() async {
    if (currentPage > 0) {
      previousPage();
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: currentPage == 1
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                )
              : null,
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SingleChildScrollView(
              child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('ตั้งค่าอีเมล์และรหัสผ่าน',
                            style: TextStyle(fontSize: 24)),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'คุณสามารถใช้สิ่งนี้เพื่อเข้าสู่ระบบ เราจะแนะนำคุณตลอด\nกระบวนการเริ่มต้นใช้งานหลังจากบัญชีของคุณได้รับ\nแล้วสร้าง.',
                          style: TextStyle(
                              color: Color.fromARGB(255, 134, 134, 134)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300,
                          height: 40,
                          child: buildBorderTextField(emailController, 'อีเมล',
                              'name@example.com', false),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300,
                          height: 40,
                          child: buildBorderTextField(passwordController,
                              'รหัสผ่าน', 'ป้อนรหัสผ่านที่ปลอดภัย', true),
                        ),
                        const SizedBox(
                          height: 380,
                        ),
                        SizedBox(
                          width: 230,
                          child: ElevatedButton(
                            onPressed: firstPageValidate ? nextPage : null,
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              backgroundColor:
                                  firstPageValidate ? Colors.blue : Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              'ไปหน้าถัดไป',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: GoogleFonts.mitr().fontFamily,
                                  color: firstPageValidate
                                      ? Colors.white
                                      : const Color.fromARGB(255, 56, 56, 56)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 40, right: 40),
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
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'เราจะแสดงข้อมูลด้านล่างในโปรไฟล์ของคุณในการแอพ',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      buildUnderlineTextField(
                          nameController, 'ชื่อ', 'ชื่อ', false, false),
                      const SizedBox(height: 16),
                      buildUnderlineTextField(surnameController, 'นามสกุล',
                          'นามสกุล', false, false),
                      const SizedBox(height: 16),
                      buildUnderlineTextField(telController, 'เบอร์โทรศัพท์',
                          'เบอร์โทรศัพท์', false, false),
                      const SizedBox(height: 16),
                      buildDateField(birthdayController, context),
                      const SizedBox(height: 280),
                      Center(
                        child: SizedBox(
                          width: 230,
                          child: ElevatedButton(
                            onPressed: secondPageValidate ? alert1 : null,
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              backgroundColor: secondPageValidate
                                  ? Colors.blue
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              'ยืนยันการสมัคร',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: GoogleFonts.mitr().fontFamily,
                                  color: secondPageValidate
                                      ? Colors.white
                                      : const Color.fromARGB(255, 56, 56, 56)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        print('Sign up success');
        print(user);
        print(user.uid);
        print('hello world');

        final url = Uri.parse("http://10.0.2.2:3000/api/register/customer");
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "uid": user.uid, // value.uid
            "email": email,
            "name": name,
            "surname": surname,
            "tel": tel,
            "birthday": birthday,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  title: Center(
                    child: Text(
                      response.statusCode == 200
                          ? 'สมัครสมาชิกสำเร็จ'
                          : 'ล้มเหลว',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: GoogleFonts.mitr().fontFamily,
                          color: const Color.fromARGB(255, 56, 56, 56)),
                    ),
                  ),
                  content: Text(
                    'สมัครสมาชิกสำเร็จ สามารถใช้งานแอพพลิเคชั่นได้',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: GoogleFonts.mitr().fontFamily,
                        color: const Color.fromARGB(255, 56, 56, 56)),
                  ),
                  actions: <Widget>[
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/registerRole/shopkeeper');
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.mitr().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
      }
    } on FirebaseAuthException catch (e) {
      _auth.handleFirebaseAuthError(e);
      print(e.message);
      // print('dotenv error');
    }
  }

  // Future<bool> _checkIfEmailExists(String email) async {
  //   final result = await _firestore
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get();
  //   return result.docs.isNotEmpty;
  // }
  void alert1() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              title: Center(
                child: Text(
                  'สมัครสมาชิกสำเร็จ',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: GoogleFonts.mitr().fontFamily,
                      color: const Color.fromARGB(255, 56, 56, 56)),
                ),
              ),
              content: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '  สมัครสมาชิก',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: GoogleFonts.mitr().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(text: '  '),
                    TextSpan(
                      text: 'สำเร็จ',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: GoogleFonts.mitr().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(text: '  '),
                    TextSpan(
                      text: 'เรียบร้อย  ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: GoogleFonts.mitr().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/registerRole/shopkeeper');
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: GoogleFonts.mitr().fontFamily),
                    ),
                  ),
                ),
              ],
            ));
  }
}
