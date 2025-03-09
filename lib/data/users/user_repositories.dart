import 'package:get/get.dart';
import 'package:financial_aid_project/data/repositories/authentication/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_aid_project/utils/exceptions/platform_exceptions.dart';
import 'package:financial_aid_project/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:financial_aid_project/utils/exceptions/format_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save user data to Firestore.
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchAdminDetails() async {
    try {
      final docSnapsnot = await _db
          .collection('Users')
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .get();
      return UserModel.fromSnapshot(docSnapsnot);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
