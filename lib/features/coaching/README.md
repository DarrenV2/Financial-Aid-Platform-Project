# Coaching Feature - Firebase Integration

This document explains how the coaching module's progress tracking is implemented using Firebase Firestore.

## Architecture

The implementation follows a clean architecture approach with separation of concerns:

1. **Repository Layer**: Handles direct communication with Firebase Firestore
2. **Service Layer**: Provides business logic and uses repository
3. **Controller Layer**: Manages state and connects UI to services
4. **View Layer**: Presents data to the user

## Data Structure in Firestore

User progress data is stored in a `user_progress` collection with the following structure:

```
user_progress/
  {userId}/
    moduleProgress: {
      "module_id_1": 75.0,  // percentage completed
      "module_id_2": 100.0,
      ...
    }
    completedModules: ["module_id_2", "module_id_4", ...]
    assessmentResults: [
      {
        "overallScore": 82.5,
        "timestamp": Timestamp
      }
    ]
    lastUpdated: Timestamp
```

## Key Classes

### 1. FirestoreProgressRepository

Handles all Firestore database operations:

- `getUserProgress`: Fetches user's progress data
- `updateModuleProgress`: Updates progress for a specific module
- `markModuleCompleted`: Marks a module as completed
- `saveAssessmentResult`: Saves assessment results

### 2. ProgressService

Acts as an intermediary between controllers and repository:

- Provides methods that match the repository interface
- Can be extended with additional business logic
- Uses dependency injection for better testability

### 3. LearningController & CoachingController

Both now use Firebase Auth to identify the current user:

- Gets the current user ID from `FirebaseAuth.instance.currentUser.uid`
- Throws an exception if no authenticated user is found (authentication required)
- Caches data in reactive (Rx) variables for UI
- Includes methods to force-refresh data from Firebase

## User Identification

- The app uses Firebase Authentication to identify users
- Module progress is tied to the authenticated user's ID
- Authentication is required to access the coaching features

## Refreshing Data

The UI includes refresh buttons on:

- Learning Plan screen
- Module Detail screen

These buttons force a refresh from Firestore to ensure data is in sync across devices.

## Implementation Notes

- The system uses merge operations to prevent overwriting existing data
- Server timestamps are used to track when data was last updated
- Reactive programming with GetX ensures UI updates when data changes
