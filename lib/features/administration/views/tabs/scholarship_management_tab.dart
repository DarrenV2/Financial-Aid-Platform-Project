import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/features/scholarship/controllers/scholarship_controllers.dart';
import 'package:financial_aid_project/features/scholarship/models/scholarship.dart';
import 'package:financial_aid_project/utils/popups/loaders.dart';
import 'package:intl/intl.dart';

class ScholarshipManagementTab extends StatefulWidget {
  const ScholarshipManagementTab({super.key});

  @override
  State<ScholarshipManagementTab> createState() =>
      _ScholarshipManagementTabState();
}

class _ScholarshipManagementTabState extends State<ScholarshipManagementTab> {
  final controller = Get.put(ScholarshipController());
  bool _showAddScholarshipForm = false;
  Scholarship? _scholarshipToEdit;

  // Controllers for form fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _eligibilityController = TextEditingController();
  final _applicationLinkController = TextEditingController();
  final _applicationProcessController = TextEditingController();
  final _requiredDocumentsController = TextEditingController();
  final _sourceWebsiteController = TextEditingController();
  final _sourceNameController = TextEditingController();
  final _gpaController = TextEditingController();

  // Form values
  bool _meritBased = false;
  bool _needBased = false;
  List<String> _selectedCategories = [];

  // Available categories
  final List<String> _availableCategories = [
    'Engineering',
    'Medicine',
    'Arts',
    'Science',
    'Business',
    'Law',
    'Computer Science',
    'Mathematics',
    'Social Sciences',
    'Humanities',
    'Education',
    'Nursing',
    'Pharmacy',
    'Dentistry',
    'Architecture',
  ];

  // Create a local form key for the add scholarship form
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set up listeners for success and error messages
    _setupMessageListeners();
  }

  void _setupMessageListeners() {
    // Listen for changes to success message
    ever(controller.successMessage, (message) {
      if (message.isNotEmpty) {
        TLoaders.successSnackBar(title: 'Success', message: message);
        // Clear the message after showing the snackbar
        Future.delayed(const Duration(seconds: 3), () {
          controller.successMessage.value = '';
        });
      }
    });

    // Listen for changes to error message
    ever(controller.errorMessage, (message) {
      if (message.isNotEmpty) {
        TLoaders.errorSnackBar(title: 'Error', message: message);
        // Clear the message after showing the snackbar
        Future.delayed(const Duration(seconds: 3), () {
          controller.errorMessage.value = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _deadlineController.dispose();
    _eligibilityController.dispose();
    _applicationLinkController.dispose();
    _applicationProcessController.dispose();
    _requiredDocumentsController.dispose();
    _sourceWebsiteController.dispose();
    _sourceNameController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _scholarshipToEdit = null;
    _titleController.clear();
    _descriptionController.clear();
    _amountController.clear();
    _deadlineController.clear();
    _eligibilityController.clear();
    _applicationLinkController.clear();
    _applicationProcessController.clear();
    _requiredDocumentsController.clear();
    _sourceWebsiteController.clear();
    _sourceNameController.clear();
    _gpaController.clear();
    _meritBased = false;
    _needBased = false;
    _selectedCategories = [];
  }

  void _editScholarship(Scholarship scholarship) {
    setState(() {
      _scholarshipToEdit = scholarship;
      _titleController.text = scholarship.title;
      _descriptionController.text = scholarship.description;
      _amountController.text = scholarship.amount;
      _deadlineController.text = scholarship.deadline;
      _eligibilityController.text = scholarship.eligibility ?? '';
      _applicationLinkController.text = scholarship.applicationLink ?? '';
      _applicationProcessController.text = scholarship.applicationProcess ?? '';
      _requiredDocumentsController.text = scholarship.requiredDocuments ?? '';
      _sourceWebsiteController.text = scholarship.sourceWebsite;
      _sourceNameController.text = scholarship.sourceName;
      _gpaController.text = scholarship.requiredGpa?.toString() ?? '';
      _meritBased = scholarship.meritBased;
      _needBased = scholarship.needBased;
      _selectedCategories = List<String>.from(scholarship.categories);
      _showAddScholarshipForm = true;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create scholarship object
      final scholarship = _scholarshipToEdit?.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
            amount: _amountController.text,
            deadline: _deadlineController.text,
            eligibility: _eligibilityController.text.isEmpty
                ? null
                : _eligibilityController.text,
            applicationLink: _applicationLinkController.text.isEmpty
                ? null
                : _applicationLinkController.text,
            applicationProcess: _applicationProcessController.text.isEmpty
                ? null
                : _applicationProcessController.text,
            requiredDocuments: _requiredDocumentsController.text.isEmpty
                ? null
                : _requiredDocumentsController.text,
            sourceWebsite: _sourceWebsiteController.text,
            sourceName: _sourceNameController.text,
            meritBased: _meritBased,
            needBased: _needBased,
            requiredGpa: _gpaController.text.isEmpty
                ? null
                : double.tryParse(_gpaController.text),
            categories: _selectedCategories,
          ) ??
          Scholarship(
            id: '',
            title: _titleController.text,
            description: _descriptionController.text,
            amount: _amountController.text,
            deadline: _deadlineController.text,
            eligibility: _eligibilityController.text.isEmpty
                ? null
                : _eligibilityController.text,
            applicationLink: _applicationLinkController.text.isEmpty
                ? null
                : _applicationLinkController.text,
            applicationProcess: _applicationProcessController.text.isEmpty
                ? null
                : _applicationProcessController.text,
            requiredDocuments: _requiredDocumentsController.text.isEmpty
                ? null
                : _requiredDocumentsController.text,
            sourceWebsite: _sourceWebsiteController.text,
            sourceName: _sourceNameController.text,
            meritBased: _meritBased,
            needBased: _needBased,
            requiredGpa: _gpaController.text.isEmpty
                ? null
                : double.tryParse(_gpaController.text),
            categories: _selectedCategories,
          );

      bool success;
      if (_scholarshipToEdit != null) {
        // Update existing scholarship
        success = await controller.updateScholarship(scholarship);
      } else {
        // Create new scholarship
        success = await controller.createScholarship(scholarship);
      }

      if (success) {
        setState(() {
          _showAddScholarshipForm = false;
          _resetForm();
        });
      }
    }
  }

  Future<void> _confirmDelete(Scholarship scholarship) async {
    Get.defaultDialog(
      title: 'Confirm Delete',
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Text(
          'Are you sure you want to delete ${scholarship.title}?',
          textAlign: TextAlign.center,
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Close dialog
          controller.deleteScholarship(scholarship.id);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        child: const Text('Delete'),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(), // Close dialog
        child: const Text('Cancel'),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Manage Scholarships',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon:
                        Icon(_showAddScholarshipForm ? Icons.close : Icons.add),
                    label: Text(
                        _showAddScholarshipForm ? 'Cancel' : 'Add Scholarship'),
                    onPressed: () {
                      setState(() {
                        _showAddScholarshipForm = !_showAddScholarshipForm;
                        if (!_showAddScholarshipForm) {
                          _resetForm();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showAddScholarshipForm
                          ? Colors.red
                          : TColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_showAddScholarshipForm)
            _buildScholarshipForm()
          else
            _buildScholarshipsList(),
        ],
      ),
    );
  }

  Widget _buildScholarshipForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _scholarshipToEdit == null
                    ? 'Add New Scholarship'
                    : 'Edit Scholarship',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Basic Info Section
              _buildSectionTitle('Basic Information'),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter scholarship title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter scholarship description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: 'e.g. \$5,000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _deadlineController,
                      decoration: InputDecoration(
                        labelText: 'Deadline',
                        hintText: 'e.g. May 15, 2024',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 2)),
                            );
                            if (date != null) {
                              setState(() {
                                _deadlineController.text =
                                    DateFormat('MMMM d, yyyy').format(date);
                              });
                            }
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a deadline';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Eligibility Section
              _buildSectionTitle('Eligibility Requirements'),

              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Merit-Based'),
                      value: _meritBased,
                      onChanged: (value) {
                        setState(() {
                          _meritBased = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Need-Based'),
                      value: _needBased,
                      onChanged: (value) {
                        setState(() {
                          _needBased = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _gpaController,
                decoration: InputDecoration(
                  labelText: 'Required GPA (optional)',
                  hintText: 'e.g. 3.5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _eligibilityController,
                decoration: InputDecoration(
                  labelText: 'Additional Eligibility Details (optional)',
                  hintText: 'Enter any additional eligibility requirements',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Categories Section
              _buildSectionTitle('Categories'),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableCategories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: TColors.primary.withAlpha(100),
                    checkmarkColor: TColors.primary,
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Source Section
              _buildSectionTitle('Source Information'),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sourceNameController,
                      decoration: InputDecoration(
                        labelText: 'Source Name',
                        hintText: 'e.g. University Foundation',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter source name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _sourceWebsiteController,
                      decoration: InputDecoration(
                        labelText: 'Source Website',
                        hintText: 'e.g. https://example.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter website';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _applicationLinkController,
                decoration: InputDecoration(
                  labelText: 'Application Link (optional)',
                  hintText: 'e.g. https://example.com/apply',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Application process field
              TextFormField(
                controller: _applicationProcessController,
                decoration: InputDecoration(
                  labelText: 'Application Process',
                  hintText: 'Enter application process details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Required documents field
              TextFormField(
                controller: _requiredDocumentsController,
                decoration: InputDecoration(
                  labelText: 'Required Documents',
                  hintText: 'Enter required documents',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _scholarshipToEdit == null
                                  ? 'Create Scholarship'
                                  : 'Update Scholarship',
                              style: const TextStyle(fontSize: 16),
                            ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildScholarshipsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.scholarships.isEmpty) {
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined,
                      size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No scholarships found',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      controller.fetchScholarships();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search scholarships...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  // Search functionality can be implemented here
                },
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Amount',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Deadline',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.scholarships.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final scholarship = controller.scholarships[index];
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          scholarship.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(scholarship.amount),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(scholarship.deadline),
                      ),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (scholarship.meritBased)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withAlpha(50),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Merit',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              if (scholarship.needBased)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withAlpha(50),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Need',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  _showAddScholarshipForm = true;
                                  _editScholarship(scholarship);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: Colors.red,
                              onPressed: () => _confirmDelete(scholarship),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
