import 'package:financial_aid_project/features/scholarship/controllers/scholarship_controllers.dart';
import 'package:financial_aid_project/features/scholarship/models/scholarship.dart';
import 'package:financial_aid_project/features/scholarship/views/scholarship_list.dart';
import 'package:financial_aid_project/features/scholarship/views/scholarship_details.dart';
import 'package:financial_aid_project/shared_components/responsive_builder.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScholarshipOverview extends StatefulWidget {
  final bool isEmbedded;

  const ScholarshipOverview({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<ScholarshipOverview> createState() => _ScholarshipOverviewState();
}

class _ScholarshipOverviewState extends State<ScholarshipOverview> {
  final ScholarshipController _controller = Get.find<ScholarshipController>();
  bool _showScholarshipList = false;
  Scholarship? _selectedScholarship;
  bool _showScholarshipDetails = false;

  // Current month for calendar view
  final DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ScholarshipController>()) {
      Get.put(ScholarshipController());
    }
    if (_controller.scholarships.isEmpty) {
      _controller.fetchScholarships();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showScholarshipDetails && _selectedScholarship != null) {
      return ScholarshipDetails(
        scholarship: _selectedScholarship!,
        isEmbedded: widget.isEmbedded,
        onBack: () {
          setState(() {
            _showScholarshipDetails = false;
          });
        },
      );
    } else if (_showScholarshipList) {
      return Column(
        children: [
          // App bar with back button
          Container(
            padding: const EdgeInsets.all(16),
            color: TColors.primary,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _showScholarshipList = false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'All Scholarships',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scholarship list
          Expanded(
            child: ScholarshipList(
              isEmbedded: true,
              onScholarshipSelected: (scholarship) {
                setState(() {
                  _selectedScholarship = scholarship;
                  _showScholarshipDetails = true;
                });
              },
            ),
          ),
        ],
      );
    }

    return ResponsiveBuilder(
      mobileBuilder: (context, constraints) => _buildMobileLayout(),
      tabletBuilder: (context, constraints) => _buildTabletLayout(),
      desktopBuilder: (context, constraints) => _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildActionCards(crossAxisCount: 1),
            const SizedBox(height: 24),
            _buildSectionTitle('Recent Scholarships'),
            _buildRecentScholarships(),
            const SizedBox(height: 24),
            _buildSectionTitle('Scholarship Calendar'),
            _buildCalendarView(),
            const SizedBox(height: 24),
            _buildSectionTitle('Scholarship News'),
            _buildNewsFeed(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildActionCards(crossAxisCount: 2),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Recent Scholarships'),
                      _buildRecentScholarships(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Scholarship News'),
                      _buildNewsFeed(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Scholarship Calendar'),
            _buildCalendarView(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            _buildActionCards(crossAxisCount: 4),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Recent Scholarships'),
                      _buildRecentScholarships(showAsGrid: true),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Scholarship Calendar'),
                      _buildCalendarView(isWideLayout: true),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Scholarship News'),
                      _buildNewsFeed(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColors.primary,
            TColors.primary.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scholarship Hub',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                'Discover ${_controller.scholarships.length} scholarship opportunities',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showScholarshipList = true;
              });
            },
            icon: const Icon(Icons.search),
            label: const Text('Find Scholarships'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: TColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards({required int crossAxisCount}) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildActionCard(
          title: 'Browse All',
          description: 'Explore all available scholarships',
          icon: Icons.school,
          color: Colors.blue,
          onTap: () {
            setState(() {
              _showScholarshipList = true;
            });
          },
        ),
        _buildActionCard(
          title: 'Saved Scholarships',
          description: 'View your bookmarked scholarships',
          icon: Icons.bookmark,
          color: Colors.green,
          onTap: () {
            Navigator.pushNamed(context, '/saved-scholarships');
          },
        ),
        _buildActionCard(
          title: 'Recommendations',
          description: 'Scholarships matched to your profile',
          icon: Icons.recommend,
          color: Colors.orange,
          onTap: () {
            // Navigate to recommendations
          },
        ),
        _buildActionCard(
          title: 'Upcoming Deadlines',
          description: 'Scholarships closing soon',
          icon: Icons.timer,
          color: Colors.red,
          onTap: () {
            // Filter to show only upcoming deadlines
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, color.withAlpha(25)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withAlpha(51),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
          ),
          if (title == 'Recent Scholarships')
            TextButton(
              onPressed: () {
                setState(() {
                  _showScholarshipList = true;
                });
              },
              child: const Text('See All'),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentScholarships({bool showAsGrid = false}) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final scholarships = _controller.getLatestScholarships();

      if (scholarships.isEmpty) {
        return _buildEmptyState('No scholarships available yet', Icons.school);
      }

      if (showAsGrid) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: scholarships.length > 4 ? 4 : scholarships.length,
          itemBuilder: (context, index) {
            return _buildScholarshipCard(scholarships[index]);
          },
        );
      }

      return SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: scholarships.length,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 280,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildScholarshipCard(scholarships[index]),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildScholarshipCard(Scholarship scholarship) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedScholarship = scholarship;
            _showScholarshipDetails = true;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  scholarship.amount,
                  style: TextStyle(
                    color: TColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                scholarship.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Deadline: ${scholarship.deadline}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  if (scholarship.meritBased) _buildTag('Merit', Colors.blue),
                  if (scholarship.needBased)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: _buildTag('Need', Colors.green),
                    ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, color: TColors.primary, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView({bool isWideLayout = false}) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startWeekday =
        firstDayOfMonth.weekday % 7; // 0 = Sunday, 1 = Monday, etc.

    // Map scholarships to days they're due
    final Map<int, List<Scholarship>> scholarshipsByDay = {};
    for (final scholarship in _controller.scholarships) {
      try {
        // Parse the deadline (this is simplified, assumes a format)
        final date = DateFormat('yyyy-MM-dd').parse(scholarship.deadline);
        if (date.year == _currentMonth.year &&
            date.month == _currentMonth.month) {
          scholarshipsByDay[date.day] = [
            ...scholarshipsByDay[date.day] ?? [],
            scholarship
          ];
        }
      } catch (e) {
        // Skip if date format isn't parseable
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          // Navigation logic for previous month
                        });
                      },
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_currentMonth),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          // Navigation logic for next month
                        });
                      },
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Full Calendar'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Full calendar feature coming soon')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Calendar day headers
            Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: startWeekday + daysInMonth,
              itemBuilder: (context, index) {
                if (index < startWeekday) {
                  return Container(); // Empty cell before month start
                }

                final day = index - startWeekday + 1;
                final hasScholarships = scholarshipsByDay.containsKey(day);
                final isToday = _currentMonth.year == DateTime.now().year &&
                    _currentMonth.month == DateTime.now().month &&
                    day == DateTime.now().day;

                return GestureDetector(
                  onTap: hasScholarships
                      ? () {
                          // Show scholarships due on this day
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  'Scholarships due on ${DateFormat('MMM d').format(
                                DateTime(_currentMonth.year,
                                    _currentMonth.month, day),
                              )}'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: scholarshipsByDay[day]!.length,
                                  itemBuilder: (context, index) {
                                    final scholarship =
                                        scholarshipsByDay[day]![index];
                                    return ListTile(
                                      title: Text(scholarship.title),
                                      subtitle: Text(scholarship.amount),
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          _selectedScholarship = scholarship;
                                          _showScholarshipDetails = true;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasScholarships
                          ? TColors.primary.withAlpha(25)
                          : isToday
                              ? Colors.grey.withAlpha(25)
                              : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(color: TColors.primary, width: 2)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              fontWeight: isToday || hasScholarships
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: hasScholarships ? TColors.primary : null,
                            ),
                          ),
                        ),
                        if (hasScholarships)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: TColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Calendar legend
            Row(
              children: [
                _buildCalendarLegendItem(
                  color: TColors.primary.withAlpha(25),
                  text: 'Scholarships Due',
                  hasDot: true,
                ),
                const SizedBox(width: 16),
                _buildCalendarLegendItem(
                  color: Colors.grey.withAlpha(25),
                  text: 'Today',
                  hasBorder: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarLegendItem({
    required Color color,
    required String text,
    bool hasDot = false,
    bool hasBorder = false,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border:
                hasBorder ? Border.all(color: TColors.primary, width: 2) : null,
          ),
          child: hasDot
              ? Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsFeed() {
    // This would typically come from an API
    final newsItems = [
      _NewsItem(
        title: 'New Engineering Scholarships Added',
        date: DateTime.now().subtract(const Duration(days: 1)),
        imageUrl:
            'https://images.pexels.com/photos/159844/cellular-education-classroom-159844.jpeg',
        content:
            '5 new scholarships for engineering students have been added with a total value of over \$25,000.',
      ),
      _NewsItem(
        title: 'Deadline Extended: Arts Grant',
        date: DateTime.now().subtract(const Duration(days: 3)),
        imageUrl:
            'https://images.pexels.com/photos/267507/pexels-photo-267507.jpeg',
        content:
            'The application deadline for the Arts Excellence Grant has been extended by two weeks.',
      ),
      _NewsItem(
        title: 'Scholarship Workshop This Friday',
        date: DateTime.now().subtract(const Duration(days: 5)),
        imageUrl:
            'https://images.pexels.com/photos/3184317/pexels-photo-3184317.jpeg',
        content:
            'Join us for a virtual workshop on how to write winning scholarship essays.',
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: newsItems.map((news) => _buildNewsItem(news)).toList(),
        ),
      ),
    );
  }

  Widget _buildNewsItem(_NewsItem news) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                news.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.school, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  news.content,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, yyyy').format(news.date),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _NewsItem {
  final String title;
  final DateTime date;
  final String imageUrl;
  final String content;

  _NewsItem({
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.content,
  });
}
