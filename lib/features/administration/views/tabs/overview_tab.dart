import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/admin_dashboard_controller.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/routes/routes.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();

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

            // Two column layout for middle section
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                // Two column layout for wider screens
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column (60% width)
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRecentActivity(),
                          const SizedBox(height: 24),
                          _buildScholarshipTypeBreakdown(),
                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Right column (40% width)
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCalendarCard(),
                          const SizedBox(height: 24),
                          _buildTodoListCard(),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Single column layout for smaller screens
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRecentActivity(),
                    const SizedBox(height: 24),
                    _buildScholarshipTypeBreakdown(),
                    const SizedBox(height: 24),
                    _buildCalendarCard(),
                    const SizedBox(height: 24),
                    _buildTodoListCard(),
                  ],
                );
              }
            }),

            const SizedBox(height: 30),

            // Action cards
            _buildActionCards(),
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

  Widget _buildRecentActivity() {
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
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    color: TColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildActivityItem(
              'New scholarship added',
              'Engineering Scholarship for STEM Students',
              '10 minutes ago',
              Colors.green,
            ),
            const Divider(),
            _buildActivityItem(
              'User registered',
              'James Wilson completed registration',
              '1 hour ago',
              Colors.blue,
            ),
            const Divider(),
            _buildActivityItem(
              'Application submitted',
              'Emma Davis applied for Mathematics Grant',
              '3 hours ago',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String description, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipTypeBreakdown() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scholarship Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Type breakdown
            Row(
              children: [
                _buildTypeBreakdownItem('Merit-Based', '45%', Colors.orange),
                _buildTypeBreakdownItem('Need-Based', '30%', Colors.green),
                _buildTypeBreakdownItem('Others', '25%', Colors.blue),
              ],
            ),

            const SizedBox(height: 20),

            // Simple bar chart
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                _buildCategoryBar('Engineering', 0.8, Colors.blue),
                const SizedBox(height: 10),
                _buildCategoryBar('Medical', 0.65, Colors.green),
                const SizedBox(height: 10),
                _buildCategoryBar('Business', 0.5, Colors.orange),
                const SizedBox(height: 10),
                _buildCategoryBar('Arts', 0.35, Colors.purple),
                const SizedBox(height: 10),
                _buildCategoryBar('Others', 0.2, Colors.grey),
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

  Widget _buildCalendarCard() {
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
                  'Calendar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 20),

            // Month picker with proper constraints
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back_ios, size: 14),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          DateFormat('MMMM yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: TColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 12,
                      color: TColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Calendar header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Mo', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Tu', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('We', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Th', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Fr', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Sa', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Su', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 10),

            // Calendar grid (simplified)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 30, // Simplified
              itemBuilder: (context, index) {
                final day = index + 1;
                final isToday = day == DateTime.now().day;
                final hasEvent = [5, 12, 18, 25].contains(day);

                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isToday ? TColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.black,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (hasEvent)
                        Positioned(
                          bottom: 2,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isToday ? Colors.white : TColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoListCard() {
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
                  'To-Do List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.add_circle_outline, color: TColors.primary),
              ],
            ),
            const SizedBox(height: 20),

            // Todo items
            _buildTodoItem('Review new scholarship applications', true),
            _buildTodoItem('Update scholarship deadlines', false),
            _buildTodoItem('Send newsletter to registered users', false),
            _buildTodoItem('Check web scraper results', false),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoItem(String task, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted ? TColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isCompleted ? null : Border.all(color: Colors.grey),
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              task,
              style: TextStyle(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Use SingleChildScrollView for action cards to prevent overflow on small screens
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 240,
                child: _buildActionCard(
                  'Manage Scholarships',
                  'Add, edit or delete scholarship listings',
                  Icons.school,
                  const Color(0xFF4361EE),
                  () => Get.toNamed(TRoutes.scholarshipList),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 240,
                child: _buildActionCard(
                  'User Management',
                  'View and manage user accounts',
                  Icons.people,
                  const Color(0xFF3A0CA3),
                  () {},
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 240,
                child: _buildActionCard(
                  'System Settings',
                  'Configure system parameters',
                  Icons.settings,
                  const Color(0xFF7209B7),
                  () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
