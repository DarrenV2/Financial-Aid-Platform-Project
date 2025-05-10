import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../../controllers/scholarship_stats_controller.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();
    final statsController = Get.put(ScholarshipStatsController());

    return Obx(() {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick stats section
            _buildQuickStats(controller),

            const SizedBox(height: 30),

            // Single column layout for scholarship breakdown
            _buildScholarshipTypeBreakdown(statsController),

            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }

  Widget _buildQuickStats(AdminDashboardController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.primary, TColors.primary.withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to ScholarsHub Admin',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats row with SingleChildScrollView to prevent overflow
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildQuickStatItem(
                  controller.totalScholarships.toString(),
                  'Total Scholarships',
                  Icons.school,
                ),
                _buildQuickStatItem(
                  controller.activeUsers.toString(),
                  'Active Users',
                  Icons.person,
                ),
                _buildQuickStatItem(
                  controller.applications.toString(),
                  'Applications',
                  Icons.description,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String value, String label, IconData icon) {
    return Container(
      width: null,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipTypeBreakdown(ScholarshipStatsController controller) {
    // Map scholarship type to color
    final Map<String, Color> typeColors = {
      'meritBased': Colors.orange,
      'needBased': Colors.green,
      'both': Colors.blue,
      'other': Colors.grey,
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scholarship Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),

            // Scholarship type breakdown
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Type breakdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            controller.getTypeStatsForDisplay().map((stat) {
                          return _buildTypeBreakdownItem(
                            stat['displayName'],
                            stat['percentageStr'],
                            typeColors[stat['type']] ?? Colors.grey,
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 25),

                      // Category breakdown header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () => controller.fetchScholarshipStats(),
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Category bars
                      ...controller.getCategoryStatsForDisplay().map(
                            (stat) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildCategoryBar(
                                stat['category'],
                                stat['percentage'],
                                _getCategoryColor(stat['category']),
                              ),
                            ),
                          ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBreakdownItem(String label, String percentage, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                percentage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${(percentage * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    // Map categories to fixed colors for consistency
    final Map<String, Color> categoryColors = {
      'Engineering': Colors.blue,
      'Medical': Colors.green,
      'Business': Colors.orange,
      'Arts': Colors.purple,
      'Science': Colors.teal,
      'Technology': Colors.indigo,
      'Humanities': Colors.deepPurple,
      'Law': Colors.red,
      'Education': Colors.amber,
      'Others': Colors.grey,
    };

    return categoryColors[category] ?? Colors.grey.shade700;
  }
}
