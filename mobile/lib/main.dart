import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/user/page/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return 
    MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: GoogleFonts.mitr().fontFamily,
              brightness: Brightness.light,
              primaryColor: Colors.blue,
            ),
            routes: {
              '/': (context) => Login(),
              // '/login': (context) => Login(),
              // '/admin_reg': (context) => AdminRegister(),
              // '/customer': (context) => const CustomerScreen(),
              // '/chef': (context) => const ChefScreen(),
              // '/manager': (context) => const ManagerScreen(),
              // '/employee': (context) => const EmployeeScreen(),
            }
            );
      
  }
}
