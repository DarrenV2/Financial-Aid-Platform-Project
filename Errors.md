rules_version = '2';
service cloud.firestore {
match /databases/{database}/documents {
// Specific collection rules first

    // Allow public read access to scholarships
    match /scholarships/{document} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    // Allow users to manage their saved scholarships
    match /savedScholarships/{document} {
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow read, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }

    // Allow users to access and manage their own progress data
    match /user_progress/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Notification and trigger collections
    match /admin_notifications/{document} {
      allow read, write: if request.auth != null;
    }

    match /scraper_triggers/{document} {
      allow read, write: if request.auth != null;
    }

    // User profile documents
    match /Users/{userId} {
      allow create: if request.auth != null && request.auth.uid == userId;
      allow read, update: if request.auth != null && (request.auth.uid == userId ||
                          exists(/databases/$(database)/documents/Admins/$(request.auth.uid)));
      // Note: Delete permission is not granted
    }

    // Admin catch-all rule at the end
    match /{document=**} {
      allow read, write: if request.auth != null &&
      exists(/databases/$(database)/documents/Admins/$(request.auth.uid));
    }

}
}
