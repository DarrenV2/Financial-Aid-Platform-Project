import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:financial_aid_project/utils/popups/full_screen_loader.dart';
import 'package:financial_aid_project/utils/helpers/network_manager.dart';
import 'package:financial_aid_project/utils/constants/image_strings.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';
import 'package:financial_aid_project/data/repositories/admin/admin_repository.dart';
import 'package:financial_aid_project/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Controller for handling login functionality for both users and admins
class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final adminRepository = Get.put(AdminRepository());

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// Handles email and password sign-in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Logging in...', TImages.regLoadAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'No Internet Connection',
            message: 'Please check your internet connection and try again.');
        return;
      }

      // Validate input
      final trimmedEmail = email.text.trim();
      final trimmedPassword = password.text.trim();

      if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Invalid Input',
            message: 'Please enter both email and password.');
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', trimmedEmail);
        localStorage.write('REMEMBER_ME_PASSWORD', trimmedPassword);
      }

      // Sign in using Email & Password Authentication
      try {
        await AuthenticationRepository.instance.loginWithEmailAndPassword(
          trimmedEmail,
          trimmedPassword,
        );

        // Remove Loader
        TFullScreenLoader.stopLoading();

        // Redirect based on user role
        AuthenticationRepository.instance.screenRedirect();
      } on FirebaseAuthException catch (e) {
        TFullScreenLoader.stopLoading();

        // Handle specific error codes
        if (e.code == 'user-not-found' &&
            trimmedEmail == 'admin@financialaid.com') {
          TLoaders.errorSnackBar(
              title: 'Admin Not Found',
              message:
                  'The admin account has not been created yet. Please contact system administrator.');
        } else {
          TLoaders.errorSnackBar(
              title: 'Login Failed',
              message: 'Invalid email or password. Please try again.');
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Login Failed',
          message: 'An unexpected error occurred. Please try again.');
    }
  }

  /// Handles Google sign-in process
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Logging in with Google...', TImages.regLoadAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'No Internet Connection',
            message: 'Please check your internet connection and try again.');
        return;
      }

      // Sign in using Google Authentication
      await AuthenticationRepository.instance.signInWithGoogle();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect based on user role
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Google Sign In Failed', message: e.toString());
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
