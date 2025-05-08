import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stats
  final RxInt totalScholarships = 0.obs;
  final RxInt activeUsers = 0.obs;
  final RxInt applications = 0.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    isLoading.value = true;
    try {
      // Fetch scholarship count
      final scholarshipSnapshot =
          await _firestore.collection('scholarships').get();
      totalScholarships.value = scholarshipSnapshot.docs.length;

      // In a real implementation, you would fetch these counts as well
      // For now, they're placeholders
      activeUsers.value = 0;
      applications.value = 0;
    } catch (e) {
      // Handle errors appropriately
      // Error logging should be implemented in a production environment
    } finally {
      isLoading.value = false;
    }
  }
}
