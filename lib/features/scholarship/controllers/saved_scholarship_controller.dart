import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_aid_project/features/scholarship/models/saved_scholarship.dart';
import 'package:financial_aid_project/features/scholarship/models/scholarship.dart';
import 'package:financial_aid_project/features/scholarship/controllers/scholarship_controllers.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';

class SavedScholarshipController extends GetxController {
  static SavedScholarshipController get instance => Get.find();

  // Firebase reference
  final _db = FirebaseFirestore.instance;

  // Get scholarship controller
  final ScholarshipController _scholarshipController =
      ScholarshipController.instance;

  // Observable properties
  final RxList<SavedScholarship> savedScholarships = <SavedScholarship>[].obs;
  final RxList<Scholarship> savedScholarshipDetails = <Scholarship>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  // Properties for tracking deleted scholarships
  final RxInt recentlyDeletedCount = 0.obs;
  final RxBool hasDeletedScholarships = false.obs;
  final RxList<String> deletedScholarshipIds = <String>[].obs;

  // Properties for tracking edited scholarships
  final RxBool hasEditedScholarships = false.obs;
  final RxList<String> editedScholarshipIds = <String>[].obs;

  // Get current user id
  String? get currentUserId => AuthenticationRepository.instance.authUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchSavedScholarships();
    checkForDeletedScholarships();
  }

  /// Fetch all saved scholarships for the current user
  Future<void> fetchSavedScholarships() async {
    if (currentUserId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get all saved scholarship records for this user
      final QuerySnapshot snapshot = await _db
          .collection('savedScholarships')
          .where('userId', isEqualTo: currentUserId)
          .get();

      // Convert to SavedScholarship objects
      final List<SavedScholarship> savedList = snapshot.docs
          .map((doc) => SavedScholarship.fromFirestore(doc))
          .toList();

      savedScholarships.value = savedList;

      // Now get the full scholarship details for each saved scholarship
      await fetchSavedScholarshipDetails();
    } catch (e) {
      errorMessage.value = 'Failed to fetch saved scholarships: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Check for scholarships that have been deleted recently
  Future<void> checkForDeletedScholarships() async {
    if (currentUserId == null) return;

    try {
      // Query for deleted scholarships affecting this user
      // Using the deletedScholarships collection created by the Firebase function
      final QuerySnapshot snapshot = await _db
          .collection('deletedScholarships')
          .where('affectedUserIds', arrayContains: currentUserId)
          .orderBy('deletedAt', descending: true)
          .limit(10) // Only check recent deletions
          .get();

      if (snapshot.docs.isEmpty) {
        hasDeletedScholarships.value = false;
        recentlyDeletedCount.value = 0;
        return;
      }

      // Get the deleted scholarship IDs
      List<String> deletedIds = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['scholarshipId'] != null) {
          deletedIds.add(data['scholarshipId'] as String);
        }
      }

      deletedScholarshipIds.value = deletedIds;
      recentlyDeletedCount.value = deletedIds.length;
      hasDeletedScholarships.value = deletedIds.isNotEmpty;
    } catch (e) {
      errorMessage.value = 'Error checking for deleted scholarships: $e';
    }
  }

  /// Check for edited scholarships by comparing last saved timestamp with scholarship last updated timestamp
  Future<void> checkForEditedScholarships() async {
    if (currentUserId == null || savedScholarships.isEmpty) return;

    try {
      editedScholarshipIds.clear();

      for (var savedScholarship in savedScholarships) {
        final scholarship = await _scholarshipController
            .getScholarshipById(savedScholarship.scholarshipId);

        if (scholarship != null) {
          // Check if scholarship has been updated since it was saved
          final DateTime? lastUpdated = scholarship.lastUpdated;
          if (lastUpdated != null &&
              lastUpdated.isAfter(savedScholarship.savedAt)) {
            editedScholarshipIds.add(savedScholarship.scholarshipId);
          }
        }
      }

      hasEditedScholarships.value = editedScholarshipIds.isNotEmpty;
    } catch (e) {
      // Use error message instead of print
      errorMessage.value = 'Error checking for edited scholarships: $e';
    }
  }

  /// Acknowledge deleted scholarships to clear the warning
  void acknowledgeDeletedScholarships() {
    recentlyDeletedCount.value = 0;
    hasDeletedScholarships.value = false;
  }

  /// Acknowledge edited scholarships to clear the indicator
  void acknowledgeEditedScholarships() {
    editedScholarshipIds.clear();
    hasEditedScholarships.value = false;
  }

  /// Fetch detailed scholarship information for saved scholarships
  Future<void> fetchSavedScholarshipDetails() async {
    try {
      if (savedScholarships.isEmpty) return;

      // Get all the scholarship IDs
      final List<String> scholarshipIds =
          savedScholarships.map((saved) => saved.scholarshipId).toList();

      // Clear previous data
      savedScholarshipDetails.clear();

      // Track missing scholarships due to deletion
      int missingCount = 0;

      // For each ID, get the scholarship details
      for (final String id in scholarshipIds) {
        final scholarship = await _scholarshipController.getScholarshipById(id);
        if (scholarship != null) {
          savedScholarshipDetails.add(scholarship);
        } else {
          // This scholarship was not found, likely deleted
          missingCount++;

          // Add this ID to our list of deleted scholarships if not already there
          if (!deletedScholarshipIds.contains(id)) {
            deletedScholarshipIds.add(id);
          }
        }
      }

      // If we found missing scholarships, update the recently deleted count
      if (missingCount > 0) {
        recentlyDeletedCount.value = missingCount;
        hasDeletedScholarships.value = true;

        // Clean up saved scholarships that reference deleted scholarships
        await _cleanupOrphanedSavedScholarships();
      }

      // Check for edited scholarships
      await checkForEditedScholarships();
    } catch (e) {
      errorMessage.value = 'Failed to fetch scholarship details: $e';
    }
  }

  /// Clean up saved scholarships that reference deleted scholarships
  Future<void> _cleanupOrphanedSavedScholarships() async {
    if (currentUserId == null) return;

    try {
      // Get all saved scholarships for this user
      final snapshot = await _db
          .collection('savedScholarships')
          .where('userId', isEqualTo: currentUserId)
          .get();

      // For each saved scholarship, check if the scholarship exists
      for (var doc in snapshot.docs) {
        final savedScholarship = SavedScholarship.fromFirestore(doc);
        final scholarship = await _scholarshipController
            .getScholarshipById(savedScholarship.scholarshipId);

        // If scholarship is null, it's been deleted - remove the saved reference
        if (scholarship == null) {
          await _db.collection('savedScholarships').doc(doc.id).delete();
        }
      }
    } catch (e) {
      errorMessage.value = 'Error cleaning up orphaned scholarships: $e';
    }
  }

  /// Check if a scholarship is saved by the current user
  bool isScholarshipSaved(String scholarshipId) {
    return savedScholarships
        .any((saved) => saved.scholarshipId == scholarshipId);
  }

  /// Check if a scholarship has been edited since saving
  bool isScholarshipEdited(String scholarshipId) {
    return editedScholarshipIds.contains(scholarshipId);
  }

  /// Get the saved scholarship record if it exists
  SavedScholarship? getSavedRecord(String scholarshipId) {
    try {
      return savedScholarships
          .firstWhere((saved) => saved.scholarshipId == scholarshipId);
    } catch (e) {
      return null;
    }
  }

  /// Toggle save status of a scholarship
  Future<bool> toggleSaveStatus(String scholarshipId) async {
    if (currentUserId == null) {
      errorMessage.value = 'You must be logged in to save scholarships';
      return false;
    }

    final bool isCurrentlySaved = isScholarshipSaved(scholarshipId);
    final String userId = currentUserId!; // Safe because we checked above

    // Create a temporary record for optimistic UI update
    SavedScholarship? tempRecord;
    Scholarship? scholarshipDetails;

    try {
      // 1. Optimistically update UI immediately
      if (isCurrentlySaved) {
        // Get the saved record to be removed
        tempRecord = getSavedRecord(scholarshipId);
        if (tempRecord != null) {
          // Need to create a local non-nullable version to satisfy the type checker
          final record = tempRecord;
          // Remove from local lists immediately for instant UI feedback
          savedScholarships.removeWhere((s) => s.id == record.id);
          savedScholarshipDetails.removeWhere((s) => s.id == scholarshipId);
        }
      } else {
        // Get scholarship details for adding to local list
        scholarshipDetails =
            await _scholarshipController.getScholarshipById(scholarshipId);
        if (scholarshipDetails != null) {
          // Create a temporary local record with a temporary ID
          final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
          tempRecord = SavedScholarship(
            id: tempId,
            scholarshipId: scholarshipId,
            userId: userId, // Using non-nullable userId defined above
            savedAt: DateTime.now(),
          );

          // Add to local lists immediately for instant UI feedback
          savedScholarships.add(tempRecord);
          savedScholarshipDetails.add(scholarshipDetails);
        }
      }

      // 2. Perform actual server operation
      bool success = false;
      if (isCurrentlySaved && tempRecord != null) {
        success = await _unsaveScholarshipInDb(tempRecord);
      } else if (!isCurrentlySaved) {
        success = await _saveScholarshipInDb(scholarshipId);
      }

      // 3. Handle server operation result
      if (!success) {
        // If server operation failed, revert optimistic changes
        _revertOptimisticChanges(
            isCurrentlySaved, tempRecord, scholarshipDetails);
      }

      return success;
    } catch (e) {
      // If an error occurred, revert optimistic changes
      _revertOptimisticChanges(
          isCurrentlySaved, tempRecord, scholarshipDetails);
      errorMessage.value = 'Failed to update scholarship: ${e.toString()}';
      return false;
    }
  }

  /// Revert optimistic UI changes if server operation fails
  void _revertOptimisticChanges(bool wasCurrentlySaved,
      SavedScholarship? tempRecord, Scholarship? scholarshipDetails) {
    if (wasCurrentlySaved && tempRecord != null) {
      // Was unsaving, so add back to lists
      savedScholarships.add(tempRecord);
      if (scholarshipDetails != null) {
        savedScholarshipDetails.add(scholarshipDetails);
      }
    } else if (!wasCurrentlySaved && tempRecord != null) {
      // Was saving, so remove from lists
      savedScholarships.removeWhere((s) => s.id == tempRecord.id);
      if (scholarshipDetails != null) {
        savedScholarshipDetails
            .removeWhere((s) => s.id == scholarshipDetails.id);
      }
    }
  }

  /// Save a scholarship in the database (without UI updates)
  Future<bool> _saveScholarshipInDb(String scholarshipId) async {
    final userId = currentUserId;
    if (userId == null) return false;

    try {
      // Create a new document reference
      final docRef = _db.collection('savedScholarships').doc();

      // Create the saved scholarship record with non-nullable userId
      final savedScholarship = SavedScholarship(
        id: docRef.id,
        scholarshipId: scholarshipId,
        userId: userId, // This is safe as we checked it's non-null above
        savedAt: DateTime.now(),
      );

      // Save to Firestore
      await docRef.set(savedScholarship.toFirestore());

      // Update our local list with the server ID
      final tempIndex =
          savedScholarships.indexWhere((s) => s.scholarshipId == scholarshipId);
      if (tempIndex >= 0) {
        savedScholarships[tempIndex] = savedScholarship;
      }

      successMessage.value = 'Scholarship saved successfully';
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to save scholarship: ${e.toString()}';
      return false;
    }
  }

  /// Unsave/remove a scholarship from the database (without UI updates)
  Future<bool> _unsaveScholarshipInDb(SavedScholarship savedRecord) async {
    if (currentUserId == null) return false;

    try {
      // Delete from Firestore
      await _db.collection('savedScholarships').doc(savedRecord.id).delete();

      // Remove from edited list if it was there
      editedScholarshipIds.remove(savedRecord.scholarshipId);
      if (editedScholarshipIds.isEmpty) {
        hasEditedScholarships.value = false;
      }

      successMessage.value = 'Scholarship removed from saved items';
      return true;
    } catch (e) {
      errorMessage.value =
          'Failed to remove saved scholarship: ${e.toString()}';
      return false;
    }
  }

  /// Save a scholarship
  Future<bool> saveScholarship(String scholarshipId) async {
    if (currentUserId == null) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Get scholarship details
      final scholarship =
          await _scholarshipController.getScholarshipById(scholarshipId);
      if (scholarship != null) {
        // Add to local list for instant feedback
        savedScholarshipDetails.add(scholarship);
      }

      // Perform database operation
      return await _saveScholarshipInDb(scholarshipId);
    } catch (e) {
      errorMessage.value = 'Failed to save scholarship: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Unsave/remove a scholarship
  Future<bool> unsaveScholarship(String scholarshipId) async {
    if (currentUserId == null) return false;

    final SavedScholarship? savedRecord = getSavedRecord(scholarshipId);
    if (savedRecord == null) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Remove from local lists for instant feedback
      savedScholarships.removeWhere((s) => s.id == savedRecord.id);
      savedScholarshipDetails.removeWhere((s) => s.id == scholarshipId);

      // Perform database operation
      return await _unsaveScholarshipInDb(savedRecord);
    } catch (e) {
      errorMessage.value =
          'Failed to remove saved scholarship: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
