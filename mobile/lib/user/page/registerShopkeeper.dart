import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/components/textFieldComponent.dart';
import 'package:mobile/user/service/auth.dart';
import 'package:http/http.dart' as http;

class RegisterShopkeeper extends StatefulWidget {
  @override
  State<RegisterShopkeeper> createState() => _RegisterShopkeeperState();
}

class _RegisterShopkeeperState extends State<RegisterShopkeeper> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  bool firstPageValidate = false;
  bool secondPageValidate = false;
  bool thirdPageValidate = false;
  bool fourthPageValidate = false;
  String selectedProvince = 'กรุงเทพมหานคร';
  String selectedDistrict = '';
  String selectedSubDistrict = '';
  int currentPage = 0;

  final PageController _pageController = PageController();

  final Map<String, List<String>> provinceToDistricts = {
    'กรุงเทพมหานคร': ['เขตพระนคร', 'เขตดุสิต', 'เขตหนองจอก'],
    'นนทบุรี': ['เมืองนนทบุรี', 'บางกรวย', 'บางใหญ่'],
    'ปทุมธานี': ['เมืองปทุมธานี', 'คลองหลวง', 'ธัญบุรี'],
  };
  final Map<String, List<String>> districtToSubDistricts = {
    'เขตพระนคร': ['แขวงพระบรมมหาราชวัง', 'แขวงวังบูรพาภิรมย์'],
    'เขตดุสิต': ['แขวงดุสิต', 'แขวงวชิรพยาบาล'],
    'เขตหนองจอก': ['แขวงกระทุ่มราย', 'แขวงหนองจอก'],
    'เมืองนนทบุรี': ['ตำบลสวนใหญ่', 'ตำบลบางเขน'],
    'บางกรวย': ['ตำบลบางกรวย', 'ตำบลบางขนุน'],
    'บางใหญ่': ['ตำบลบางใหญ่', 'ตำบลเสาธงหิน'],
    'เมืองปทุมธานี': ['ตำบลบางปรอก', 'ตำบลบางพูด'],
    'คลองหลวง': ['ตำบลคลองหนึ่ง', 'ตำบลคลองสอง'],
    'ธัญบุรี': ['ตำบลรังสิต', 'ตำบลประชาธิปัตย์'],
  };
  @override
  void initState() {
    super.initState();
    emailController.addListener(checkFields);
    passwordController.addListener(checkFields);
    shopNameController.addListener(checkFields);
    placeController.addListener(checkFields);
    postcodeController.addListener(checkFields);
    telController.addListener(checkFields);
    birthdayController.addListener(checkFields);
    selectedDistrict = provinceToDistricts[selectedProvince]!.first;
    selectedSubDistrict = districtToSubDistricts[selectedDistrict]!.first;
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
      secondPageValidate = shopNameController.text.isNotEmpty &&
          // branchController.text.isNotEmpty &&
          postcodeController.text.isNotEmpty &&
          placeController.text.isNotEmpty;
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
    // ignore: deprecated_member_use
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
          // scrollDirection: Axis.vertical,
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('ตั้งค่าอีเมล์และรหัสผ่าน',
                                style: TextStyle(fontSize: 24)),
                          ],
                        ),
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
                        // const ClipRect(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Icon(
                        //         Icons.arrow_downward,
                        //         color: Colors.grey,
                        //       ),
                        //       SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         'ไปหน้าถัดไป',
                        //         style:
                        //             TextStyle(fontSize: 20, color: Colors.grey),
                        //       ),
                        //       Icon(
                        //         Icons.arrow_downward,
                        //         color: Colors.transparent,
                        //       ),
                        //     ],
                        //   ),
                        // )
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
                        'ข้อมูลร้านค้า',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'เราจะแสดงข้อมูลต่อไปนี้ของคุณให้ลูกค้าบนแอปฯ',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      buildUnderlineTextField(
                          shopNameController, 'ชื่อร้าน', 'ชื่อร้าน', false),
                      const SizedBox(height: 16),
                      buildUnderlineTextField(branchController,
                          'ชื่อสาขา / ย่าน (ถ้ามี)', 'ชื่อสาขา', false),
                      const SizedBox(height: 16),
                      const Text('ที่อยู่ร้าน'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Add your button press logic here
                          },
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD1D1D1)),
                            elevation: 1,
                            shadowColor: Colors.black.withOpacity(0.1),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined,
                                  color: Colors.grey[600], size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'ปักหมุดที่ตั้งร้าน',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.mitr().fontFamily,
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(Icons.location_on_outlined,
                                  color: Colors.transparent, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      buildUnderlineTextField(
                          placeController,
                          'เลขที่อยู่ร้าน หรือ ข้อมูลสถานที่ตั้งร้าน (โดยละเอียด)',
                          'กรอกเลขที่บ้านพร้อมชื่อถนน หรืออสถานที่ใกล้เคียง',
                          false),
                      const SizedBox(height: 16),
                      SelectOption(
                        label: "จังหวัด",
                        options: provinceToDistricts.keys.toList(),
                        selectedValue: selectedProvince,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedProvince = newValue!;
                            selectedDistrict =
                                provinceToDistricts[selectedProvince]!.first;
                            selectedSubDistrict =
                                districtToSubDistricts[selectedDistrict]!.first;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SelectOption(
                        label: "อำเภอ / เขต",
                        options: provinceToDistricts[selectedProvince]!,
                        selectedValue: selectedDistrict,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDistrict = newValue!;
                            selectedSubDistrict =
                                districtToSubDistricts[selectedDistrict]!.first;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SelectOption(
                        label: "ตำบล / แขวง",
                        options: districtToSubDistricts[selectedDistrict]!,
                        selectedValue: selectedSubDistrict,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDistrict = newValue!;
                            selectedSubDistrict =
                                districtToSubDistricts[selectedDistrict]!.first;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      buildUnderlineTextField(postcodeController,
                          'รหัสไปรษณีย์', 'รหัสไปรษณีย์', false),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280,
                            child: ElevatedButton(
                              onPressed: secondPageValidate ? nextPage : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondPageValidate
                                    ? Colors.blue
                                    : const Color.fromARGB(135, 199, 199, 199),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                'ดำเนินการต่อ',
                                style: TextStyle(
                                    color: secondPageValidate
                                        ? Colors.white
                                        : const Color.fromARGB(255, 60, 60, 60),
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'รายละเอียดสำหรับติดต่อร้านค้า',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ลูกค้าอาจติดต่อคุณไปทางเบอร์โทรศัพท์หรืออีเมลนี้',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      buildUnderlineTextField(telController, 'เบอร์โทรศัพท์',
                          'เบอร์โทรศัพท์', false),
                      const SizedBox(height: 16),
                      buildUnderlineTextField(
                          emailController, 'อีเมล', 'อีเมล', false),
                      const SizedBox(height: 280),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280,
                            child: ElevatedButton(
                              onPressed: secondPageValidate ? nextPage : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(135, 199, 199, 199),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'บันทึก',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 60, 60, 60),
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'รายละเอียดร้าน',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'กรอกข้อมูลให้ครบถ้วนเพื่อให้ลูกค้าติดต่อได้',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'ชื่อร้าน*',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'แนะนำชื่อร้าน รูปแบบการขาย และ สินค้าที่ขายหลักๆ',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  _buildImageUploadButton('รูปหน้าร้าน'),
                  SizedBox(height: 16),
                  _buildImageUploadButton('รูปโปรไฟล์'),
                  SizedBox(height: 16),
                  _buildImageUploadButton('รูปพื้นหลังร้าน'),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('ถัดไป'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
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
    String name = shopNameController.text;
    // String surname = surnameController.text;
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

      final url = Uri.parse("http://192.168.1.43:8080/api/register/Shopkeeper");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "uid": "hahahaa", // value.uid
          "email": email,
          "name": name,
          // "surname": surname,
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
      print('dotenv error');
    }
  }
}
