import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/components/bottomNav.dart';
import 'package:mobile/components/bottomNavShop.dart';
import 'package:mobile/firebase_options.dart';
import 'package:mobile/user/customer/cartList.dart';
import 'package:mobile/user/customer/historyPage.dart';
import 'package:mobile/user/customer/homePage.dart';
import 'package:mobile/user/customer/mailboxDetail.dart';
import 'package:mobile/user/customer/payMent.dart';
import 'package:mobile/user/customer/productDetail.dart';
import 'package:mobile/user/customer/productInshop.dart';
import 'package:mobile/user/customer/reportShop.dart';
import 'package:mobile/user/customer/shopDetail.dart';
import 'package:mobile/user/customer/submitPayment.dart';
import 'package:mobile/user/page/guest.dart';
import 'package:mobile/user/page/guestProduct.dart';
import 'package:mobile/user/page/registerCustomer.dart';
import 'package:mobile/user/page/registerShopkeeper.dart';
import 'package:mobile/user/page/selectMap.dart';
import 'package:mobile/user/page/signIn.dart';
import 'package:mobile/user/page/registerRole.dart';
import 'package:mobile/user/shop/shopAddProductScreen.dart';
import 'package:mobile/user/shop/shopMainScreen.dart';
import 'package:mobile/user/shop/shopManageProductScreen.dart';
import 'package:mobile/user/shop/shopProductDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
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
    return MaterialApp(
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
          '/registerRole/shopkeeper': (context) => RegisterShopkeeper(),
          '/registerRole/shopkeeper/selectMap': (context) => SelectMapLocate(),
          '/home': (context) => Homepage(),
          '/guest': (context) => GuestScreen(),
          // '/guest/productInShop': (context) => GuestProductInShop(),
          '/shop': (context) => BottomNavShop(),
          '/shop/mainScreen': (context) => ShopMainScreen(),
          '/shop/manageProduct': (context) => ManageProductScreen(),
          // '/shop/productDetails': (context) => ProductDetailScreen(),
          // '/customer/productDetail': (context) => ProductDetail(),
          '/shop/addProduct': (context) => AddProductScreen(),
          '/customer': (context) => BottomNavCustomer(),
          ///'/customer/productInshop': (context) => ProductInShop(),
          //'/customer/shopDetail': (context) => Shopdetail(),
          '/customer/cartList': (context) => Cartlist(),
          '/customer/payMent': (context) => Payment(),
          '/customer/historyPage': (context) => Historypage(),
          //'/customer/reportShop': (context) => Reportshop(),
          //'/customer/submitPayment': (context) => Submitpayment(),
          // '/customer/mailboxDetail': (context) => MailBoxDetailPage(),
        });
  }
}
