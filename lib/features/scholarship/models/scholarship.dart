import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing a scholarship.
class Scholarship {
  final String id;
  final String title;
  final String description;
  final String amount;
  final String deadline;
  final String? eligibility;
  final String? applicationLink;
  final String? applicationProcess;
  final String? requiredDocuments;
  final String sourceWebsite;
  final String sourceName;
  final bool meritBased;
  final bool needBased;
  final double? requiredGpa;
  final List<String> categories;
  final DateTime? scrapedDate;
  final DateTime? lastUpdated;

  /// Constructor for Scholarship model.
  Scholarship({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.deadline,
    this.eligibility,
    this.applicationLink,
    this.applicationProcess,
    this.requiredDocuments,
    required this.sourceWebsite,
    required this.sourceName,
    required this.meritBased,
    required this.needBased,
    this.requiredGpa,
    required this.categories,
    this.scrapedDate,
    this.lastUpdated,
  });

  /// Create an empty scholarship.
  factory Scholarship.empty() => Scholarship(
        id: '',
        title: '',
        description: '',
        amount: '',
        deadline: '',
        sourceWebsite: '',
        sourceName: '',
        meritBased: false,
        needBased: false,
        categories: [],
      );

  /// Convert Firestore document to Scholarship object.
  factory Scholarship.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Handle eligibility field that might be a List or a String
    var eligibility = data['eligibility'];
    if (eligibility is List) {
      // Convert List to String with bullet points
      eligibility = eligibility.map((item) => "• $item").join('\n');
    }

    // Handle required_documents field that might be a List or a String
    var requiredDocs = data['required_documents'];
    if (requiredDocs is List) {
      // Convert List to String with bullet points
      requiredDocs = requiredDocs.map((item) => "• $item").join('\n');
    }

    // Handle other potential list fields
    var forWhom = data['for_whom'];
    if (forWhom is List) {
      forWhom = forWhom.join(', ');
    }

    var fieldsOfStudy = data['fields_of_study'];
    if (fieldsOfStudy is List) {
      fieldsOfStudy = fieldsOfStudy.join(', ');
    }

    var studyLevel = data['study_level'];
    if (studyLevel is List) {
      studyLevel = studyLevel.join(', ');
    }

    // Handle dates that could be either Timestamp objects or strings
    DateTime? parsedScrapedDate;
    if (data['scraped_date'] != null) {
      if (data['scraped_date'] is Timestamp) {
        parsedScrapedDate = (data['scraped_date'] as Timestamp).toDate();
      } else if (data['scraped_date'] is String) {
        try {
          parsedScrapedDate = DateTime.parse(data['scraped_date'] as String);
        } catch (e) {
          // Error handling for date parsing
        }
      }
    }

    DateTime? parsedLastUpdated;
    if (data['last_updated'] != null) {
      if (data['last_updated'] is Timestamp) {
        parsedLastUpdated = (data['last_updated'] as Timestamp).toDate();
      } else if (data['last_updated'] is String) {
        try {
          parsedLastUpdated = DateTime.parse(data['last_updated'] as String);
        } catch (e) {
          // Error handling for date parsing
        }
      }
    }

    // Handle GPA that could be either a number or a string
    double? parsedGpa;
    if (data['required_gpa'] != null) {
      if (data['required_gpa'] is num) {
        parsedGpa = (data['required_gpa'] as num).toDouble();
      } else if (data['required_gpa'] is String) {
        try {
          parsedGpa = double.parse(data['required_gpa'] as String);
        } catch (e) {
          // Error handling for GPA parsing
        }
      }
    }

    // Handle boolean fields that could be either boolean or string
    bool meritBasedValue = false;
    if (data['meritBased'] != null) {
      if (data['meritBased'] is bool) {
        meritBasedValue = data['meritBased'] as bool;
      } else if (data['meritBased'] is String) {
        meritBasedValue = data['meritBased'].toString().toLowerCase() == 'true';
      }
    }

    bool needBasedValue = false;
    if (data['needBased'] != null) {
      if (data['needBased'] is bool) {
        needBasedValue = data['needBased'] as bool;
      } else if (data['needBased'] is String) {
        needBasedValue = data['needBased'].toString().toLowerCase() == 'true';
      }
    }

    // Handle categories that could be in different formats
    List<String> categoriesList = [];
    if (data['categories'] != null) {
      if (data['categories'] is List) {
        categoriesList = (data['categories'] as List)
            .map((item) => item.toString())
            .toList();
      } else if (data['categories'] is String) {
        // If categories is a single string, split by commas
        String categoriesString = data['categories'] as String;
        categoriesList = categoriesString
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
    }

    return Scholarship(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: data['amount']?.toString() ?? '',
      deadline: data['deadline']?.toString() ?? '',
      eligibility: eligibility,
      applicationLink: data['application_link'],
      applicationProcess: data['application_process'],
      requiredDocuments: requiredDocs,
      sourceWebsite: data['source_website'] ?? '',
      sourceName: data['source_name'] ?? '',
      meritBased: meritBasedValue,
      needBased: needBasedValue,
      requiredGpa: parsedGpa,
      categories: categoriesList,
      scrapedDate: parsedScrapedDate,
      lastUpdated: parsedLastUpdated,
    );
  }

  /// Convert Scholarship object to a map for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'deadline': deadline,
      'eligibility': eligibility,
      'application_link': applicationLink,
      'application_process': applicationProcess,
      'required_documents': requiredDocuments,
      'source_website': sourceWebsite,
      'source_name': sourceName,
      'meritBased': meritBased,
      'needBased': needBased,
      'required_gpa': requiredGpa,
      'categories': categories,
      'last_updated': FieldValue.serverTimestamp(),
    };
  }

  /// Create a copy of this Scholarship with the given fields replaced with the new values.
  Scholarship copyWith({
    String? id,
    String? title,
    String? description,
    String? amount,
    String? deadline,
    String? eligibility,
    String? applicationLink,
    String? applicationProcess,
    String? requiredDocuments,
    String? sourceWebsite,
    String? sourceName,
    bool? meritBased,
    bool? needBased,
    double? requiredGpa,
    List<String>? categories,
    DateTime? scrapedDate,
  }) {
    return Scholarship(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      deadline: deadline ?? this.deadline,
      eligibility: eligibility ?? this.eligibility,
      applicationLink: applicationLink ?? this.applicationLink,
      applicationProcess: applicationProcess ?? this.applicationProcess,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      sourceWebsite: sourceWebsite ?? this.sourceWebsite,
      sourceName: sourceName ?? this.sourceName,
      meritBased: meritBased ?? this.meritBased,
      needBased: needBased ?? this.needBased,
      requiredGpa: requiredGpa ?? this.requiredGpa,
      categories: categories ?? this.categories,
      scrapedDate: scrapedDate ?? this.scrapedDate,
    );
  }
}
