const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Cleanup saved scholarships when a scholarship is deleted
exports.cleanupDeletedScholarship = functions.firestore
  .document("scholarships/{scholarshipId}")
  .onDelete(async (snapshot, context) => {
    const scholarshipId = context.params.scholarshipId;

    try {
      // Get all savedScholarships referencing this scholarship
      const savedScholarshipsSnapshot = await admin
        .firestore()
        .collection("savedScholarships")
        .where("scholarshipId", "==", scholarshipId)
        .get();

      // If no saved references, exit early
      if (savedScholarshipsSnapshot.empty) {
        console.log(
          `No saved references found for deleted scholarship: ${scholarshipId}`
        );
        return null;
      }

      // Store user IDs for later notification
      const affectedUserIds = [];
      savedScholarshipsSnapshot.docs.forEach((doc) => {
        const data = doc.data();
        if (data.userId) {
          affectedUserIds.push(data.userId);
        }
      });

      // Create a batch operation to delete all references
      const batch = admin.firestore().batch();
      savedScholarshipsSnapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });

      // Execute the batch delete
      await batch.commit();
      console.log(
        `Deleted ${savedScholarshipsSnapshot.size} saved references to scholarship ${scholarshipId}`
      );

      // Store deletion info for affected users
      if (affectedUserIds.length > 0) {
        // Add to deleted scholarships tracking collection
        await admin
          .firestore()
          .collection("deletedScholarships")
          .add({
            scholarshipId: scholarshipId,
            scholarshipTitle: snapshot.data().title || "Unknown Scholarship",
            deletedAt: admin.firestore.FieldValue.serverTimestamp(),
            affectedUserIds: affectedUserIds,
          });

        console.log(
          `Recorded deletion info for ${affectedUserIds.length} affected users`
        );
      }

      return null;
    } catch (error) {
      console.error("Error cleaning up saved scholarships:", error);
      throw error;
    }
  });
