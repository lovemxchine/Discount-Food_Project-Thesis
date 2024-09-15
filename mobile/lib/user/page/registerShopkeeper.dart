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
  final TextEditingController nameShopkeeperController =
      TextEditingController();
  final TextEditingController surnameShopkeeperController =
      TextEditingController();
  final TextEditingController placeShopkeeperController =
      TextEditingController();
  final TextEditingController nationalityShopkeeperController =
      TextEditingController();
  final TextEditingController birthdayShopkeeperController =
      TextEditingController();
  final TextEditingController provinceShopkeeperController =
      TextEditingController();
  final TextEditingController districtShopkeeperController =
      TextEditingController();
  final TextEditingController subdistrictShopkeeperController =
      TextEditingController();
  final TextEditingController postcodeShopkeeperController =
      TextEditingController();
  final TextEditingController telShopkeeperController = TextEditingController();
  final TextEditingController emailShopkeeperController =
      TextEditingController();

  bool firstPageValidate = false;
  bool secondPageValidate = false;
  bool thirdPageValidate = false;
  bool fourthPageValidate = false;
  String? selectedProvince = 'กรุงเทพมหานคร';
  String? selectedDistrict = '';
  String? selectedSubDistrict = '';
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
    nameShopkeeperController.addListener(checkFields);
    surnameShopkeeperController.addListener(checkFields);
    placeShopkeeperController.addListener(checkFields);
    provinceShopkeeperController.addListener(checkFields);
    districtShopkeeperController.addListener(checkFields);
    subdistrictShopkeeperController.addListener(checkFields);
    postcodeShopkeeperController.addListener(checkFields);
    if (provinceToDistricts.isNotEmpty) {
      selectedProvince = provinceToDistricts.keys.first;
      selectedDistrict = provinceToDistricts[selectedProvince]!.first;
      selectedSubDistrict = districtToSubDistricts[selectedDistrict]!.first;
    }
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
          postcodeController.text.isNotEmpty &&
          placeController.text.isNotEmpty;
      thirdPageValidate =
          telController.text.isNotEmpty && emailController.text.isNotEmpty;
      fourthPageValidate = nameShopkeeperController.text.isNotEmpty &&
          surnameShopkeeperController.text.isNotEmpty &&
          placeShopkeeperController.text.isNotEmpty &&
          provinceShopkeeperController.text.isNotEmpty &&
          districtShopkeeperController.text.isNotEmpty &&
          subdistrictShopkeeperController.text.isNotEmpty &&
          postcodeShopkeeperController.text.isNotEmpty;
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
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'ข้อมูลร้านค้า',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'ข้อมูลของผู้ดูแลร้านค้า ไว้ติดต่อร้านค้ากรณีที่เกิดปัญหา',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        buildUnderlineTextField(shopNameController, 'ชื่อร้าน',
                            'ชื่อร้าน', false, false),
                        const SizedBox(height: 16),
                        buildUnderlineTextField(
                            branchController,
                            'ชื่อสาขา / ย่าน (ถ้ามี)',
                            'ชื่อสาขา',
                            false,
                            false),
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
                            false,
                            false),
                        const SizedBox(height: 16),
                        if (selectedProvince != null)
                          SelectOption(
                            label: "จังหวัด",
                            options: provinceToDistricts.keys.toList(),
                            selectedValue: selectedProvince ?? '',
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedProvince = newValue!;
                                selectedDistrict =
                                    provinceToDistricts[selectedProvince]!
                                        .first;
                                selectedSubDistrict =
                                    districtToSubDistricts[selectedDistrict]!
                                        .first;
                              });
                            },
                          ),
                        const SizedBox(height: 16),
                        if (selectedProvince != null)
                          SelectOption(
                            label: "อำเภอ / เขต",
                            options: provinceToDistricts[selectedProvince]!,
                            selectedValue: selectedDistrict ?? '',
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDistrict = newValue!;
                                selectedSubDistrict =
                                    districtToSubDistricts[selectedDistrict]!
                                        .first;
                              });
                            },
                          ),
                        const SizedBox(height: 16),
                        if (selectedProvince != null)
                          SelectOption(
                            label: "ตำบล / แขวง",
                            options: districtToSubDistricts[selectedDistrict]!,
                            selectedValue: selectedSubDistrict ?? '',
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDistrict = newValue!;
                                selectedSubDistrict =
                                    districtToSubDistricts[selectedDistrict]!
                                        .first;
                              });
                            },
                          ),
                        const SizedBox(height: 16),
                        buildUnderlineTextField(postcodeController,
                            'รหัสไปรษณีย์', 'รหัสไปรษณีย์', false, false),
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
                                      : const Color.fromARGB(
                                          135, 199, 199, 199),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  secondPageValidate
                                      ? 'ดำเนินการต่อ'
                                      : 'กรุณากรอกข้อมูลให้ครบ',
                                  style: TextStyle(
                                      color: secondPageValidate
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 60, 60, 60),
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
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ลูกค้าอาจติดต่อคุณไปทางเบอร์โทรศัพท์หรืออีเมลนี้',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      buildUnderlineTextField(telShopkeeperController,
                          'เบอร์โทรศัพท์', 'เบอร์โทรศัพท์', false, false),
                      const SizedBox(height: 16),
                      buildUnderlineTextField(
                          emailController, 'อีเมล', 'อีเมล', false, true),
                      const SizedBox(height: 380),
                      Center(
                        child: SizedBox(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'รายละเอียดร้าน',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ใส่รูปภาพของร้านค้า สินค้าของคุณ เพื่อให้ลูกค้ารับรู้ร้านค้าของคุณ และ ทะเบียนพาณิชย์ไว้สำหรับยืนยันว่าร้านค้าของคุณเป็นร้านค้าที่ถูกต้อง ',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    CustomImageUploadButton(
                        label: 'รูปหน้าปกร้าน', onPressed: () {}),
                    const SizedBox(height: 16),
                    CustomImageUploadButton(
                        label: 'รูปประจำร้าน', onPressed: () {}),
                    const SizedBox(height: 16),
                    CustomImageUploadButton(
                        label: 'ใบทะเบียนพาณิชย์', onPressed: () {}),
                    const SizedBox(height: 166),
                    Center(
                      child: SizedBox(
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
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'ข้อมูลผู้ดูแล',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'เราจะแสดงข้อมูลต่อไปนี้ของคุณให้ลูกค้าบนแอปฯ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: buildUnderlineTextField(
                                  nameShopkeeperController,
                                  'ชื่อ',
                                  'ใส่ชื่อจริงของผู้ดูแลร้าน',
                                  false,
                                  false),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 160,
                              child: buildUnderlineTextField(
                                  surnameShopkeeperController,
                                  'นามสกุล ',
                                  'ใส่นามสกุลของผู้ดูแล',
                                  false,
                                  false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        buildUnderlineTextField(nationalityShopkeeperController,
                            'เชื้อชาติ', 'เชื้อชาติ', false, false),
                        const SizedBox(height: 8),
                        buildUnderlineTextField(
                            placeShopkeeperController,
                            'ที่อยู่อาศัย (โดยละเอียด)',
                            'กรอกเลขที่บ้านพร้อมชื่อถนน หรืออสถานที่ใกล้เคียง',
                            false,
                            false),
                        const SizedBox(height: 16),
                        if (selectedProvince != null)
                          SelectOption(
                            label: "จังหวัด",
                            options: provinceToDistricts.keys.toList(),
                            selectedValue: selectedProvince ?? '',
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedProvince = newValue!;
                                selectedDistrict =
                                    provinceToDistricts[selectedProvince]!
                                        .first;
                                selectedSubDistrict =
                                    districtToSubDistricts[selectedDistrict]!
                                        .first;
                              });
                            },
                          ),
                        const SizedBox(height: 16),
                        if (selectedProvince != null)
                          SelectOption(
                            label: "อำเภอ / เขต",
                            options: provinceToDistricts[selectedProvince]!,
                            selectedValue: selectedDistrict ?? '',
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDistrict = newValue!;
                                selectedSubDistrict =
                                    districtToSubDistricts[selectedDistrict]!
                                        .first;
                              });
                            },
                          ),
                        const SizedBox(height: 16),
                        if (selectedProvince != null)
                          SelectOption(
                            label: "ตำบล / แขวง",
                            options: districtToSubDistricts[selectedDistrict]!,
                            selectedValue: selectedSubDistrict ?? '',
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDistrict = newValue!;
                                selectedSubDistrict =
                                    districtToSubDistricts[selectedDistrict]!
                                        .first;
                              });
                            },
                          ),
                        const SizedBox(height: 16),
                        buildUnderlineTextField(postcodeShopkeeperController,
                            'รหัสไปรษณีย์', 'รหัสไปรษณีย์', false, false),
                        const SizedBox(height: 68),
                        Center(
                          child: SizedBox(
                            width: 280,
                            child: ElevatedButton(
                              onPressed: fourthPageValidate ? _signUp : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: fourthPageValidate
                                    ? Colors.blue
                                    : const Color.fromARGB(135, 199, 199, 199),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                fourthPageValidate
                                    ? 'ดำเนินการต่อ'
                                    : 'กรุณากรอกข้อมูลให้ครบ',
                                style: TextStyle(
                                    color: fourthPageValidate
                                        ? Colors.white
                                        : const Color.fromARGB(255, 60, 60, 60),
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

      final url = Uri.parse("http://10.0.2.2:3000/api/register/Shopkeeper");
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

  void checkSendData() async {
    // nextPage();
    print('Test');
    try {
      final url = Uri.parse("http://10.0.2.2:3000/testcheck");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "temporaryUID": "test_regis_shop",
          "name": nameShopkeeperController.text,
          "surname": surnameShopkeeperController.text,
          "place": placeShopkeeperController.text,
          "nationality": nationalityShopkeeperController.text,
          "email": emailShopkeeperController.text,
          "tel": telShopkeeperController.text,
          "shopLocation": {
            "province": selectedProvince,
            "district": selectedDistrict,
            "subdistrict": selectedSubDistrict,
            "postcode": postcodeController.text,
          }
        }),
      );
      print('Test');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      // }
    } catch (e) {
      print(e);
      print('dotenv error');
    }
  }
}
