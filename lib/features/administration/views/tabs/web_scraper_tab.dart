import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';

class WebScraperTab extends StatefulWidget {
  const WebScraperTab({super.key});

  @override
  State<WebScraperTab> createState() => _WebScraperTabState();
}

class _WebScraperTabState extends State<WebScraperTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Form controllers for adding new scraping source
  final TextEditingController _sourceNameController = TextEditingController();
  final TextEditingController _sourceUrlController = TextEditingController();

  @override
  void dispose() {
    _sourceNameController.dispose();
    _sourceUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScrapingStatisticsCard(),
          const SizedBox(height: 24),
          _buildActionsCard(),
        ],
      ),
    );
  }

  Widget _buildScrapingStatisticsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: TColors.primary),
                SizedBox(width: 12),
                Text(
                  'Scraping Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Statistics content
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('scholarships').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final scholarships = snapshot.data?.docs ?? [];
                  final totalCount = scholarships.length;

                  // Count merit-based scholarships
                  final meritBasedCount = scholarships.where((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    return data != null && data['meritBased'] == true;
                  }).length;

                  // Count need-based scholarships
                  final needBasedCount = scholarships.where((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    return data != null && data['needBased'] == true;
                  }).length;

                  return Container(
                    decoration: BoxDecoration(
                      color: TColors.primary.withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatisticItem(
                          Icons.school,
                          'Total',
                          totalCount.toString(),
                          Colors.blue,
                        ),
                        _buildStatisticItem(
                          Icons.workspace_premium,
                          'Merit-Based',
                          meritBasedCount.toString(),
                          Colors.amber,
                        ),
                        _buildStatisticItem(
                          Icons.attach_money,
                          'Need-Based',
                          needBasedCount.toString(),
                          Colors.green,
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticItem(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.settings, color: TColors.primary),
                SizedBox(width: 12),
                Text(
                  'Scraper Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Source'),
                    onPressed: _showAddSourceDialog,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: TColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Trigger Scrape'),
                    onPressed: _triggerManualScrape,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  Widget _buildScraperActivitySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notifications, color: TColors.primary),
                SizedBox(width: 12),
                Text(
                  'Recent Scraper Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('admin_notifications')
                    .where('type', isEqualTo: 'scraper_notification')
                    .orderBy('timestamp', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final notifications = snapshot.data?.docs ?? [];

                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No scraper activity found',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final notification =
                          notifications[index].data() as Map<String, dynamic>;
                      final timestamp = notification['timestamp'] as Timestamp?;
                      final formattedDate = timestamp != null
                          ? DateFormat('yyyy-MM-dd HH:mm')
                              .format(timestamp.toDate())
                          : 'Unknown date';

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: notification['read'] == true
                                ? Colors.grey.withAlpha(30)
                                : TColors.primary.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.web,
                            color: notification['read'] == true
                                ? Colors.grey
                                : TColors.primary,
                          ),
                        ),
                        title: Text(
                          notification['message'] ?? 'Unknown notification',
                          style: TextStyle(
                            fontWeight: notification['read'] == true
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(formattedDate),
                        trailing: notification['read'] == true
                            ? const Icon(Icons.visibility, color: Colors.grey)
                            : const Icon(Icons.visibility_off,
                                color: Colors.red),
                        onTap: () {
                          if (notification['read'] != true) {
                            // Mark as read
                            _firestore
                                .collection('admin_notifications')
                                .doc(notifications[index].id)
                                .update({'read': true});
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Feature Coming Soon'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.engineering,
              size: 60,
              color: TColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'This feature will be implemented in the future.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _triggerManualScrape() {
    Get.dialog(
      AlertDialog(
        title: const Text('Feature Coming Soon'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.engineering,
              size: 60,
              color: TColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'This feature will be implemented in the future.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
