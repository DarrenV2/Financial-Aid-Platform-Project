import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/assessment_result.dart';
import '../../services/learning_service.dart';
import '../../services/progress_service.dart';
import '../widgets/recommendation_card.dart';
import 'learning_plan_screen.dart';
//import '../widgets/recommendation_card.dart';

class AssessmentResultScreen extends StatefulWidget {
  final AssessmentResult result;
  final bool isPostAssessment;
  final AssessmentResult? previousResult;

  const AssessmentResultScreen({
    Key? key,
    required this.result,
    this.isPostAssessment = false,
    this.previousResult,
  }) : super(key: key);

  @override
  _AssessmentResultScreenState createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen> {
  final ProgressService _progressService = ProgressService();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _saveAssessmentResult();
  }

  Future<void> _saveAssessmentResult() async {
    setState(() {
      isSaving = true;
    });

    try {
      // In a real app, this would save to a database
      // Using a mock user ID for demonstration
      await _progressService.saveAssessmentResult('user123', widget.result);
    } catch (e) {
      // Handle error
      print('Error saving assessment result: $e');
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Assessment Results'),
        elevation: 0,
      ),
      body: isSaving
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Saving your results...'),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overall score card
              _buildScoreCard(context),

              SizedBox(height: 24),

              // Progress comparison if post assessment
              if (widget.isPostAssessment && widget.previousResult != null)
                _buildProgressComparisonCard(context),

              SizedBox(height: 24),

              // Eligibility section
              _buildEligibilitySection(context),

              SizedBox(height: 24),

              // Category scores section
              _buildCategoryScoresSection(context),

              SizedBox(height: 24),

              // Recommendations section
              _buildRecommendationsSection(context),

              SizedBox(height: 24),

              // Next steps button
              ElevatedButton(
                onPressed: () {
                  // Navigate to learning plan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearningPlanScreen(result: widget.result),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('View Your Personalized Learning Plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Your Scholarship Readiness Score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: widget.result.overallScore / 100,
                    strokeWidth: 15,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getScoreColor(widget.result.overallScore),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${widget.result.overallScore.toInt()}%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(widget.result.overallScore),
                      ),
                    ),
                    Text(_getScoreLabel(widget.result.overallScore)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Assessment Date: ${_formatDate(widget.result.timestamp)}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressComparisonCard(BuildContext context) {
    final previousScore = widget.previousResult!.overallScore;
    final currentScore = widget.result.overallScore;
    final difference = currentScore - previousScore;
    final isImprovement = difference >= 0;

    return Card(
      elevation: 3,
      color: isImprovement ? Colors.green[50] : Colors.orange[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressItem(
                  'Previous Score',
                  '${previousScore.toInt()}%',
                  Colors.blue,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey,
                ),
                _buildProgressItem(
                  'Current Score',
                  '${currentScore.toInt()}%',
                  _getScoreColor(currentScore),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey,
                ),
                _buildProgressItem(
                  isImprovement ? 'Improvement' : 'Change',
                  '${isImprovement ? '+' : ''}${difference.toInt()}%',
                  isImprovement ? Colors.green : Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              isImprovement
                  ? 'Great job! You\'ve improved your scholarship readiness.'
                  : 'Keep working on the recommended areas to improve your score.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: isImprovement ? Colors.green[800] : Colors.orange[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEligibilitySection(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scholarship Eligibility',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildEligibilityCard(
                    'Merit-Based',
                    widget.result.eligibility.meritBased,
                    Icons.school,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildEligibilityCard(
                    'Need-Based',
                    widget.result.eligibility.needBased,
                    Icons.account_balance,
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ExpansionTile(
              title: Text('Your Strengths'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.result.eligibility.strengthAreas.length,
                  itemBuilder: (context, index) {
                    String category = widget.result.eligibility.strengthAreas.keys.elementAt(index);
                    String strength = widget.result.eligibility.strengthAreas.values.elementAt(index);
                    return ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(strength),
                      subtitle: Text(_formatCategoryName(category)),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Areas for Improvement'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.result.eligibility.improvementAreas.length,
                  itemBuilder: (context, index) {
                    String category = widget.result.eligibility.improvementAreas.keys.elementAt(index);
                    String improvement = widget.result.eligibility.improvementAreas.values.elementAt(index);
                    return ListTile(
                      leading: Icon(
                        Icons.arrow_upward,
                        color: Colors.orange,
                      ),
                      title: Text(improvement),
                      subtitle: Text(_formatCategoryName(category)),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilityCard(String title, bool isEligible, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEligible ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEligible ? color : Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isEligible ? color : Colors.grey,
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            isEligible ? 'Eligible' : 'Not Yet Eligible',
            style: TextStyle(
              color: isEligible ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryScoresSection(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Scores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...widget.result.categoryScores.entries.map((entry) {
              String category = entry.key;
              double score = entry.value;

              // If post assessment, calculate difference from previous
              double? difference;
              if (widget.isPostAssessment && widget.previousResult != null) {
                final previousScore = widget.previousResult!.categoryScores[category] ?? 0.0;
                difference = score - previousScore;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatCategoryName(category),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${score.toInt()}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(score),
                              ),
                            ),
                            if (difference != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  '(${difference > 0 ? '+' : ''}${difference.toInt()}%)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: difference >= 0 ? Colors.green : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  _buildRecommendationsSection(context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personalized Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...widget.result.recommendations.map((recommendation) {
              return RecommendationCard(recommendation: recommendation);
            }).toList()
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCategoryName(String category) {
    return category.replaceAll('_', ' ').split(' ').map((word) =>
    word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }
}




