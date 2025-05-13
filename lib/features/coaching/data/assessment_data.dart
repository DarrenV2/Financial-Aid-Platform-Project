import '../models/question.dart';

class AssessmentData {
  // Pre-assessment questions based on provided data
  final List<Question> preAssessmentQuestions = [
    // Personal Information
    Question(
      id: 'citizenship',
      text: 'Are you a Jamaican citizen or permanent resident?',
      type: QuestionType.boolean,
      category: 'personal',
    ),
    Question(
      id: 'utech_student',
      text: 'Do you have a valid UTech student ID card?',
      type: QuestionType.boolean,
      category: 'personal',
    ),
    Question(
      id: 'enrollment_status',
      text: 'What is your enrollment status?',
      type: QuestionType.singleChoice,
      options: [
        Option(id: 'full_time', text: 'Full-time student', value: 'full_time'),
        Option(id: 'part_time', text: 'Part-time student', value: 'part_time'),
      ],
      category: 'personal',
    ),
    Question(
      id: 'previous_scholarship',
      text:
          'Have you been previously awarded a Scholarship/Bursary tenable at UTech?',
      type: QuestionType.boolean,
      category: 'personal',
    ),

    // Financial Need
    Question(
      id: 'parents_income',
      text: 'Are you aware of how much your parents earn?',
      type: QuestionType.boolean,
      category: 'financial',
    ),
    Question(
      id: 'additional_workers',
      text:
          'Are there any additional working adults in your household who contribute financially?',
      type: QuestionType.boolean,
      category: 'financial',
    ),
    Question(
      id: 'siblings_tertiary',
      text: 'Do you have siblings currently enrolled in tertiary education?',
      type: QuestionType.boolean,
      category: 'financial',
    ),
    Question(
      id: 'first_generation',
      text: 'Are you the first person in your family to attend university?',
      type: QuestionType.boolean,
      category: 'financial',
    ),
    Question(
      id: 'dependents',
      text: 'Number of Dependents in the Household (including yourself):',
      type: QuestionType.singleChoice,
      options: [
        Option(id: '1-3', text: '1-3', value: '1-3'),
        Option(id: '4-6', text: '4-6', value: '4-6'),
        Option(id: '6-9', text: '6-9', value: '6-9'),
        Option(id: '9+', text: '9 and up', value: '9+'),
      ],
      category: 'financial',
    ),
    Question(
      id: 'financial_assistance',
      text: 'Does your family receive any financial assistance?',
      type: QuestionType.multipleChoice,
      options: [
        Option(id: 'path', text: 'PATH', value: 'path'),
        Option(id: 'gov_aid', text: 'Government Aid', value: 'gov_aid'),
        Option(
            id: 'family_support',
            text: 'Family Support',
            value: 'family_support'),
        Option(id: 'none', text: 'None', value: 'none'),
      ],
      category: 'financial',
    ),
    Question(
      id: 'employment',
      text:
          'Are you employed or do you have any other sources of personal income?',
      type: QuestionType.singleChoice,
      options: [
        Option(id: 'employed', text: 'Employed', value: 'employed'),
        Option(
            id: 'other_income',
            text: 'Other Sources of income',
            value: 'other_income'),
        Option(id: 'none', text: 'Currently none of the above', value: 'none'),
      ],
      category: 'financial',
    ),
    Question(
      id: 'financial_challenges',
      text:
          'Do you or your family currently face any significant financial challenges?',
      type: QuestionType.multipleChoice,
      options: [
        Option(id: 'medical', text: 'Medical Expenses', value: 'medical'),
        Option(
            id: 'dependents', text: 'Multiple dependents', value: 'dependents'),
        Option(id: 'unemployment', text: 'Unemployment', value: 'unemployment'),
        Option(id: 'none', text: 'None', value: 'none'),
      ],
      category: 'financial',
    ),
    Question(
      id: 'tuition_debt',
      text:
          'Do you currently have any outstanding tuition or school-related debt?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'under_400k', text: '400,000 JMD & under', value: 'under_400k'),
        Option(
            id: '400k_800k', text: '400,000 – 800,000 JMD', value: '400k_800k'),
        Option(
            id: '800k_1.2m',
            text: '800,000 -1.2 million JMD',
            value: '800k_1.2m'),
        Option(
            id: 'over_1.2m', text: 'More than 1.2 mil JMD', value: 'over_1.2m'),
      ],
      category: 'financial',
    ),

    // Academic
    Question(
      id: 'current_gpa',
      text: 'What is your current GPA?',
      type: QuestionType.singleChoice,
      options: [
        Option(id: 'under_2.0', text: 'Under 2.0', value: 'under_2.0'),
        Option(id: '2.1-3.0', text: '2.1- 3.0', value: '2.1-3.0'),
        Option(id: '3.0+', text: '3.0 and above', value: '3.0+'),
      ],
      category: 'academic',
    ),
    Question(
      id: 'academic_awards',
      text: 'Have you received any academic awards, honors, or recognition?',
      type: QuestionType.multipleChoice,
      options: [
        Option(id: 'deans_list', text: 'Dean\'s List', value: 'deans_list'),
        Option(
            id: 'presidents_honor',
            text: 'President\'s Honor Roll',
            value: 'presidents_honor'),
        Option(
            id: 'department_award',
            text: 'Department Award',
            value: 'department_award'),
        Option(
            id: 'scholarship',
            text: 'Academic Scholarship',
            value: 'scholarship'),
        Option(id: 'other_award', text: 'Other Award', value: 'other_award'),
        Option(id: 'none', text: 'None', value: 'none'),
      ],
      category: 'academic',
    ),
    Question(
      id: 'extracurricular',
      text: 'Have you participated in any extracurricular activities?',
      type: QuestionType.multipleChoice,
      options: [
        Option(id: 'sports', text: 'Sports Teams', value: 'sports'),
        Option(id: 'arts', text: 'Arts & Cultural Activities', value: 'arts'),
        Option(id: 'clubs', text: 'Academic Clubs', value: 'clubs'),
        Option(
            id: 'student_gov',
            text: 'Student Government',
            value: 'student_gov'),
        Option(
            id: 'volunteer',
            text: 'Volunteer Organizations',
            value: 'volunteer'),
        Option(id: 'none', text: 'None', value: 'none'),
      ],
      category: 'extracurricular',
    ),
    Question(
      id: 'community_activity',
      text: 'Are you currently participating in any community activity?',
      type: QuestionType.multipleChoice,
      options: [
        Option(id: 'mentoring', text: 'Mentoring/Tutoring', value: 'mentoring'),
        Option(id: 'fundraising', text: 'Fundraising', value: 'fundraising'),
        Option(
            id: 'environment',
            text: 'Environmental Initiatives',
            value: 'environment'),
        Option(
            id: 'health', text: 'Health & Wellness Programs', value: 'health'),
        Option(
            id: 'education', text: 'Educational Outreach', value: 'education'),
        Option(
            id: 'other_community',
            text: 'Other Community Service',
            value: 'other_community'),
        Option(id: 'none', text: 'Not Currently Participating', value: 'none'),
      ],
      category: 'community_service',
    ),
    Question(
      id: 'honor_societies',
      text: 'Are you currently a member of any honor societies or clubs?',
      type: QuestionType.multipleChoice,
      options: [
        Option(
            id: 'honor_society',
            text: 'National Honor Society',
            value: 'honor_society'),
        Option(
            id: 'subject_club',
            text: 'Subject-specific Club',
            value: 'subject_club'),
        Option(
            id: 'professional_org',
            text: 'Professional Organization',
            value: 'professional_org'),
        Option(id: 'other_club', text: 'Other Club', value: 'other_club'),
        Option(id: 'none', text: 'No, not a member', value: 'none'),
      ],
      category: 'extracurricular',
    ),
    Question(
      id: 'research_competition',
      text:
          'Have you ever presented research, participated in academic competitions before?',
      type: QuestionType.multipleChoice,
      options: [
        Option(
            id: 'published_research',
            text: 'Published research',
            value: 'published_research'),
        Option(
            id: 'research_team',
            text: 'Member of a research team',
            value: 'research_team'),
        Option(
            id: 'academic_competition',
            text: 'Academic competition',
            value: 'academic_competition'),
        Option(id: 'none', text: 'None', value: 'none'),
      ],
      category: 'academic',
    ),
    Question(
      id: 'leadership_position',
      text: 'Have you ever served in a leadership position?',
      type: QuestionType.multipleChoice,
      options: [
        Option(
            id: 'president',
            text: 'President/Chair of Organization',
            value: 'president'),
        Option(
            id: 'vice_president',
            text: 'Vice President',
            value: 'vice_president'),
        Option(id: 'secretary', text: 'Secretary', value: 'secretary'),
        Option(id: 'treasurer', text: 'Treasurer', value: 'treasurer'),
        Option(id: 'team_captain', text: 'Team Captain', value: 'team_captain'),
        Option(
            id: 'committee_chair',
            text: 'Committee Chair',
            value: 'committee_chair'),
        Option(
            id: 'project_lead', text: 'Project Leader', value: 'project_lead'),
        Option(id: 'none', text: 'None of the above', value: 'none'),
      ],
      category: 'leadership',
    ),
    Question(
      id: 'additional_qualifications',
      text:
          'Do you have any additional academic or professional qualifications?',
      type: QuestionType.multipleChoice,
      options: [
        Option(id: 'csec', text: 'CSEC', value: 'csec'),
        Option(id: 'cape', text: 'CAPE', value: 'cape'),
        Option(id: 'associate', text: 'Associate degree', value: 'associate'),
        Option(id: 'diploma', text: 'Diploma', value: 'diploma'),
        Option(id: 'certificate', text: 'Certificate', value: 'certificate'),
        Option(id: 'trade', text: 'Trade Skills', value: 'trade'),
        Option(id: 'none', text: 'None', value: 'none'),
      ],
      category: 'academic',
    ),
    Question(
      id: 'external_exams',
      text:
          'Have you completed any external exams (e.g., SAT, ACT, IB, Cambridge A-Levels)?',
      type: QuestionType.boolean,
      category: 'academic',
    ),
    Question(
      id: 'exchange_program',
      text:
          'Have you ever participated in an exchange program, study abroad, or any academic fellowships?',
      type: QuestionType.boolean,
      category: 'academic',
    ),
    Question(
      id: 'work_experience',
      text: 'Do you have any work experience related to your field of study?',
      type: QuestionType.boolean,
      category: 'extracurricular',
    ),
    Question(
      id: 'essay_grade',
      text: 'What grade do you typically receive when writing essays?',
      type: QuestionType.singleChoice,
      options: [
        Option(id: 'a', text: 'A (Excellent) – 80-100%', value: 'a'),
        Option(id: 'b', text: 'B (Good) – 70-79%', value: 'b'),
        Option(id: 'c', text: 'C (Average) – 60-69%', value: 'c'),
        Option(id: 'd', text: 'D (Below Average) – 50-59%', value: 'd'),
        Option(id: 'f', text: 'F (Fail) – Below 50%', value: 'f'),
      ],
      category: 'academic',
    ),
    Question(
      id: 'essay_feedback',
      text:
          'How often do you seek feedback on your essays before submitting them?',
      type: QuestionType.singleChoice,
      options: [
        Option(id: 'always', text: 'Always', value: 'always'),
        Option(id: 'often', text: 'Often', value: 'often'),
        Option(id: 'sometimes', text: 'Sometimes', value: 'sometimes'),
        Option(id: 'rarely', text: 'Rarely', value: 'rarely'),
        Option(id: 'never', text: 'Never', value: 'never'),
      ],
      category: 'academic',
    ),
    Question(
      id: 'grammar_check',
      text: 'When writing, do you check your grammar?',
      type: QuestionType.boolean,
      category: 'academic',
    ),
    Question(
      id: 'career_goals',
      text: 'What are your long-term academic and career goals?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'graduate_school',
            text: 'Attend Graduate School',
            value: 'graduate_school'),
        Option(
            id: 'industry_job',
            text: 'Work in Industry',
            value: 'industry_job'),
        Option(
            id: 'entrepreneur',
            text: 'Start Own Business',
            value: 'entrepreneur'),
        Option(id: 'research', text: 'Pursue Research', value: 'research'),
        Option(
            id: 'public_service',
            text: 'Enter Public Service',
            value: 'public_service'),
        Option(id: 'academia', text: 'Career in Academia', value: 'academia'),
        Option(
            id: 'undecided',
            text: 'Undecided/Still exploring',
            value: 'undecided'),
      ],
      category: 'personal',
    ),
  ];

  // Post-assessment questions
  final List<Question> postAssessmentQuestions = [
    // Section 1: Academic Preparedness
    Question(
      id: 'post_gpa',
      text: 'What is your current GPA?',
      type: QuestionType.singleChoice,
      options: [
        Option(id: 'gpa_high', text: '3.0 - 4.0', value: 'gpa_high'),
        Option(id: 'gpa_medium', text: '2.0 - 2.9', value: 'gpa_medium'),
        Option(id: 'gpa_low', text: 'Below 2.0', value: 'gpa_low'),
      ],
      category: 'academic',
    ),
    Question(
      id: 'post_gpa_goals',
      text: 'Do you have clear goals to improve or maintain your GPA?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'goals_clear',
            text: 'Yes, with a specific plan',
            value: 'goals_clear'),
        Option(
            id: 'goals_no_plan',
            text: 'Yes, but no specific plan',
            value: 'goals_no_plan'),
        Option(id: 'goals_none', text: 'No clear goals', value: 'goals_none'),
      ],
      category: 'academic',
    ),
    Question(
      id: 'post_study_tools',
      text: 'How often do you use study tools from the coaching program?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'tools_weekly', text: 'Weekly or more', value: 'tools_weekly'),
        Option(
            id: 'tools_occasionally',
            text: 'Occasionally',
            value: 'tools_occasionally'),
        Option(
            id: 'tools_never', text: 'Never used them', value: 'tools_never'),
      ],
      category: 'academic',
    ),

    // Section 2: Extracurriculars & Leadership
    Question(
      id: 'post_leadership_role',
      text:
          'Have you taken on any leadership roles since the initial assessment?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'leader_yes',
            text: 'Yes, I lead a group/activity',
            value: 'leader_yes'),
        Option(
            id: 'leader_member',
            text: 'Member but not leader',
            value: 'leader_member'),
        Option(
            id: 'leader_none',
            text: 'Not involved in any groups',
            value: 'leader_none'),
      ],
      category: 'leadership',
    ),
    Question(
      id: 'post_competitions',
      text: 'Have you participated in any academic competitions or events?',
      type: QuestionType.singleChoice,
      options: [
        Option(id: 'comp_won', text: 'Yes, won or placed', value: 'comp_won'),
        Option(
            id: 'comp_no_win',
            text: 'Yes, but did not place',
            value: 'comp_no_win'),
        Option(
            id: 'comp_none', text: 'Have not participated', value: 'comp_none'),
      ],
      category: 'extracurricular',
    ),

    // Section 3: Volunteering
    Question(
      id: 'post_volunteer_hours',
      text:
          'How many volunteer hours have you completed in the past three months?',
      type: QuestionType.singleChoice,
      options: [
        Option(id: 'vol_many', text: '20+ hours', value: 'vol_many'),
        Option(id: 'vol_medium', text: '5-19 hours', value: 'vol_medium'),
        Option(id: 'vol_few', text: '1-4 hours', value: 'vol_few'),
        Option(id: 'vol_none', text: 'None', value: 'vol_none'),
      ],
      category: 'community_service',
    ),
    Question(
      id: 'post_volunteer_aligned',
      text:
          'Are your volunteer activities aligned with your academic field or career interests?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'vol_aligned_yes',
            text: 'Strongly aligned',
            value: 'vol_aligned_yes'),
        Option(
            id: 'vol_aligned_somewhat',
            text: 'Somewhat aligned',
            value: 'vol_aligned_somewhat'),
        Option(
            id: 'vol_aligned_no',
            text: 'Not aligned at all',
            value: 'vol_aligned_no'),
      ],
      category: 'community_service',
    ),

    // Section 4: Application Strategy
    Question(
      id: 'post_resume_ready',
      text: 'How would you describe the current state of your resume?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'resume_polished',
            text: 'Polished and ready to send',
            value: 'resume_polished'),
        Option(
            id: 'resume_draft',
            text: 'Draft in progress',
            value: 'resume_draft'),
        Option(
            id: 'resume_none', text: 'Have not started', value: 'resume_none'),
      ],
      category: 'strategy',
    ),
    Question(
      id: 'post_scholarship_search',
      text: 'How would you describe your approach to finding scholarships?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'search_targeted',
            text: 'Targeted to specific scholarships',
            value: 'search_targeted'),
        Option(
            id: 'search_broad',
            text: 'Broad search without focus',
            value: 'search_broad'),
        Option(
            id: 'search_none',
            text: 'Not actively searching',
            value: 'search_none'),
      ],
      category: 'strategy',
    ),
    Question(
      id: 'post_mock_interviews',
      text:
          'Have you completed any mock interviews to prepare for scholarship applications?',
      type: QuestionType.singleChoice,
      options: [
        Option(
            id: 'interview_yes',
            text: 'Yes, completed mock interviews',
            value: 'interview_yes'),
        Option(
            id: 'interview_planned',
            text: 'No, but have plans to do so',
            value: 'interview_planned'),
        Option(
            id: 'interview_no',
            text: 'No plans for mock interviews',
            value: 'interview_no'),
      ],
      category: 'strategy',
    ),
    Question(
      id: 'post_documents_ready',
      text: 'Which of the following application documents do you have ready?',
      type: QuestionType.multipleChoice,
      options: [
        Option(
            id: 'doc_essays',
            text: 'Essays/Personal Statements',
            value: 'doc_essays'),
        Option(
            id: 'doc_recommendations',
            text: 'Letters of Recommendation',
            value: 'doc_recommendations'),
        Option(
            id: 'doc_transcript',
            text: 'Academic Transcript',
            value: 'doc_transcript'),
        Option(id: 'doc_resume', text: 'Resume/CV', value: 'doc_resume'),
        Option(id: 'doc_none', text: 'None of the above', value: 'doc_none'),
      ],
      category: 'strategy',
    ),
  ];

  Question? findQuestionById(String id, {bool isPostAssessment = false}) {
    // Search in the appropriate question list based on assessment type
    try {
      if (isPostAssessment) {
        return postAssessmentQuestions.firstWhere((q) => q.id == id);
      } else {
        return preAssessmentQuestions.firstWhere((q) => q.id == id);
      }
    } catch (e) {
      return null;
    }
  }
}
