import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mobile/components/textFieldComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final PageController _pageController = PageController();
  final List listProducts = [];
  final bool isLoading = true;
  final MediaType mediaType = MediaType('application', 'json');
  final ImagePicker picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController originalPrice = TextEditingController();
  final TextEditingController salePrice = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController expiredDate = TextEditingController();
  File? _image;
  File? _imageGemini;
  var pathAPI = "http://10.0.2.2:3000";
  var uid = '';

  Future<void> addProduct() async {
    uid = await getUID() ?? '';
    if (uid.isEmpty) {
      print('User UID not found');
      return;
    }

    try {
      final url = Uri.parse("$pathAPI/shop/product/addProduct");
      var request = http.MultipartRequest('POST', url);
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
      request.fields['uid'] = uid;
      request.fields['product_name'] = nameController.text;
      request.fields['original_price'] = originalPrice.text;
      request.fields['sale_price'] = salePrice.text;
      request.fields['stock'] = stock.text;
      request.fields['expired_date'] = expiredDate.text;

      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Product added successfully');
        Navigator.pop(context, true);
      } else {
        print('Failed to add product with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<String?> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid');
  }

  Future<void> sentImageGemini() async {
    if (_imageGemini == null) {
      print('No image selected');

      return;
    }

    var url = Uri.parse(pathAPI + '/gemini/OCR');
    var request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('image', _imageGemini!.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        print(jsonDecode(response.body));
        var resData = jsonDecode(response.body);
        print(resData['product_name']);
        print(resData['old_price']);
        print(resData['new_price']);
        print(resData['expiry_date']);
        setState(() {
          nameController.text = resData['product_name'].toString();
          originalPrice.text = resData['old_price'].toString();
          salePrice.text = resData['new_price'].toString();
          expiredDate.text = resData['expiry_date'].toString();
        });
      } else {
        // print(jsonDecode(response.body));
        print(response.statusCode);
        print(response.body);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  // image picker for gemini
  Future getImageGemini() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _imageGemini = File(pickedFile.path);
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> openCameraGemini(BuildContext context) async {
    final XFile? _imageGemini =
        await picker.pickImage(source: ImageSource.camera);
    if (_imageGemini != null) {
      // Handle the captured image
      print('Image path: ${_imageGemini.path}');
    }
  }

  void showPickerGemini(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImageGemini();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  openCameraGemini(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

//image picker
  Future getImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> openCamera(BuildContext context) async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Handle the captured image
      print('Image path: ${image.path}');
    }
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  openCamera(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 224, 217, 217),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 217, 217),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Container(
                height: 620,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 219, 219, 219),
                  border: Border.all(
                    color: const Color.fromARGB(
                        255, 175, 175, 175), // Set the border color here
                    width: 1.0, // Set the border width here
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey, // Set the border color here
                            width: 1.0, // Set the border width here
                          ),
                          image: DecorationImage(
                            image: _image != null && _image!.existsSync()
                                ? FileImage(_image!)
                                : const AssetImage('assets/images/alt.png')
                                    as ImageProvider<Object>,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => showPicker(context),
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 55,
                                  width: 60,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                    color: Colors.grey,
                                  ),
                                  child: const Icon(Icons.camera_alt),
                                ),
                                const Text('เลือกรูปภาพสินค้า'),
                                Container(
                                  height: 55,
                                  width: 60,
                                )
                              ]),
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildUnderlineTextField(nameController, 'ชื่อสินค้า',
                          'กรอกชื่อสินค้า', false, false),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: buildUnderlineTextField(originalPrice,
                                'ราคาดั้งเดิม', 'ราคาดั้งเดิม', false, false),
                          ),
                          const SizedBox(width: 60),
                          Expanded(
                            child: buildUnderlineTextField(
                                salePrice, 'ราคาขาย', 'ราคาขาย', false, false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 190),
                        child: buildUnderlineTextField(
                            stock, 'จำนวนสินค้า', 'จำนวนสินค้า', false, false),
                      ),
                      const SizedBox(height: 10),
                      customDateField(expiredDate, context, 'วันหมดอายุ'),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              showPickerGemini(context);
                            },
                            child: Container(
                              height: 40,
                              width: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, color: Colors.blue),
                                  SizedBox(width: 4),
                                  Center(
                                    child: Text(
                                      'เพิ่มข้อมูลจากป้ายสินค้า',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _imageGemini != null ? sentImageGemini() : null;
                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Text('ยืนยัน',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  addProduct();
                },
                child: Container(
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green,
                  ),
                  child: const Center(
                    child: Text('เพิ่มสินค้า',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
