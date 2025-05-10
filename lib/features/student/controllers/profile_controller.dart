import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:financial_aid_project/data/repositories/users/user_repository.dart';
import 'package:financial_aid_project/data/models/user/user_model.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // Repository to fetch user data
  final userRepository = Get.put(UserRepository());

  // Observable user data
  Rx<UserModel> user = UserModel.empty().obs;

  // Loading state
  RxBool isLoading = false.obs;

  // Editing state
  RxString editingSection = RxString('');

  // Form controllers
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController dobController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController gpaController;

  // Dropdown selections
  RxString selectedGender = RxString('');
  RxString selectedDegreeLevel = RxString('Undergraduate');
  RxString selectedFaculty = RxString('');
  RxString selectedCollege = RxString('');
  RxString selectedDegreeProgram = RxString('');
  RxString selectedScholarshipType = RxString('Merit-Based');
  RxString selectedFinancialStatus = RxString('Self-funded');
  RxString selectedYearOfStudy = RxString('');

  // GPA value
  RxDouble gpa = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    initializeControllers();
  }

  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }

  void initializeControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    dobController = TextEditingController();
    addressController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    gpaController = TextEditingController(text: "0.00");
  }

  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    gpaController.dispose();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final userData = await userRepository.fetchUserDetails();
      user.value = userData;

      // Update controllers with user data
      firstNameController.text = userData.firstName;
      lastNameController.text = userData.lastName;
      emailController.text = userData.email;
      phoneController.text = userData.phoneNumber;

      // Set other fields if they exist
      if (userData.address != null) {
        addressController.text = userData.address!;
      }
      if (userData.gender != null) {
        selectedGender.value = userData.gender!;
      }
      if (userData.dateOfBirth != null) {
        dobController.text = userData.dateOfBirth!;
      }
      if (userData.academicLevel != null) {
        selectedDegreeLevel.value = userData.academicLevel!;
      }
      if (userData.institution != null) {
        selectedCollege.value = userData.institution!;
      }
      if (userData.major != null) {
        selectedDegreeProgram.value = userData.major!;
      }
      if (userData.gpa != null) {
        gpa.value = userData.gpa!;
        gpaController.text = userData.gpa!.toStringAsFixed(2);
      }
    } catch (e) {
      printError(info: 'Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserData() async {
    isLoading.value = true;
    try {
      // Update the user model with new values from controllers
      final updatedUser = UserModel(
        id: user.value.id,
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        userName: user.value.userName,
        phoneNumber: phoneController.text,
        profilePicture: user.value.profilePicture,
        role: user.value.role,

        // Optional fields
        address: addressController.text,
        gender: selectedGender.value,
        dateOfBirth: dobController.text,
        academicLevel: selectedDegreeLevel.value,
        institution: selectedCollege.value,
        major: selectedDegreeProgram.value,
        gpa: double.tryParse(gpaController.text) ?? 0.0,

        // Keep existing values for other fields
        activities: user.value.activities,
        achievements: user.value.achievements,
        appliedScholarships: user.value.appliedScholarships,
        graduationYear: user.value.graduationYear,
        financialAidStatus: selectedFinancialStatus.value,
        needsFinancialAid: user.value.needsFinancialAid,
        nationality: user.value.nationality,

        // Update timestamp
        updatedAt: DateTime.now(),
        createdAt: user.value.createdAt,
      );

      // Save to repository
      await userRepository.updateUserData(updatedUser);

      // Refresh user data
      await fetchUserData();

      // Clear editing state
      editingSection.value = '';

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      printError(info: 'Error updating user data: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setEditingSection(String section) {
    editingSection.value = section;
  }

  void cancelEditing() {
    // Reset controllers to current user values
    firstNameController.text = user.value.firstName;
    lastNameController.text = user.value.lastName;
    emailController.text = user.value.email;
    phoneController.text = user.value.phoneNumber;

    if (user.value.address != null) {
      addressController.text = user.value.address!;
    }
    if (user.value.gender != null) {
      selectedGender.value = user.value.gender!;
    }
    if (user.value.dateOfBirth != null) {
      dobController.text = user.value.dateOfBirth!;
    }

    // Clear editing state
    editingSection.value = '';
  }

  void updateGPA(double value) {
    gpa.value = value;
    gpaController.text = value.toStringAsFixed(2);
  }

  void logout() {
    AuthenticationRepository.instance.logout();
  }
}
