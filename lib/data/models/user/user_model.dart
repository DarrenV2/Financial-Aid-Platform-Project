import 'package:financial_aid_project/utils/constants/enums.dart';
import 'package:financial_aid_project/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing user data.
class UserModel {
  final String? id;
  String firstName;
  String lastName;
  String userName;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;

  // Academic information (optional)
  String? institution;
  String? faculty;
  String? major;
  double? gpa;
  int? graduationYear;
  String? academicLevel; // Undergraduate, Graduate, etc.
  String? yearOfStudy;

  // Financial information (optional)
  bool? needsFinancialAid;
  String? financialAidStatus;

  // Personal information (optional)
  String? dateOfBirth;
  String? nationality;
  String? gender;
  String? address;

  // Extracurricular information (optional)
  List<String>? activities;
  List<String>? achievements;

  // Application tracking
  List<String>? appliedScholarships;

  DateTime? createdAt;
  DateTime? updatedAt;

  /// Constructor for UserModel.
  UserModel({
    this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,

    // Optional fields
    this.institution,
    this.faculty,
    this.major,
    this.gpa,
    this.graduationYear,
    this.academicLevel,
    this.yearOfStudy,
    this.needsFinancialAid,
    this.financialAidStatus,
    this.dateOfBirth,
    this.nationality,
    this.gender,
    this.address,
    this.activities,
    this.achievements,
    this.appliedScholarships,
    this.createdAt,
    this.updatedAt,
  });

  /// Helper methods
  String get fullName => '$firstName $lastName';
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to create an empty user model.
  static UserModel empty() => UserModel(email: '');

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.name.toString(),

      // Optional fields - only include if they have values
      if (institution != null) 'Institution': institution,
      if (faculty != null) 'Faculty': faculty,
      if (major != null) 'Major': major,
      if (gpa != null) 'GPA': gpa,
      if (graduationYear != null) 'GraduationYear': graduationYear,
      if (academicLevel != null) 'AcademicLevel': academicLevel,
      if (yearOfStudy != null) 'YearOfStudy': yearOfStudy,
      if (needsFinancialAid != null) 'NeedsFinancialAid': needsFinancialAid,
      if (financialAidStatus != null) 'FinancialAidStatus': financialAidStatus,
      if (dateOfBirth != null) 'DateOfBirth': dateOfBirth,
      if (nationality != null) 'Nationality': nationality,
      if (gender != null) 'Gender': gender,
      if (address != null) 'Address': address,
      if (activities != null) 'Activities': activities,
      if (achievements != null) 'Achievements': achievements,
      if (appliedScholarships != null)
        'AppliedScholarships': appliedScholarships,

      'CreatedAt': createdAt ?? DateTime.now(),
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data.containsKey('FirstName') ? data['FirstName'] ?? '' : '',
        lastName: data.containsKey('LastName') ? data['LastName'] ?? '' : '',
        userName: data.containsKey('UserName') ? data['UserName'] ?? '' : '',
        email: data.containsKey('Email') ? data['Email'] ?? '' : '',
        phoneNumber:
            data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
        profilePicture: data.containsKey('ProfilePicture')
            ? data['ProfilePicture'] ?? ''
            : '',
        role: data.containsKey('Role')
            ? (data['Role'] ?? AppRole.user) == AppRole.admin.name.toString()
                ? AppRole.admin
                : AppRole.user
            : AppRole.user,

        // Optional fields
        institution: data['Institution'],
        faculty: data['Faculty'],
        major: data['Major'],
        gpa: data['GPA'],
        graduationYear: data['GraduationYear'],
        academicLevel: data['AcademicLevel'],
        yearOfStudy: data['YearOfStudy'],
        needsFinancialAid: data['NeedsFinancialAid'],
        financialAidStatus: data['FinancialAidStatus'],
        dateOfBirth: data['DateOfBirth'],
        nationality: data['Nationality'],
        gender: data['Gender'],
        address: data['Address'],
        activities: data['Activities'] != null
            ? List<String>.from(data['Activities'])
            : null,
        achievements: data['Achievements'] != null
            ? List<String>.from(data['Achievements'])
            : null,
        appliedScholarships: data['AppliedScholarships'] != null
            ? List<String>.from(data['AppliedScholarships'])
            : null,

        createdAt: data.containsKey('CreatedAt')
            ? data['CreatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
        updatedAt: data.containsKey('UpdatedAt')
            ? data['UpdatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
      ); // UserModel
    } else {
      return empty();
    }
  }
}
