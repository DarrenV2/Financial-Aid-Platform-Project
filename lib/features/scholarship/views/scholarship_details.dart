import 'package:financial_aid_project/features/scholarship/controllers/saved_scholarship_controller.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/scholarship.dart';

class ScholarshipDetails extends StatefulWidget {
  final Scholarship scholarship;
  final bool isEmbedded;
  final VoidCallback? onBack;

  const ScholarshipDetails({
    super.key,
    required this.scholarship,
    this.isEmbedded = false,
    this.onBack,
  });

  @override
  State<ScholarshipDetails> createState() => _ScholarshipDetailsState();
}

class _ScholarshipDetailsState extends State<ScholarshipDetails> {
  late SavedScholarshipController _savedController;
  late RxBool isSaved;

  @override
  void initState() {
    super.initState();

    // Initialize saved scholarship controller
    if (!Get.isRegistered<SavedScholarshipController>()) {
      Get.put(SavedScholarshipController());
    }
    _savedController = Get.find<SavedScholarshipController>();

    // Check if this scholarship is saved
    isSaved = _savedController.isScholarshipSaved(widget.scholarship.id).obs;
  }

  void _toggleSaveStatus() async {
    final bool success =
        await _savedController.toggleSaveStatus(widget.scholarship.id);

    if (success) {
      isSaved.value =
          _savedController.isScholarshipSaved(widget.scholarship.id);
      _showSaveStatusSnackbar();
    } else if (_savedController.errorMessage.value.isNotEmpty) {
      _showErrorSnackbar(_savedController.errorMessage.value);
    }
  }

  void _showSaveStatusSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved.value
            ? 'Scholarship saved successfully!'
            : 'Scholarship removed from saved items'),
        backgroundColor: isSaved.value ? TColors.success : TColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Method to launch URL
  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No URL provided for this scholarship'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $urlString'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching URL: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEmbedded
        ? _buildEmbeddedLayout(context)
        : Scaffold(
            appBar: AppBar(
              title: const Text('Scholarship Details'),
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              actions: [
                Obx(() => IconButton(
                      icon: Icon(
                        isSaved.value ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: _toggleSaveStatus,
                    )),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Share feature coming soon')),
                    );
                  },
                ),
              ],
            ),
            body: _buildDetailsContent(context),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _launchUrl(widget.scholarship.applicationLink),
              backgroundColor: TColors.primary,
              label: const Text('Apply Now'),
              icon: const Icon(Icons.send),
            ),
          );
  }

  Widget _buildEmbeddedLayout(BuildContext context) {
    return Column(
      children: [
        // Custom app bar for embedded view
        Container(
          color: TColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              if (widget.onBack != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: widget.onBack,
                ),
              Expanded(
                child: Text(
                  'Scholarship Details',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Obx(() => IconButton(
                    icon: Icon(
                      isSaved.value ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: _toggleSaveStatus,
                  )),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature coming soon')),
                  );
                },
              ),
            ],
          ),
        ),

        // Main content
        Expanded(child: _buildDetailsContent(context)),
      ],
    );
  }

  Widget _buildDetailsContent(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    if (isWideScreen) {
      return _buildWideLayout(context);
    } else {
      return _buildNarrowLayout(context);
    }
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and tags
            _buildTitleSection(),
            const SizedBox(height: 24),

            // Award card
            _buildAwardCard(),
            const SizedBox(height: 24),

            // Description and requirements
            _buildInfoSections(),
            const SizedBox(height: 24),

            // Source information
            _buildSourceCard(),
            const SizedBox(height: 32),

            // Apply button
            _buildApplyButton(context),

            // Visit Website button for narrow layout
            if (widget.scholarship.sourceWebsite.isNotEmpty) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _launchUrl(widget.scholarship.sourceWebsite),
                icon: const Icon(Icons.launch),
                label: const Text('Visit Website'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main content area
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(),
                const SizedBox(height: 24),
                _buildAwardCard(),
                const SizedBox(height: 24),
                _buildInfoSections(),
              ],
            ),
          ),
        ),

        // Sidebar
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSourceCard(),
                const SizedBox(height: 24),
                _buildApplyButton(context),
                if (widget.scholarship.sourceWebsite.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _launchUrl(widget.scholarship.sourceWebsite),
                    icon: const Icon(Icons.launch),
                    label: const Text('Visit Website'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // SECTION BUILDERS

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scholarship Title
        Text(
          widget.scholarship.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTag('Deadline: ${widget.scholarship.deadline}', Colors.blue),
            if (widget.scholarship.meritBased)
              _buildTag('Merit-Based', Colors.green),
            if (widget.scholarship.needBased)
              _buildTag('Need-Based', Colors.orange),
            if (widget.scholarship.requiredGpa != null)
              _buildTag(
                  'Min GPA: ${widget.scholarship.requiredGpa}', Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildAwardCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [TColors.primary, TColors.primary.withAlpha(180)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Award Amount',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.scholarship.amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        _buildInfoSection('Description', widget.scholarship.description),

        // Eligibility
        if (widget.scholarship.eligibility != null)
          _buildInfoSection('Eligibility', widget.scholarship.eligibility!),

        // Application Process
        if (widget.scholarship.applicationProcess != null)
          _buildInfoSection(
              'Application Process', widget.scholarship.applicationProcess!),

        // Required Documents
        if (widget.scholarship.requiredDocuments != null)
          _buildInfoSection(
              'Required Documents', widget.scholarship.requiredDocuments!),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: TColors.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: TColors.primary,
              ),
            ),
          ),
          Text(
            content,
            style: const TextStyle(
              height: 1.5,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: TColors.primary.withAlpha(25),
                  child: Icon(Icons.school, color: TColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Source',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        widget.scholarship.sourceName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.scholarship.sourceWebsite.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.open_in_new, color: TColors.primary),
                    onPressed: () =>
                        _launchUrl(widget.scholarship.sourceWebsite),
                    tooltip: 'Visit source website',
                  ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: TColors.primary.withAlpha(25),
                  child: Icon(Icons.calendar_today, color: TColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Deadline',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        widget.scholarship.deadline,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _launchUrl(widget.scholarship.applicationLink),
      icon: const Icon(Icons.send),
      label: const Text('Apply Now'),
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
