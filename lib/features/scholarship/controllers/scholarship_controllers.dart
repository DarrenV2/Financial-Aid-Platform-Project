import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/scholarship.dart';
import '../services/scholarship_recommendation_service.dart';
import 'package:financial_aid_project/features/student/controllers/profile_controller.dart';

/// Controller for managing scholarships.
class ScholarshipController extends GetxController {
  static ScholarshipController get instance => Get.find();

  // Firebase reference
  final _db = FirebaseFirestore.instance;

  // Recommendation service
  late final ScholarshipRecommendationService _recommendationService;

  // Observable scholarship list
  final RxList<Scholarship> scholarships = <Scholarship>[].obs;

  // Recommended scholarships
  final RxList<Scholarship> recommendedScholarships = <Scholarship>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error state
  final RxString errorMessage = ''.obs;

  // Success message
  final RxString successMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Make sure the ProfileController is registered with tag 'student'
    if (!Get.isRegistered<ProfileController>(tag: 'student')) {
      Get.put(ProfileController(), tag: 'student');
    }
    _recommendationService = ScholarshipRecommendationService();
    fetchScholarships();
  }

  /// Fetch all scholarships from Firestore.
  Future<void> fetchScholarships() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final QuerySnapshot snapshot = await _db.collection('scholarships').get();

      final List<Scholarship> scholarshipsList =
          snapshot.docs.map((doc) => Scholarship.fromFirestore(doc)).toList();

      scholarships.value = scholarshipsList;
    } catch (e) {
      // Error logging should be implemented in a production environment
      errorMessage.value = 'Failed to fetch scholarships: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user has enough profile data for recommendations
  bool hasEnoughProfileData() {
    return _recommendationService.hasEnoughProfileData();
  }

  /// Get recommended scholarships based on user profile
  List<Scholarship> getRecommendedScholarships() {
    if (!hasEnoughProfileData()) {
      return [];
    }

    final recommendations =
        _recommendationService.getRecommendedScholarships(scholarships);
    recommendedScholarships.value = recommendations;
    return recommendations;
  }

  /// Get reasons why a scholarship matches the user's profile
  List<String> getScholarshipMatchReasons(Scholarship scholarship) {
    return _recommendationService.getMatchReasons(scholarship);
  }

  /// Create a new scholarship
  Future<bool> createScholarship(Scholarship scholarship) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Generate a new document ID
      final docRef =
          FirebaseFirestore.instance.collection('scholarships').doc();

      // Set ID and other properties
      final newScholarship = scholarship.copyWith(
        id: docRef.id,
        scrapedDate: DateTime.now(),
      );

      // Save to Firestore
      await docRef.set(newScholarship.toFirestore());

      // Add to local list
      scholarships.add(newScholarship);

      successMessage.value = 'Scholarship created successfully';
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to create scholarship: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing scholarship
  Future<bool> updateScholarship(Scholarship scholarship) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('scholarships')
          .doc(scholarship.id)
          .update(scholarship.toFirestore());

      // Update in local list
      final index = scholarships.indexWhere((s) => s.id == scholarship.id);
      if (index != -1) {
        scholarships[index] = scholarship;
      }

      successMessage.value = 'Scholarship updated successfully';
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update scholarship: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a scholarship
  Future<bool> deleteScholarship(String scholarshipId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('scholarships')
          .doc(scholarshipId)
          .delete();

      // Remove from local list
      scholarships.removeWhere((s) => s.id == scholarshipId);

      successMessage.value = 'Scholarship deleted successfully';
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete scholarship: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered scholarships based on criteria.
  List<Scholarship> getFilteredScholarships({
    bool? meritBased,
    bool? needBased,
    double? minGpa,
    List<String>? categories,
  }) {
    return scholarships.where((scholarship) {
      // Filter by merit-based
      if (meritBased != null && scholarship.meritBased != meritBased) {
        return false;
      }

      // Filter by need-based
      if (needBased != null && scholarship.needBased != needBased) {
        return false;
      }

      // Filter by GPA requirement
      if (minGpa != null &&
          scholarship.requiredGpa != null &&
          scholarship.requiredGpa! > minGpa) {
        return false;
      }

      // Filter by categories
      if (categories != null && categories.isNotEmpty) {
        if (!scholarship.categories.any((cat) => categories.contains(cat))) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Get a list of all scholarships for the UI.
  List<Scholarship> getScholarships() {
    // If scholarships haven't been fetched yet, return empty list
    if (scholarships.isEmpty && !isLoading.value) {
      fetchScholarships();
    }

    return scholarships;
  }

  /// Get a scholarship by ID.
  Future<Scholarship?> getScholarshipById(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection('scholarships').doc(id).get();

      if (doc.exists) {
        return Scholarship.fromFirestore(doc);
      }

      return null;
    } catch (e) {
      errorMessage.value = 'Failed to fetch scholarship: $e';
      return null;
    }
  }

  /// Search scholarships by keyword.
  List<Scholarship> searchScholarships(String keyword) {
    if (keyword.isEmpty) {
      return scholarships;
    }

    final String searchTerm = keyword.toLowerCase();

    return scholarships.where((scholarship) {
      return scholarship.title.toLowerCase().contains(searchTerm) ||
          scholarship.description.toLowerCase().contains(searchTerm) ||
          (scholarship.eligibility?.toLowerCase().contains(searchTerm) ??
              false) ||
          scholarship.categories
              .any((category) => category.toLowerCase().contains(searchTerm));
    }).toList();
  }

  /// Get the latest scholarships by scraped date.
  List<Scholarship> getLatestScholarships({int limit = 10}) {
    final List<Scholarship> sortedList = List<Scholarship>.from(scholarships);

    // Sort by scraped date (newest first)
    sortedList.sort((a, b) {
      if (a.scrapedDate == null && b.scrapedDate == null) return 0;
      if (a.scrapedDate == null) return 1;
      if (b.scrapedDate == null) return -1;
      return b.scrapedDate!.compareTo(a.scrapedDate!);
    });

    // Return up to the specified limit
    return sortedList.take(limit).toList();
  }

  /// Get available scholarship categories
  List<String> getAvailableCategories() {
    final Set<String> categories = {};

    for (final scholarship in scholarships) {
      categories.addAll(scholarship.categories);
    }

    return categories.toList()..sort();
  }
}
