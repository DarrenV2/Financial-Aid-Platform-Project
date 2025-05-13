import 'package:financial_aid_project/features/scholarship/models/scholarship.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/features/scholarship/controllers/scholarship_controllers.dart';
import 'package:financial_aid_project/features/scholarship/views/components/scholarship_card.dart';
import 'package:financial_aid_project/features/scholarship/controllers/saved_scholarship_controller.dart';
import 'package:financial_aid_project/features/scholarship/views/saved_scholarships_screen.dart';

class ScholarshipList extends StatefulWidget {
  final Function(Scholarship)? onScholarshipSelected;
  final bool isEmbedded;

  const ScholarshipList({
    super.key,
    this.onScholarshipSelected,
    this.isEmbedded = false,
  });

  @override
  State<ScholarshipList> createState() => _ScholarshipListState();
}

class _ScholarshipListState extends State<ScholarshipList> {
  final ScholarshipController _controller = Get.find<ScholarshipController>();
  late SavedScholarshipController _savedController;
  final TextEditingController _searchController = TextEditingController();

  // Filter states
  bool _showFilters = false;
  bool _meritBased = false;
  bool _needBased = false;
  double _gpa = 0.0;
  String _sortBy = "Deadline (Nearest First)";

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ScholarshipController>()) {
      Get.put(ScholarshipController());
    }
    if (_controller.scholarships.isEmpty) {
      _controller.fetchScholarships();
    }

    // Initialize saved scholarship controller
    if (!Get.isRegistered<SavedScholarshipController>()) {
      Get.put(SavedScholarshipController());
    }
    _savedController = Get.find<SavedScholarshipController>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Scholarship> get _filteredScholarships {
    List<Scholarship> result = List<Scholarship>.from(_controller.scholarships);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      result = _controller.searchScholarships(_searchController.text);
    }

    // Apply type filters
    if (_meritBased || _needBased || _gpa > 0.0) {
      result = _controller.getFilteredScholarships(
        meritBased: _meritBased ? true : null,
        needBased: _needBased ? true : null,
        minGpa: _gpa > 0.0 ? _gpa : null,
      );
    }

    // Apply sorting - create a copy to avoid modifying the original list
    List<Scholarship> sortedResult = List<Scholarship>.from(result);
    switch (_sortBy) {
      case "Deadline (Nearest First)":
        sortedResult.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case "Amount (Highest First)":
        // This is simplified; you'd need proper amount parsing
        sortedResult.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case "Recently Added":
        sortedResult.sort((a, b) {
          if (a.scrapedDate == null && b.scrapedDate == null) return 0;
          if (a.scrapedDate == null) return 1;
          if (b.scrapedDate == null) return -1;
          return b.scrapedDate!.compareTo(a.scrapedDate!);
        });
        break;
    }

    return sortedResult;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEmbedded
        ? _buildContent()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Scholarships'),
              elevation: 0,
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmark),
                  onPressed: () {
                    // Navigate to saved scholarships
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedScholarshipsScreen(),
                        ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    setState(() => _showFilters = !_showFilters);
                  },
                ),
              ],
            ),
            body: _buildContent(),
          );
  }

  Widget _buildContent() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search scholarships...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      ),
                    IconButton(
                      icon: Icon(_showFilters
                          ? Icons.filter_list_off
                          : Icons.filter_list),
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Filters section
          if (_showFilters) _buildFilters(),

          // Scholarships grid
          Expanded(
            child: _controller.scholarships.isEmpty
                ? _buildEmptyState()
                : _filteredScholarships.isEmpty
                    ? _buildNoResultsState()
                    : _buildScholarshipGrid(),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No scholarships available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              _controller.fetchScholarships();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No matching scholarships found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _meritBased = false;
                _needBased = false;
                _gpa = 0.0;
                _showFilters = false;
              });
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Scholarships',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reset'),
                onPressed: () {
                  setState(() {
                    _meritBased = false;
                    _needBased = false;
                    _gpa = 0.0;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: TColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                ),
              ),
            ],
          ),

          // Scholarship type filters
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Merit-Based'),
                selected: _meritBased,
                onSelected: (value) {
                  setState(() {
                    _meritBased = value;
                  });
                },
                checkmarkColor: Colors.white,
                selectedColor: TColors.primary,
                labelStyle: TextStyle(
                  color: _meritBased ? Colors.white : null,
                ),
              ),
              FilterChip(
                label: const Text('Need-Based'),
                selected: _needBased,
                onSelected: (value) {
                  setState(() {
                    _needBased = value;
                  });
                },
                checkmarkColor: Colors.white,
                selectedColor: TColors.primary,
                labelStyle: TextStyle(
                  color: _needBased ? Colors.white : null,
                ),
              ),
            ],
          ),

          // GPA slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Minimum GPA: ${_gpa.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Slider(
                value: _gpa,
                min: 0.0,
                max: 4.0,
                divisions: 8,
                label: _gpa.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _gpa = value;
                  });
                },
                activeColor: TColors.primary,
              ),
            ],
          ),

          // Sort options
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                const Text(
                  'Sort by: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _sortBy,
                  isDense: true,
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(
                      value: 'Deadline (Nearest First)',
                      child: Text('Deadline'),
                    ),
                    DropdownMenuItem(
                      value: 'Amount (Highest First)',
                      child: Text('Amount'),
                    ),
                    DropdownMenuItem(
                      value: 'Recently Added',
                      child: Text('Recent'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortBy = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipGrid() {
    return Obx(() => GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(context),
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _filteredScholarships.length,
          itemBuilder: (context, index) {
            final scholarship = _filteredScholarships[index];
            final bool isSaved =
                _savedController.isScholarshipSaved(scholarship.id);

            return ScholarshipCard(
              scholarship: scholarship,
              onTap: widget.onScholarshipSelected != null
                  ? () => widget.onScholarshipSelected!(scholarship)
                  : null,
              isSaved: isSaved,
              onSaveToggle: () => _toggleSaveStatus(scholarship),
            );
          },
        ));
  }

  void _toggleSaveStatus(Scholarship scholarship) async {
    final bool success =
        await _savedController.toggleSaveStatus(scholarship.id);

    if (success) {
      _showSaveStatusSnackbar(
          _savedController.isScholarshipSaved(scholarship.id));
    } else if (_savedController.errorMessage.value.isNotEmpty) {
      _showErrorSnackbar(_savedController.errorMessage.value);
    }
  }

  void _showSaveStatusSnackbar(bool isSaved) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved
            ? 'Scholarship saved successfully!'
            : 'Scholarship removed from saved items'),
        backgroundColor: isSaved ? TColors.success : TColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: isSaved ? 'VIEW SAVED' : 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            if (isSaved) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedScholarshipsScreen(),
                ),
              );
            }
          },
        ),
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

  int _calculateCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
