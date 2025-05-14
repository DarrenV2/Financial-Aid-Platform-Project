import 'package:financial_aid_project/features/scholarship/models/scholarship.dart';
import 'package:financial_aid_project/features/student/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ScholarshipRecommendationService {
  final ProfileController _profileController =
      Get.find<ProfileController>(tag: 'student');

  // Check if user has enough profile data for recommendations
  bool hasEnoughProfileData() {
    // Check if essential profile fields are filled
    bool hasAcademicInfo = _profileController
            .selectedDegreeLevel.value.isNotEmpty &&
        _profileController.selectedDegreeLevel.value != "Select Degree Level" &&
        _profileController.selectedFaculty.value.isNotEmpty &&
        _profileController.selectedFaculty.value != "Select Faculty" &&
        _profileController.selectedDegreeProgram.value.isNotEmpty &&
        _profileController.selectedDegreeProgram.value != "Select Program" &&
        _profileController.gpaController.text.isNotEmpty;

    bool hasBasicInfo =
        _profileController.firstNameController.text.isNotEmpty &&
            _profileController.lastNameController.text.isNotEmpty;

    return hasAcademicInfo && hasBasicInfo;
  }

  // Get scholarships that match user profile
  List<Scholarship> getRecommendedScholarships(
      List<Scholarship> availableScholarships) {
    if (availableScholarships.isEmpty) {
      return [];
    }

    List<Scholarship> recommendations = [];

    // Get user profile data
    double gpa = double.tryParse(_profileController.gpaController.text) ?? 0.0;
    String degreeProgram = _profileController.selectedDegreeProgram.value;
    bool needsBased = _profileController.selectedFinancialStatus.value ==
        "Government Assistance";

    for (var scholarship in availableScholarships) {
      bool isMatch = false;

      // Merit-based scholarships for users with good GPA
      if (scholarship.meritBased && gpa >= 3.0) {
        isMatch = true;
      }

      // Need-based scholarships for users who need financial assistance
      if (scholarship.needBased && needsBased) {
        isMatch = true;
      }

      // Program-specific scholarships
      if (degreeProgram != "Select Program" &&
          scholarship.title
              .toLowerCase()
              .contains(degreeProgram.toLowerCase())) {
        isMatch = true;
      }

      if (isMatch) {
        recommendations.add(scholarship);
      }
    }

    return recommendations;
  }

  // Get reasons why a scholarship matches the user's profile
  List<String> getMatchReasons(Scholarship scholarship) {
    List<String> reasons = [];

    // Base matches on profile data
    if (scholarship.meritBased &&
        _profileController.gpaController.text.isNotEmpty) {
      double gpa =
          double.tryParse(_profileController.gpaController.text) ?? 0.0;
      if (gpa >= 3.0) {
        reasons.add("Your GPA (${gpa.toStringAsFixed(1)}) qualifies");
      }
    }

    if (scholarship.needBased &&
        _profileController.selectedFinancialStatus.value ==
            "Government Assistance") {
      reasons.add("Matches your financial need");
    }

    // Program specific
    if (scholarship.title.toLowerCase().contains(
            _profileController.selectedDegreeProgram.value.toLowerCase()) &&
        _profileController.selectedDegreeProgram.value != "Select Program") {
      reasons.add(
          "Matches your program (${_profileController.selectedDegreeProgram.value})");
    }

    // Add faculty match if relevant
    if (_profileController.selectedFaculty.value != "Select Faculty") {
      String faculty = _profileController.selectedFaculty.value.split(' ')[0];
      if (scholarship.title.toLowerCase().contains(faculty.toLowerCase())) {
        reasons.add("Matches your faculty");
      }
    }

    // Add year of study if relevant
    if (_profileController.selectedYearOfStudy.value != "Select Year") {
      reasons.add(
          "Available for ${_profileController.selectedYearOfStudy.value} year students");
    }

    // Add general matches if no specific ones are found
    if (reasons.isEmpty) {
      reasons.add("General eligibility match");
    }

    return reasons;
  }
}
