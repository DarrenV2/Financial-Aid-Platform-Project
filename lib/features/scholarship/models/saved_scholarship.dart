import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a saved/bookmarked scholarship for a user.
class SavedScholarship {
  final String id;
  final String scholarshipId;
  final String userId;
  final DateTime savedAt;

  SavedScholarship({
    required this.id,
    required this.scholarshipId,
    required this.userId,
    required this.savedAt,
  });

  /// Create from Firestore document
  factory SavedScholarship.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return SavedScholarship(
      id: doc.id,
      scholarshipId: data['scholarshipId'] ?? '',
      userId: data['userId'] ?? '',
      savedAt: data['savedAt'] is Timestamp
          ? (data['savedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'scholarshipId': scholarshipId,
      'userId': userId,
      'savedAt': FieldValue.serverTimestamp(),
    };
  }
}
