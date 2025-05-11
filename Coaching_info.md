# Coaching Feature Documentation

## Table of Contents

- [Original Implementation](#original-implementation)
- [Changes Made](#changes-made)
- [User Journey](#user-journey)
- [System Overview](#system-overview)
- [Technical Architecture](#technical-architecture)
- [Component Details](#component-details)

## Original Implementation

The coaching feature was initially designed as an educational component of the financial aid platform to help students improve their scholarship eligibility. It followed a structured approach:

1. **Assessment Phase**: Students completed a pre-assessment questionnaire covering various aspects of scholarship eligibility:

   - Academic performance
   - Financial need
   - Extracurricular activities
   - Leadership experience
   - Community service

2. **Recommendation Phase**: Based on assessment results, the system generated personalized recommendations prioritized by importance.

3. **Learning Phase**: Students accessed targeted learning content to improve their scholarship eligibility.

4. **Progress Tracking**: The system tracked improvements through post-assessments.

However, the original implementation had several issues:

- State management problems causing data loss when navigating between tabs
- Navigation issues with unwanted back buttons
- Type errors in handling assessment responses
- Inconsistent initialization of controllers

## Changes Made

Several key improvements were implemented:

1. **Architectural Changes**:

   - Implemented proper GetX framework integration
   - Created dedicated controllers with appropriate lifecycle management
   - Added proper state persistence using `fenix: true` parameter

2. **Bug Fixes**:

   - Fixed data type handling in the `AssessmentService` for string responses
   - Removed redundant controller initialization in routes
   - Added global registration of `CoachingController` in `GeneralBindings`
   - Fixed navigation issues by removing back button from main coaching screen

3. **UI Improvements**:
   - Improved navigation flow
   - Added clear loading indicators
   - Enhanced the result visualization

## User Journey

The coaching feature follows a sequential user journey:

1. **Entry Point**: Users access the coaching tab from the main dashboard

   - See welcome information
   - View assessment options
   - Access quick tips

2. **Pre-Assessment**:

   - Click "Start Assessment" button
   - Answer series of questions across different categories
   - Submit responses for evaluation

3. **Results Review**:

   - View overall eligibility score
   - See category-specific scores
   - Review strengths and improvement areas
   - Access personalized recommendations

4. **Learning Plan**:

   - View prioritized learning modules
   - Access module content based on recommendations
   - Complete learning activities

5. **Progress Tracking**:

   - Optionally take post-assessment
   - Compare results with pre-assessment
   - View improvement metrics

6. **Continuous Improvement**:
   - Return to learning plan for additional modules
   - Update assessments periodically

## System Overview

The coaching system operates through three primary components:

1. **Assessment Engine**:

   - Collects user responses through structured questionnaires
   - Evaluates responses using category-specific scoring algorithms
   - Generates eligibility scores for each category
   - Calculates overall scholarship eligibility

2. **Recommendation System**:

   - Analyzes assessment results to identify strengths and weaknesses
   - Generates prioritized recommendations based on improvement potential
   - Links recommendations to specific learning modules
   - Adjusts recommendations based on user progress

3. **Learning Management**:
   - Organizes learning content into targeted modules
   - Tracks user progress through learning materials
   - Enables sequential or interest-based content access
   - Integrates with the assessment system for progress validation

## Technical Architecture

The coaching feature follows a layered architecture using the GetX state management framework:

### 1. Data Layer

- **Models**: Define the structure for questions, answers, assessment results, recommendations, and user progress
- **Data Sources**: Local storage for assessment questions and learning modules
- **Repositories**: Interface with storage solutions to retrieve and persist data

### 2. Service Layer

- **AssessmentService**: Handles assessment logic and scoring
- **ProgressService**: Manages user progress data
- **LearningService**: Delivers appropriate learning content

### 3. Controller Layer

- **CoachingController**: Main controller managing overall coaching state
- **AssessmentController**: Handles assessment UI state and interactions

### 4. View Layer

- **CoachingMainScreen**: Entry point showing coaching options
- **AssessmentScreen**: Interface for completing assessments
- **AssessmentResultScreen**: Displays evaluation results
- **LearningPlanScreen**: Shows personalized learning plan
- **ModuleDetailScreen**: Displays specific learning content

### 5. Navigation System

- Uses GetX routing for declarative navigation
- Maintains state across navigation events
- Manages data passing between screens

## Component Details

### Assessment Service

The `AssessmentService` is responsible for evaluating user responses and generating results:

1. **Category Scoring**:

   - Academic scores are based on GPA, awards, and activities
   - Financial scores reflect demonstrated financial need
   - Extracurricular scores measure involvement beyond academics
   - Leadership scores evaluate positions and experiences
   - Community service scores consider hours and impact

2. **Eligibility Determination**:

   - Merit-based eligibility requires strong academic scores (≥70%) and leadership/extracurricular scores (≥60%)
   - Need-based eligibility primarily considers financial scores (≥70%)

3. **Recommendation Generation**:
   - High priority recommendations for categories scoring <60%
   - Medium priority recommendations for categories scoring 60-80%
   - Low priority recommendations for categories scoring >80%

### Coaching Controller

The `CoachingController` manages the user's coaching journey:

1. **State Management**:

   - Tracks completion status of assessments
   - Stores the most recent assessment result
   - Manages loading states during data operations

2. **Navigation**:

   - Provides methods for starting assessments
   - Handles navigation to learning plans and results
   - Ensures proper data is passed between screens

3. **Data Persistence**:
   - Saves assessment results for future sessions
   - Loads previous user progress on initialization

### Learning Modules

The system includes various learning modules across categories:

1. **Academic Modules**:

   - GPA improvement strategies
   - Study skill enhancement
   - Test preparation techniques

2. **Financial Modules**:

   - Financial need documentation
   - Budget planning for students
   - Financial literacy basics

3. **Extracurricular Modules**:

   - Activity selection guidance
   - Involvement depth strategies
   - Impact demonstration techniques

4. **Leadership Modules**:

   - Leadership opportunity identification
   - Skill development pathways
   - Leadership experience documentation

5. **Community Service Modules**:
   - Service opportunity discovery
   - Impact measurement methods
   - Service reflection techniques
