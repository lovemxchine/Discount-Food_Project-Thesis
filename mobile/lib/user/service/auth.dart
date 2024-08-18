import 'dart:io';

// Remove unused package: package_info
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Future for sign-up with email and password (with error handling)
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user; // Return the created user
    } on FirebaseAuthException catch (e) {
      print('งงเงย');
      handleFirebaseAuthError(e);
      return null;
    } catch (e) {
      print("An unexpected error occurred: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
      return null;
    } catch (e) {
      // Handle other exceptions
      print("An unexpected error occurred: $e");
      return null;
    }
  }

  String handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case "weak-password":
        print('งงเงย');
        return ("รหัสผ่านง่ายเกินไปกรุณาใช้ตัว 6 ตัวขึ้นไป");
      // break;
      case "email-already-in-use":
        print('งงเงยว้พ');

        return ("อีเมล์นี้มีผู้ใช้งานแล้ว");
      // break;
      case "invalid-email":
        return ("รูปแบบอีเมล์ไม่ถูกต้อง");
      // break;
      case "user-not-found":
        return ("The user account does not exist.");
      // break;
      case "wrong-password":
        return ("รหัสผ่านไม่ถูกต้อง");
      // break;
      default:
        return ("An unknown error occurred: ${e.code}");
    }
  }
}
