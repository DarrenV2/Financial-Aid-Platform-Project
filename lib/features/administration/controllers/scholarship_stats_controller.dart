import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_aid_project/features/scholarship/models/scholarship.dart';

class ScholarshipStatsController extends GetxController {
  static ScholarshipStatsController get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable statistics
  final RxMap<String, int> scholarshipTypeStats = <String, int>{
    'meritBased': 0,
    'needBased': 0,
    'both': 0,
    'other': 0,
  }.obs;

  final RxMap<String, int> scholarshipCategoryStats = <String, int>{}.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchScholarshipStats();
  }

  /// Calculate percentage for a specific type
  double getTypePercentage(String type) {
    int total = scholarshipTypeStats.values
        .fold(0, (int value, int element) => value + element);
    if (total == 0) return 0.0;
    return (scholarshipTypeStats[type] ?? 0) / total;
  }

  /// Calculate percentage for a specific category
  double getCategoryPercentage(String category) {
    int total = scholarshipCategoryStats.values
        .fold(0, (int value, int element) => value + element);
    if (total == 0) return 0.0;
    return (scholarshipCategoryStats[category] ?? 0) / total;
  }

  /// Fetch and calculate scholarship statistics
  Future<void> fetchScholarshipStats() async {
    isLoading.value = true;
    try {
      // Get all scholarships from Firestore
      final QuerySnapshot scholarshipSnapshot =
          await _firestore.collection('scholarships').get();

      // Reset counters
      scholarshipTypeStats.value = {
        'meritBased': 0,
        'needBased': 0,
        'both': 0,
        'other': 0,
      };

      scholarshipCategoryStats.clear();

      // Process each scholarship document
      for (var doc in scholarshipSnapshot.docs) {
        final scholarship = Scholarship.fromFirestore(doc);

        // Count by types (merit-based vs need-based)
        if (scholarship.meritBased && scholarship.needBased) {
          scholarshipTypeStats['both'] =
              (scholarshipTypeStats['both'] ?? 0) + 1;
        } else if (scholarship.meritBased) {
          scholarshipTypeStats['meritBased'] =
              (scholarshipTypeStats['meritBased'] ?? 0) + 1;
        } else if (scholarship.needBased) {
          scholarshipTypeStats['needBased'] =
              (scholarshipTypeStats['needBased'] ?? 0) + 1;
        } else {
          scholarshipTypeStats['other'] =
              (scholarshipTypeStats['other'] ?? 0) + 1;
        }

        // Count by categories
        for (var category in scholarship.categories) {
          if (category.isNotEmpty) {
            scholarshipCategoryStats[category] =
                (scholarshipCategoryStats[category] ?? 0) + 1;
          }
        }
      }

      // Sort categories by count (highest first) and limit to top 5
      var sortedCategories = scholarshipCategoryStats.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      if (sortedCategories.length > 5) {
        // Keep only top 5 categories and combine the rest into "Others"
        var topCategories = sortedCategories.sublist(0, 5);
        var othersCount = sortedCategories
            .sublist(5)
            .fold(0, (int total, entry) => total + entry.value);

        scholarshipCategoryStats.clear();
        for (var entry in topCategories) {
          scholarshipCategoryStats[entry.key] = entry.value;
        }
        if (othersCount > 0) {
          scholarshipCategoryStats['Others'] = othersCount;
        }
      }
    } catch (e) {
      // Handle errors appropriately - using a logger instead of print
      // This would be replaced with a proper logging framework in production
    } finally {
      isLoading.value = false;
    }
  }

  // Get type stats with percentages for UI display
  List<Map<String, dynamic>> getTypeStatsForDisplay() {
    List<Map<String, dynamic>> result = [];
    int total = scholarshipTypeStats.values
        .fold(0, (int value, int element) => value + element);

    if (total == 0) return [];

    scholarshipTypeStats.forEach((type, int itemCount) {
      String displayName = type;
      switch (type) {
        case 'meritBased':
          displayName = 'Merit-Based';
          break;
        case 'needBased':
          displayName = 'Need-Based';
          break;
        case 'both':
          displayName = 'Merit & Need';
          break;
        case 'other':
          displayName = 'Other';
          break;
      }

      double percentage = itemCount / total;
      String percentageStr = '${(percentage * 100).toStringAsFixed(0)}%';

      result.add({
        'type': type,
        'displayName': displayName,
        'count': itemCount,
        'percentage': percentage,
        'percentageStr': percentageStr,
      });
    });

    return result;
  }

  // Get category stats with percentages for UI display
  List<Map<String, dynamic>> getCategoryStatsForDisplay() {
    List<Map<String, dynamic>> result = [];
    int total = scholarshipCategoryStats.values
        .fold(0, (int value, int element) => value + element);

    if (total == 0) return [];

    scholarshipCategoryStats.forEach((category, int itemCount) {
      double percentage = itemCount / total;

      result.add({
        'category': category,
        'count': itemCount,
        'percentage': percentage,
      });
    });

    // Sort by count descending
    result.sort((a, b) => b['count'].compareTo(a['count']));

    return result;
  }
}
