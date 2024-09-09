import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final List listProducts = [];
  final bool isLoading = true;
  final MediaType mediaType = MediaType('application', 'json');

  ProductDetailScreen({super.key});

  Future<String?> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
