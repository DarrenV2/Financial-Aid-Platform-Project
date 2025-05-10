import 'package:financial_aid_project/features/scholarship/controllers/saved_scholarship_controller.dart';
import 'package:financial_aid_project/features/scholarship/models/scholarship.dart';
import 'package:financial_aid_project/features/scholarship/views/components/scholarship_card.dart';
import 'package:financial_aid_project/features/scholarship/views/scholarship_details.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedScholarshipsScreen extends StatefulWidget {
  const SavedScholarshipsScreen({super.key});

  @override
  State<SavedScholarshipsScreen> createState() =>
      _SavedScholarshipsScreenState();
}

class _SavedScholarshipsScreenState extends State<SavedScholarshipsScreen> {
  late SavedScholarshipController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    if (!Get.isRegistered<SavedScholarshipController>()) {
      Get.put(SavedScholarshipController());
    }
    _controller = Get.find<SavedScholarshipController>();

    // Refresh the data
    _controller.fetchSavedScholarships();
  }

  void _onScholarshipSelected(Scholarship scholarship) {
    // Navigate to scholarship details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScholarshipDetails(scholarship: scholarship),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Scholarships'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.savedScholarshipDetails.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // Notification for deleted scholarships
            if (_controller.hasDeletedScholarships.value)
              _buildNotificationBanner(
                'Some of your saved scholarships have been deleted',
                Icons.error_outline,
                Colors.red.shade700,
                () => _controller.acknowledgeDeletedScholarships(),
              ),

            // Notification for edited scholarships
            if (_controller.hasEditedScholarships.value)
              _buildNotificationBanner(
                'Some of your saved scholarships have been updated',
                Icons.update,
                Colors.amber.shade700,
                () => _controller.acknowledgeEditedScholarships(),
              ),

            // Scholarship grid
            Expanded(child: _buildScholarshipGrid()),
          ],
        );
      }),
    );
  }

  Widget _buildNotificationBanner(
      String message, IconData icon, Color color, VoidCallback onDismiss) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: color.withAlpha(25),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: color,
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Saved Scholarships',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scholarships you save will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate back to scholarship list
              Get.back();
            },
            icon: const Icon(Icons.search),
            label: const Text('Browse Scholarships'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(context),
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _controller.savedScholarshipDetails.length,
      itemBuilder: (context, index) {
        final scholarship = _controller.savedScholarshipDetails[index];
        final isEdited = _controller.isScholarshipEdited(scholarship.id);

        return ScholarshipCard(
          scholarship: scholarship,
          onTap: () => _onScholarshipSelected(scholarship),
          isSaved: true,
          isEdited: isEdited,
          onSaveToggle: () {
            _controller.toggleSaveStatus(scholarship.id);
          },
        );
      },
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 4; // Extra large screens
    } else if (width > 900) {
      return 3; // Large screens
    } else if (width > 600) {
      return 2; // Medium screens
    } else {
      return 1; // Small screens
    }
  }
}
