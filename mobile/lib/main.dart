import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/firebase_options.dart';
import 'package:mobile/user/page/registerCustomer.dart';
import 'package:mobile/user/page/registerShopkeeper.dart';
import 'package:mobile/user/page/signIn.dart';
import 'package:mobile/user/page/registerRole.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

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
              '/': (context) => SignIn(),
              '/signIn': (context) => SignIn(),
              '/registerRole': (context) => RegisterRole(),
              '/registerRole/customer': (context) => RegisterCustomer(),
              '/registerRole/shopkeeper': (context) =>  RegisterShopkeeper(),
              // '/manager': (context) => const ManagerScreen(),
              // '/employee': (context) => const EmployeeScreen(),
              // 8;p
            }
            );
      
  }
}
