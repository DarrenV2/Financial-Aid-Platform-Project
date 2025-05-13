import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/utils/exceptions/platform_exceptions.dart';
import 'package:financial_aid_project/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:financial_aid_project/utils/exceptions/firebase_exceptions.dart';
import 'package:financial_aid_project/utils/exceptions/format_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:financial_aid_project/routes/routes.dart';
import 'package:financial_aid_project/data/repositories/admin/admin_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
// Firebase Auth Instance
  final _auth = FirebaseAuth.instance;
  final _adminRepository = Get.put(AdminRepository());
// Get Authenticated User Data
  User? get authUser => _auth.currentUser;

// Get IsAuthenticated User
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    _auth.setPersistence(Persistence.LOCAL);
  }

  // Explicitly set Firebase Auth persistence to LOCAL
  Future<void> setAuthPersistence() async {
    try {
      await _auth.setPersistence(Persistence.LOCAL);
    } catch (e) {
      // Silently handle errors
    }
  }

// Function to determine the relevant screen and redirect accordingly.
  void screenRedirect() async {
    final user = _auth.currentUser;

    // If the user is logged in
    if (user != null) {
      // Check if the user is an admin
      final isAdmin = await _adminRepository.isUserAdmin();

      if (isAdmin) {
        // Navigate to Admin Dashboard
        Get.offAllNamed(TRoutes.adminDashboard);
      } else {
        // Navigate to User Dashboard
        Get.offAllNamed(TRoutes.userDashboard);
      }
    } else {
      Get.offAllNamed(TRoutes.home);
    }
  }

// LOGIN
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

// REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

// REGISTER USER BY ADMIN

// EMAIL VERIFICATION

//forget password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

//re authenticate user

//logout user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(TRoutes.home);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

//delete user
}
