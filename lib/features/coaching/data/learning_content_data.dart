import '../models/learning_module.dart';
import '../models/question.dart';

class LearningContentData {
  // Content based on the provided guide materials
  final List<LearningModule> learningModules = [
    // Academic Performance Module
    LearningModule(
      id: 'module_academic_improvement',
      title: 'Boost Your Academic Performance',
      description: 'Strategies to improve your GPA and academic standing.',
      category: 'academic',
      difficulty: 3,
      contents: [
        LearningContent(
          id: 'academic_intro',
          title: 'The Importance of GPA for Scholarships',
          type: ContentType.text,
          content: '''
# The Importance of GPA for Scholarships

Donors tend to prioritize high-achieving students when awarding scholarships. Your GPA is often the first criterion considered in the selection process.

## Why GPA Matters

* A strong GPA demonstrates your academic abilities and work ethic
* Many scholarships have minimum GPA requirements (typically 3.0 or higher)
* Higher GPAs qualify you for more scholarship opportunities
* Top scholarships often require GPAs of 3.5 or higher

## Your Goal

**Maintain or improve your GPA to at least 3.0, ideally 3.5+ for top scholarships.**

In the following sections, we'll explore effective strategies to help you achieve this goal.
''',
          ordinalPosition: 1,
          tags: ['gpa', 'academic', 'introduction'],
        ),
        LearningContent(
          id: 'academic_strategies',
          title: 'Effective Study Strategies',
          type: ContentType.text,
          content: '''
# Effective Study Strategies

Developing strong study habits is essential for improving your GPA. Here are proven strategies to enhance your academic performance:

## Create a Study Schedule

* Allocate specific times each day for studying
* Break study sessions into 25-50 minute blocks with short breaks (Pomodoro Technique)
* Prioritize difficult subjects during your peak productivity hours
* Include review sessions to reinforce previously learned material

## Optimize Your Learning Environment

* Find a quiet, well-lit space with minimal distractions
* Ensure you have all necessary materials before starting
* Consider using noise-canceling headphones if needed
* Experiment with different study locations to find what works best for you

## Utilize Academic Resources

* Attend professors' consultation hours for personalized guidance
* Join or form study groups with motivated classmates
* Use your university's tutoring services for challenging subjects
* Explore online resources like Khan Academy, Coursera, or subject-specific websites

## Develop Active Learning Techniques

* Take detailed notes during lectures and review within 24 hours
* Create summary sheets, flashcards, or mind maps to organize information
* Teach concepts to others to deepen your understanding
* Practice with past exams and sample problems

## Implement Effective Time Management

* Use a planner or digital calendar to track assignments and deadlines
* Break large projects into smaller, manageable tasks
* Set specific, achievable goals for each study session
* Eliminate or reduce time spent on distractions like social media

**Competitive Advantage:** While many students aim for a 3.0 GPA, pushing yourself to achieve a 3.7+ GPA will significantly increase your scholarship opportunities.
''',
          ordinalPosition: 2,
          tags: ['study strategies', 'academic improvement', 'time management'],
        ),
        LearningContent(
          id: 'academic_resources',
          title: 'Campus Academic Resources',
          type: ContentType.text,
          content: '''
# Campus Academic Resources at UTech

UTech offers numerous resources to help you succeed academically. Take advantage of these services to boost your GPA and academic standing.

## Learning Resource Centers

* **The Main Library**: Contains textbooks, reference materials, and quiet study spaces
* **Computer Labs**: Access to computers, software, and printing services
* **Subject-Specific Labs**: Specialized resources for science, engineering, and other disciplines

## Academic Support Services

* **Tutoring Center**: Free peer and professional tutoring in various subjects
* **Writing Center**: Help with essays, research papers, and other written assignments
* **Math Lab**: Assistance with mathematics courses at all levels
* **Academic Advising**: Guidance on course selection and academic planning

## Professor Office Hours

* Each professor has dedicated office hours to help students
* This is an underutilized resource that can significantly improve your understanding
* Prepare specific questions before attending
* Build relationships with professors who can later write recommendation letters

## Study Groups and Peer Learning

* Join existing study groups or form your own
* Schedule regular meetings in campus study spaces
* Share notes, explain concepts to each other, and prepare for exams together
* Teaching others reinforces your own understanding

## Online UTech Resources

* Access to the university's learning management system
* Online databases and journal subscriptions
* Recorded lectures and supplementary materials
* Practice exams and self-assessment tools

**Action Item**: Identify at least two campus resources you will use this semester and create a plan to incorporate them into your study routine.
''',
          ordinalPosition: 3,
          tags: ['campus resources', 'academic support', 'tutoring'],
        ),
        LearningContent(
          id: 'academic_gpa_calculator',
          title: 'GPA Calculator and Improvement Plan',
          type: ContentType.text,
          content: '''
# GPA Calculator and Improvement Plan

Understanding how your GPA is calculated can help you strategically improve it.

## How GPA is Calculated at UTech

1. Each letter grade corresponds to a grade point (A = 4.0, B = 3.0, etc.)
2. Multiply the grade point by the credit hours for each course
3. Add these values together
4. Divide by the total number of credit hours

## Using a GPA Calculator

Online GPA calculators can help you:
* Calculate your current GPA
* Determine what grades you need to achieve your target GPA
* Simulate how different grades will affect your overall GPA

**Recommended Tool**: UTech's online GPA calculator (available through the student portal)

## Strategic GPA Improvement

### If Your GPA is Below 3.0:

* Focus on bringing up grades in courses where you're close to the next letter grade
* Consider retaking courses with poor grades (check UTech's grade replacement policy)
* Take a lighter course load if possible to focus on quality over quantity
* Seek tutoring for challenging subjects immediately, don't wait until you're struggling

### If Your GPA is 3.0-3.5:

* Target specific courses where you can move from a B to an A
* Balance challenging courses with those where you're likely to excel
* Develop deeper relationships with professors in your major
* Join honors programs or specialized academic groups if available

### If Your GPA is Above 3.5:

* Maintain your excellent performance while challenging yourself
* Consider honors or advanced courses to demonstrate academic rigor
* Focus on developing expertise in your field through research or projects
* Document your academic achievements for scholarship applications

**Action Plan**: Calculate your current GPA, set a target GPA for the semester, and identify specific actions needed to achieve it.
''',
          ordinalPosition: 4,
          tags: ['gpa calculator', 'academic planning', 'grade improvement'],
        ),
        LearningContent(
          id: 'academic_quiz',
          title: 'Academic Success Quiz',
          type: ContentType.quiz,
          content: '''
{
  "questions": [
    {
      "question": "What minimum GPA do most scholarships require?",
      "options": ["2.0", "2.5", "3.0", "3.5"],
      "correctAnswer": "3.0",
      "explanation": "Most scholarships require at least a 3.0 GPA, with more competitive scholarships requiring 3.5 or higher."
    },
    {
      "question": "Which study technique involves breaking work into intervals with short breaks?",
      "options": ["Spaced repetition", "Pomodoro Technique", "Mind mapping", "Active recall"],
      "correctAnswer": "Pomodoro Technique",
      "explanation": "The Pomodoro Technique involves 25-minute focused work periods followed by 5-minute breaks."
    },
    {
      "question": "What is the most effective way to improve understanding of difficult material?",
      "options": ["Reading the textbook repeatedly", "Highlighting important passages", "Teaching the concept to someone else", "Making detailed notes"],
      "correctAnswer": "Teaching the concept to someone else",
      "explanation": "Explaining concepts to others requires deep understanding and helps solidify knowledge."
    },
    {
      "question": "Which UTech resource is best for getting help with writing assignments?",
      "options": ["Math Lab", "Computer Lab", "Writing Center", "Professor Office Hours"],
      "correctAnswer": "Writing Center",
      "explanation": "The Writing Center specializes in providing assistance with essays, research papers, and other written assignments."
    },
    {
      "question": "If your current GPA is 2.7, which strategy would most quickly improve it?",
      "options": ["Taking more courses", "Joining more clubs", "Retaking courses with poor grades", "Changing your major"],
      "correctAnswer": "Retaking courses with poor grades",
      "explanation": "Many universities allow grade replacement when retaking courses, which can significantly impact your GPA."
    }
  ]
}
''',
          ordinalPosition: 5,
          tags: ['quiz', 'academic success', 'assessment'],
        ),
      ],
      assessmentQuestions: [
        Question(
          id: 'academic_goals',
          text: 'What academic goals do you want to achieve?',
          type: QuestionType.text,
          category: 'academic',
        ),
        Question(
          id: 'study_habits',
          text: 'How would you rate your current study habits?',
          type: QuestionType.singleChoice,
          options: [
            Option(id: 'excellent', text: 'Excellent', value: 'excellent'),
            Option(id: 'good', text: 'Good', value: 'good'),
            Option(id: 'average', text: 'Average', value: 'average'),
            Option(id: 'poor', text: 'Poor', value: 'poor'),
            Option(id: 'very_poor', text: 'Very Poor', value: 'very_poor'),
          ],
          category: 'academic',
        ),
      ],
    ),

    // Leadership Module
    LearningModule(
      id: 'module_leadership_development',
      title: 'Developing Leadership Skills',
      description:
          'Strategies to enhance your leadership abilities for scholarship applications.',
      category: 'leadership',
      difficulty: 3,
      contents: [
        LearningContent(
          id: 'leadership_intro',
          title: 'The Importance of Leadership for Scholarships',
          type: ContentType.text,
          content: '''
# The Importance of Leadership for Scholarships

Scholarship committees value leadership skills highly, often considering them equally important as academic achievement.

## Why Leadership Matters

* Demonstrates initiative and proactive mindset
* Shows ability to influence and work with others
* Indicates potential for future success and impact
* Sets you apart from other academically strong candidates
* Provides concrete examples for scholarship essays and interviews

## Types of Leadership Valued by Scholarship Committees

* **Formal Leadership Roles**: Club president, team captain, student government
* **Project Leadership**: Leading initiatives, organizing events
* **Thought Leadership**: Presenting ideas, research, or creative work
* **Community Leadership**: Organizing community service, advocacy
* **Peer Leadership**: Mentoring, tutoring, residence hall advisors

## Your Goal

Develop substantial leadership experience that demonstrates your ability to:
* Take initiative
* Organize and execute projects
* Inspire and collaborate with others
* Create positive change

In the upcoming sections, we'll explore how to identify and develop meaningful leadership opportunities that align with your interests and goals.
''',
          ordinalPosition: 1,
          tags: ['leadership', 'scholarships', 'introduction'],
        ),
        LearningContent(
          id: 'leadership_opportunities',
          title: 'Finding Leadership Opportunities',
          type: ContentType.text,
          content: '''
# Finding Leadership Opportunities at UTech

There are numerous ways to develop leadership skills on campus. The key is finding opportunities that align with your interests and career goals.

## Campus Organizations

* **Student Government Association (SGA)**: Run for elected positions or join committees
* **Academic Clubs**: Subject-specific organizations related to your major
* **Cultural and Social Clubs**: Organizations centered around shared interests or backgrounds
* **Honor Societies**: Academic recognition groups that often have leadership positions
* **Sports Teams**: Formal leadership roles like team captain or informal leadership

## Creating Your Own Initiatives

* **Start a New Club**: Identify an unmet need on campus and create an organization
* **Organize Campus Events**: Plan workshops, speaker series, or awareness campaigns
* **Propose a Service Project**: Develop community service initiatives
* **Launch a Student Publication**: Create a blog, newsletter, or magazine
* **Develop a Peer Support Program**: Mentoring, tutoring, or wellness initiatives

## Academic Leadership

* **Research Assistant-ships**: Work with professors on research projects
* **Teaching Assistantships**: Help instruct or guide fellow students
* **Study Group Leaders**: Organize and lead study sessions
* **Class Projects**: Take the lead on group assignments
* **Academic Competitions**: Organize teams for hackathons, debates, etc.

## Community Leadership

* **Local Non-profits**: Volunteer for leadership roles in community organizations
* **Religious Groups**: Lead youth programs or service initiatives
* **Political Campaigns**: Organize campus outreach or voter registration
* **Community Centers**: Develop or lead programs for local residents
* **Advocacy Groups**: Coordinate awareness campaigns or fundraising

**Action Item**: Identify at least three leadership opportunities that interest you and align with your skills and goals.
''',
          ordinalPosition: 2,
          tags: [
            'leadership opportunities',
            'campus involvement',
            'student organizations'
          ],
        ),
        LearningContent(
          id: 'leadership_skills',
          title: 'Developing Essential Leadership Skills',
          type: ContentType.text,
          content: '''
# Developing Essential Leadership Skills

Effective leadership requires specific skills that can be learned and practiced.

## Communication Skills

* **Public Speaking**: Join Toastmasters or take a speech class
* **Active Listening**: Practice focusing fully on others when they speak
* **Written Communication**: Develop clear, concise writing for emails and documents
* **Presentation Skills**: Learn to create and deliver compelling presentations
* **Conflict Resolution**: Practice addressing disagreements constructively

## Organizational Skills

* **Goal Setting**: Learn to establish clear, achievable objectives
* **Planning**: Break projects into manageable steps with timelines
* **Delegation**: Assign tasks based on team members' strengths
* **Time Management**: Use calendars and productivity systems effectively
* **Project Management**: Learn basic techniques for coordinating complex initiatives

## People Skills

* **Motivation**: Discover how to inspire others toward shared goals
* **Team Building**: Create cohesion among diverse group members
* **Feedback**: Provide constructive criticism and positive reinforcement
* **Emotional Intelligence**: Recognize and respond to others' feelings
* **Inclusivity**: Ensure all team members feel valued and heard

## Strategic Thinking

* **Problem Solving**: Develop systematic approaches to challenges
* **Decision Making**: Learn frameworks for making good choices
* **Critical Thinking**: Question assumptions and evaluate evidence
* **Vision**: Create compelling future directions for your group
* **Adaptability**: Respond effectively to changing circumstances

## Resources for Skill Development

* **Campus Workshops**: Attend leadership training offered by student affairs
* **Online Courses**: Platforms like Coursera and LinkedIn Learning offer leadership courses
* **Books**: Read recognized leadership texts (library resources available)
* **Mentorship**: Seek guidance from experienced leaders
* **Reflection**: Regularly evaluate your leadership experiences and lessons learned

**Competitive Advantage**: Many students hold leadership positions but don't actively work on developing specific leadership skills. By intentionally building these capabilities, you'll stand out in scholarship applications.
''',
          ordinalPosition: 3,
          tags: [
            'leadership skills',
            'communication',
            'organization',
            'people skills'
          ],
        ),
        LearningContent(
          id: 'leadership_documentation',
          title: 'Documenting Your Leadership Journey',
          type: ContentType.text,
          content: '''
# Documenting Your Leadership Journey

Effectively showcasing your leadership experience is crucial for scholarship applications.

## Leadership Portfolio

Create a comprehensive record of your leadership experiences:

* **Position Details**: Organization name, your role, dates of service
* **Responsibilities**: Specific duties and tasks you performed
* **Projects**: Initiatives you led or contributed to significantly
* **Achievements**: Measurable outcomes and successes
* **Challenges**: Problems you faced and how you overcame them
* **Skills Developed**: Specific capabilities you gained or enhanced
* **Impact**: How your leadership made a difference

## Evidence Collection

Gather tangible proof of your leadership activities:

* **Photographs**: Visual documentation of events or projects
* **Meeting Minutes**: Records of discussions and decisions
* **Event Programs**: Official materials showing your involvement
* **Media Coverage**: News articles or social media mentions
* **Testimonials**: Statements from team members or advisors
* **Awards/Certificates**: Recognition for your leadership
* **Project Materials**: Plans, reports, or presentations you created

## Reflection Practice

Regularly reflect on your leadership experiences:

* What were your goals and did you achieve them?
* What worked well and what would you do differently?
* What surprised you about the leadership experience?
* How did you grow personally and professionally?
* What impact did your leadership have on others?

## Application Translation

Learn to articulate your leadership experiences effectively:

* **Quantify Impact**: Use numbers to show reach and results
* **Highlight Transferable Skills**: Connect your experiences to scholarship criteria
* **Tell Stories**: Create compelling narratives about challenges and successes
* **Show Growth**: Demonstrate how you've developed as a leader
* **Connect to Values**: Link your leadership to personal and community values

**Action Item**: Start a leadership journal or digital folder to regularly document your experiences, challenges, and growth.
''',
          ordinalPosition: 4,
          tags: ['leadership documentation', 'portfolio', 'reflection'],
        ),
        LearningContent(
          id: 'leadership_exercise',
          title: 'Leadership Development Exercise',
          type: ContentType.exercise,
          content: '''
# Leadership Development Exercise: Creating Your Leadership Plan

## Instructions

This exercise will help you develop a strategic plan for building your leadership profile for scholarship applications.

### Part 1: Self-Assessment

1. List 3-5 of your greatest strengths that could contribute to leadership:
   
   Example: "Strong written communication, attention to detail, passion for environmental issues"

2. List 3-5 areas where you need to grow as a leader:
   
   Example: "Public speaking confidence, delegation skills, strategic planning"

3. Identify your personal leadership style by reflecting on how you naturally interact in groups:
   
   Example: "I tend to be a collaborative leader who values input from all team members"

### Part 2: Opportunity Mapping

1. List all campus organizations related to your major or career interests:
   
   Example: "Computer Science Club, Women in STEM, Robotics Team"

2. List all campus organizations related to your personal interests or hobbies:
   
   Example: "Environmental Club, Photography Society, Volleyball Team"

3. Identify any gaps on campus where a new initiative could be valuable:
   
   Example: "There's no peer mentoring program for first-generation students"

### Part 3: Strategic Planning

1. Short-term Leadership Goals (Next 3-6 months):
   * Select 1-2 specific leadership positions or projects to pursue
   * Identify specific steps needed to secure these opportunities
   * List 2-3 skills you will focus on developing

2. Medium-term Leadership Goals (Next 6-12 months):
   * Identify how you'll expand your initial leadership roles
   * Plan for measuring and documenting your impact
   * List additional leadership skills to develop

3. Long-term Leadership Vision (1-2 years):
   * Describe your ideal leadership profile by graduation
   * Identify any "stretch" leadership positions you aspire to
   * Plan how all experiences will connect to tell a cohesive leadership story

### Part 4: Scholarship Alignment

1. Research 3-5 scholarships you plan to apply for and note their leadership criteria
2. Identify how your leadership plan aligns with these scholarship requirements
3. Note any adjustments needed to better align your leadership development with scholarship opportunities

## Submission

Keep this completed exercise as a personal roadmap, and revisit it quarterly to track your progress and make adjustments as needed.
''',
          ordinalPosition: 5,
          tags: ['leadership plan', 'exercise', 'self-assessment'],
        ),
      ],
      assessmentQuestions: [
        Question(
          id: 'leadership_experience',
          text: 'Do you have any leadership experience?',
          type: QuestionType.boolean,
          category: 'leadership',
        ),
        Question(
          id: 'leadership_interests',
          text: 'What leadership skills are you most interested in developing?',
          type: QuestionType.multipleChoice,
          options: [
            Option(
                id: 'communication',
                text: 'Communication',
                value: 'communication'),
            Option(
                id: 'organization',
                text: 'Organization',
                value: 'organization'),
            Option(id: 'delegation', text: 'Delegation', value: 'delegation'),
            Option(
                id: 'conflict_resolution',
                text: 'Conflict Resolution',
                value: 'conflict_resolution'),
            Option(
                id: 'strategic_thinking',
                text: 'Strategic Thinking',
                value: 'strategic_thinking'),
          ],
          category: 'leadership',
        ),
      ],
    ),

    // Essay Writing Module
    LearningModule(
      id: 'module_essay_writing',
      title: 'Mastering Scholarship Essays',
      description:
          'Learn to write compelling scholarship essays that stand out.',
      category: 'academic',
      difficulty: 4,
      contents: [
        LearningContent(
          id: 'essay_intro',
          title: 'The Power of Scholarship Essays',
          type: ContentType.text,
          content: '''
# The Power of Scholarship Essays

Scholarship essays are often the deciding factor between equally qualified candidates. A well-crafted essay can make you stand out from the competition.

## Why Essays Matter

* **Personal Connection**: Essays humanize your application beyond numbers and achievements
* **Demonstration of Skills**: Shows your ability to communicate effectively in writing
* **Character Insight**: Reveals your values, motivations, and personality
* **Future Potential**: Indicates how you might use the scholarship opportunity
* **Unique Perspective**: Highlights what makes you different from other applicants

## Common Essay Prompts

Scholarship essays typically fall into these categories:

* **Personal Background**: Describing your life experiences and challenges
* **Academic/Career Goals**: Outlining your educational and professional plans
* **Why You Deserve This**: Explaining what makes you scholarship-worthy
* **Leadership/Service**: Detailing your contributions to others
* **Specific Field Interest**: Discussing your passion for your area of study
* **Response to a Quote/Prompt**: Answering a specific philosophical question

## Your Essay Goals

An effective scholarship essay should:
* Engage the reader from the first sentence
* Tell a compelling and authentic story
* Demonstrate how you meet the scholarship criteria
* Showcase your writing abilities
* Leave a memorable impression

In the following sections, we'll explore how to craft essays that accomplish these goals and significantly increase your chances of winning scholarships.
''',
          ordinalPosition: 1,
          tags: ['essay writing', 'scholarships', 'introduction'],
        ),
        LearningContent(
          id: 'essay_structure',
          title: 'Crafting a Powerful Scholarship Essay',
          type: ContentType.text,
          content: '''
# Crafting a Powerful Scholarship Essay

A well-structured essay is essential for effectively communicating your message to scholarship committees.

## The Ideal Essay Structure

### Introduction (10-15% of word count)

* **Hook**: Start with an attention-grabbing opening (anecdote, question, surprising fact)
* **Context**: Briefly introduce the topic and its significance to you
* **Thesis**: Present your main point or argument clearly
* **Roadmap**: Give a brief preview of what you'll discuss (for longer essays)

### Body Paragraphs (70-80% of word count)

* **Topic Sentences**: Begin each paragraph with a clear main idea
* **Supporting Evidence**: Include specific examples, experiences, and achievements
* **Analysis**: Explain why these experiences matter and what you learned
* **Transitions**: Connect paragraphs smoothly to maintain flow

### Conclusion (10-15% of word count)

* **Restate Thesis**: Remind readers of your main point (in fresh language)
* **Summarize Key Points**: Briefly recap your strongest arguments
* **Broader Significance**: Connect your essay to larger goals or values
* **Memorable Ending**: Leave readers with a final thought that resonates

## Essay Examples

### Weak Introduction:
"I am writing to apply for the XYZ Scholarship. I believe I deserve this scholarship because I am a hard worker and have good grades."

### Strong Introduction:
"The fluorescent lights flickered as I hunched over my chemistry textbook at 2 AM, determined to understand the concept that had eluded me all day. This moment—choosing to persist when giving up seemed easier—defines my approach to education and represents why the XYZ Scholarship would be transformative for my academic journey."

## Writing Process

1. **Brainstorming**: Generate ideas before starting to write
2. **Outlining**: Create a roadmap for your essay
3. **Drafting**: Write without worrying about perfection
4. **Revising**: Refine content, structure, and arguments
5. **Editing**: Polish language, grammar, and style
6. **Proofreading**: Eliminate errors and typos

**Competitive Advantage**: Most students write generic essays. Creating a specific, memorable narrative with concrete examples will make your application stand out significantly.
''',
          ordinalPosition: 2,
          tags: ['essay structure', 'writing process', 'examples'],
        ),
        LearningContent(
          id: 'essay_storytelling',
          title: 'The Art of Storytelling in Scholarship Essays',
          type: ContentType.text,
          content: '''
# The Art of Storytelling in Scholarship Essays

Storytelling is a powerful tool for creating memorable scholarship essays that resonate with readers.

## Why Stories Work

* **Engagement**: Stories capture and maintain reader attention
* **Memorability**: Narratives are more memorable than lists of accomplishments
* **Emotional Connection**: Stories create empathy and connection
* **Demonstration**: Stories show rather than tell about your qualities
* **Authenticity**: Personal narratives reveal your genuine voice

## Elements of Effective Stories

### 1. Compelling Characters

* Make yourself the protagonist, but include others who influenced you
* Show real personalities through dialogue and actions
* Present authentic responses to situations

### 2. Specific Setting

* Include sensory details (sights, sounds, feelings)
* Establish when and where events occurred
* Create a sense of place that grounds the story

### 3. Meaningful Conflict

* Describe challenges, obstacles, or difficult choices
* Show what was at stake or why it mattered
* Focus on both external situations and internal struggles

### 4. Transformative Resolution

* Explain how you overcame challenges
* Highlight what you learned or how you changed
* Connect the resolution to your larger goals or values

## Story Types for Scholarship Essays

### 1. Challenge Stories

Narrative about overcoming obstacles:
* Describe a specific difficulty you faced
* Explain the actions you took to address it
* Reflect on what this experience taught you
* Connect to how this prepares you for future challenges

### 2. Growth Stories

Narrative about personal development:
* Identify a starting point or initial perspective
* Describe key experiences that changed your view
* Analyze how and why your thinking evolved
* Connect this growth to your current goals

### 3. Passion Stories

Narrative about discovering your interests:
* Describe the moment or process of discovering your passion
* Explain how you've pursued this interest
* Show what you've accomplished in this area
* Connect to your future plans in this field

### 4. Impact Stories

Narrative about making a difference:
* Identify a problem or need you observed
* Describe your response and actions taken
* Show the tangible results of your efforts
* Reflect on why this work matters to you

**Practical Tips for Storytelling:**
* Start in the middle of the action to hook readers
* Include specific details that bring the story to life
* Focus on a single incident rather than a broad overview
* Use dialogue sparingly but effectively
* Show your thought process and emotional reactions

**Competitive Advantage:** Many students simply list achievements in their essays. Telling compelling stories about meaningful experiences will create a more memorable and persuasive application.
''',
          ordinalPosition: 3,
          tags: ['storytelling', 'narrative techniques', 'essay examples'],
        ),
        LearningContent(
          id: 'essay_editing',
          title: 'Editing and Polishing Your Scholarship Essay',
          type: ContentType.text,
          content: '''
# Editing and Polishing Your Scholarship Essay

The editing process is what transforms a good essay into an excellent one. This critical stage can make the difference between winning and losing a scholarship.

## The Editing Process

### 1. Content Revision (Big Picture)

* **Clarity of Purpose**: Is your main message clear throughout?
* **Relevance**: Does everything connect to the scholarship criteria?
* **Completeness**: Have you addressed all aspects of the prompt?
* **Balance**: Is there an appropriate mix of showing and telling?
* **Authenticity**: Does your voice come through naturally?

### 2. Structural Editing (Organization)

* **Flow**: Do paragraphs connect logically?
* **Proportions**: Is appropriate space given to each part of your story?
* **Transitions**: Are there smooth connections between ideas?
* **Opening**: Does your introduction grab attention?
* **Closing**: Does your conclusion leave a lasting impression?

### 3. Paragraph-Level Editing

* **Topic Sentences**: Does each paragraph begin with a clear main idea?
* **Support**: Are claims backed by specific examples?
* **Development**: Are ideas fully explored?
* **Focus**: Does each paragraph stick to one main point?
* **Length**: Are paragraphs an appropriate length (not too long or short)?

### 4. Sentence-Level Editing

* **Variety**: Mix short and long sentences for rhythm
* **Concision**: Remove unnecessary words and phrases
* **Active Voice**: Replace passive constructions when possible
* **Strong Verbs**: Use specific, vivid action words
* **Transitions**: Ensure smooth flow between sentences

### 5. Word-Level Editing

* **Precision**: Choose exact words that convey your meaning
* **Repetition**: Eliminate unnecessary word repetition
* **Clichés**: Replace overused expressions with fresh language
* **Jargon**: Avoid field-specific terms unfamiliar to general readers
* **Tone**: Ensure word choices match your intended tone

## Proofreading Checklist

✓ Grammar and sentence structure
✓ Spelling and word usage
✓ Punctuation
✓ Formatting and presentation
✓ Word count adherence

## Getting Effective Feedback

* **Multiple Readers**: Seek perspectives from diverse reviewers
* **Specific Questions**: Ask readers to focus on particular aspects
* **Distance**: Allow time between writing and editing
* **Read Aloud**: Hear how your essay sounds when spoken
* **Fresh Eyes**: Consider having someone unfamiliar with your story review it

**Competitive Advantage**: The most successful scholarship applicants revise their essays at least 3-5 times before submission. Thorough editing demonstrates attention to detail and commitment to excellence—qualities scholarship committees value.
''',
          ordinalPosition: 4,
          tags: ['editing', 'revision', 'proofreading', 'feedback'],
        ),
        LearningContent(
          id: 'essay_checklist',
          title: 'Scholarship Essay Final Checklist',
          type: ContentType.checklist,
          content: '''
# Scholarship Essay Final Checklist

Use this comprehensive checklist before submitting any scholarship essay to ensure you've optimized every element.

## Content Checklist

- [ ] Essay directly addresses all aspects of the prompt
- [ ] Clear thesis or main message is evident
- [ ] Personal stories and examples are included
- [ ] Specific achievements are mentioned with context
- [ ] Essay reveals something not found elsewhere in application
- [ ] Content aligns with the scholarship's values and criteria
- [ ] Essay demonstrates why you deserve this specific scholarship
- [ ] Future goals and aspirations are clearly articulated
- [ ] The impact of receiving the scholarship is explained

## Structure Checklist

- [ ] Engaging hook or opening sentence
- [ ] Clear introduction that establishes topic and approach
- [ ] Logical progression of ideas throughout
- [ ] Appropriate transitions between paragraphs
- [ ] Each paragraph focuses on a single main idea
- [ ] Conclusion that reinforces key points without just repeating
- [ ] Memorable final sentence or thought

## Style and Tone Checklist

- [ ] Authentic voice that sounds like you
- [ ] Professional but not overly formal tone
- [ ] Appropriate balance of confidence and humility
- [ ] Active rather than passive voice predominates
- [ ] Varied sentence structure and length
- [ ] Strong, specific verbs instead of generic ones
- [ ] Concrete details rather than vague generalizations
- [ ] No clichés or overused expressions

## Technical Elements Checklist

- [ ] Adheres to word count/character limit
- [ ] Follows formatting requirements (font, spacing, margins)
- [ ] No grammatical errors or typos
- [ ] Correct punctuation throughout
- [ ] Proper capitalization (especially for names and titles)
- [ ] Consistent tense usage
- [ ] No run-on sentences or fragments
- [ ] Appropriate use of contractions for tone

## Final Verification

- [ ] Essay has been reviewed by at least two other people
- [ ] You've read the essay aloud to check flow and errors
- [ ] All feedback has been considered and incorporated as appropriate
- [ ] Essay has been set aside and reviewed with fresh eyes
- [ ] File is saved in the correct format for submission
- [ ] Filename follows any specified conventions
- [ ] You've verified character count if submitting online
- [ ] Essay represents your best work and you're proud of it

**Pro Tip**: Complete this checklist for each scholarship essay. Many successful applicants keep a document tracking which essays have completed each step of the checklist to ensure nothing is overlooked in the application process.
''',
          ordinalPosition: 5,
          tags: ['checklist', 'submission preparation', 'final review'],
        ),
      ],
      assessmentQuestions: [
        Question(
          id: 'writing_confidence',
          text: 'How confident do you feel about your essay writing abilities?',
          type: QuestionType.singleChoice,
          options: [
            Option(
                id: 'very_confident',
                text: 'Very confident',
                value: 'very_confident'),
            Option(id: 'confident', text: 'Confident', value: 'confident'),
            Option(id: 'neutral', text: 'Neutral', value: 'neutral'),
            Option(
                id: 'not_confident',
                text: 'Not confident',
                value: 'not_confident'),
            Option(
                id: 'very_not_confident',
                text: 'Not at all confident',
                value: 'very_not_confident'),
          ],
          category: 'academic',
        ),
        Question(
          id: 'essay_support',
          text: 'Who currently helps you review your essays?',
          type: QuestionType.multipleChoice,
          options: [
            Option(
                id: 'professors',
                text: 'Professors/Teachers',
                value: 'professors'),
            Option(
                id: 'writing_center',
                text: 'Writing Center Staff',
                value: 'writing_center'),
            Option(id: 'family', text: 'Family Members', value: 'family'),
            Option(id: 'peers', text: 'Peers/Classmates', value: 'peers'),
            Option(
                id: 'nobody', text: 'I don\'t get feedback', value: 'nobody'),
          ],
          category: 'academic',
        ),
      ],
    ),

    // Community Service Module
    LearningModule(
      id: 'module_community_service',
      title: 'Maximizing Community Service Impact',
      description:
          'Learn how to make your volunteer work more meaningful for both communities and scholarship applications.',
      category: 'community_service',
      difficulty: 2,
      contents: [
        LearningContent(
          id: 'community_intro',
          title: 'The Value of Community Service for Scholarships',
          type: ContentType.text,
          content: '''
# The Value of Community Service for Scholarships

Community service is a key component of many scholarship applications, demonstrating your commitment to making a positive impact beyond academics.

## Why Community Service Matters

* **Character Demonstration**: Shows compassion, initiative, and social responsibility
* **Skill Development**: Builds teamwork, leadership, and problem-solving abilities
* **Experience Diversification**: Provides real-world exposure outside the classroom
* **Community Impact**: Creates tangible benefits for others
* **Long-term Commitment**: Demonstrates persistence and dedication

## Types of Service Valued by Scholarship Committees

* **Local Community Projects**: Working directly in your neighborhood or city
* **Campus Initiatives**: Volunteering for university-based service programs
* **Global Engagement**: Participating in international service (when possible)
* **Issue-Based Advocacy**: Supporting specific causes or social issues
* **Professional Service**: Using your academic skills to help others

## Quality vs. Quantity

Scholarship committees increasingly value:
* **Depth over breadth**: Sustained involvement with fewer organizations
* **Measurable impact**: Concrete results rather than just hours served
* **Personal connection**: Authentic passion for the cause
* **Leadership roles**: Taking initiative within service opportunities
* **Reflection**: Thoughtful consideration of what you've learned

In the following sections, we'll explore how to find, optimize, and document community service experiences that will strengthen your scholarship applications while making a meaningful difference.
''',
          ordinalPosition: 1,
          tags: ['community service', 'volunteering', 'scholarship criteria'],
        ),
        LearningContent(
          id: 'community_opportunities',
          title: 'Finding Meaningful Service Opportunities',
          type: ContentType.text,
          content: '''
# Finding Meaningful Service Opportunities

The most effective community service combines your genuine interests with significant community needs.

## Identifying Your Service Interests

Consider volunteering in areas that connect to:
* **Academic Major**: Using skills related to your field of study
* **Personal Passions**: Causes you genuinely care about
* **Career Goals**: Experience relevant to your professional future
* **Unique Skills**: Special talents or abilities you can contribute
* **Family History**: Issues that have affected you or loved ones

## Campus-Based Opportunities

* **Service Learning Courses**: Classes that integrate community service
* **Alternative Breaks**: Service trips during school holidays
* **Campus Volunteer Center**: Centralized resource for opportunities
* **Student Organizations**: Clubs with service components
* **Residence Life**: Service projects for dormitory residents

## Community-Based Opportunities

* **Local Non-profits**: Organizations addressing community needs
* **Schools**: Tutoring, mentoring, or classroom assistance
* **Hospitals**: Patient support or administrative help
* **Government Agencies**: Public service departments
* **Religious Institutions**: Outreach and assistance programs

## Virtual Service Opportunities

* **Remote Tutoring**: Academic support for students
* **Digital Skills Sharing**: Technology assistance for organizations
* **Translation Services**: Language help for documents or websites
* **Content Creation**: Writing, design, or social media support
* **Research Assistance**: Data collection or analysis for non-profits

## Creating Your Own Service Project

If existing opportunities don't match your interests:
* Identify an unaddressed community need
* Research similar initiatives for models
* Develop a simple, achievable plan
* Recruit fellow students or community members
* Seek faculty or staff mentorship
* Start small and build gradually

**Action Item**: Identify 3-5 service opportunities that align with your interests and values, then research their specific volunteer requirements.
''',
          ordinalPosition: 2,
          tags: [
            'volunteer opportunities',
            'service projects',
            'finding service'
          ],
        ),
        LearningContent(
          id: 'community_impact',
          title: 'Maximizing Your Service Impact',
          type: ContentType.text,
          content: '''
# Maximizing Your Service Impact

Creating meaningful impact through service requires intentional planning and engagement.

## Setting Clear Service Goals

Before beginning any volunteer work, establish:
* **Learning Objectives**: Skills or knowledge you hope to gain
* **Contribution Targets**: Specific ways you'll help the organization
* **Time Commitment**: Realistic hours you can dedicate
* **Impact Measures**: How you'll know your service made a difference
* **Documentation Plan**: How you'll record your experience and impact

## Building Effective Service Relationships

* **Listen First**: Understand community needs before proposing solutions
* **Respect Expertise**: Value the knowledge of those you're serving
* **Maintain Consistency**: Honor your commitments reliably
* **Communicate Clearly**: Express needs, questions, and limitations
* **Practice Cultural Humility**: Be open to learning from different perspectives

## Moving Beyond Basic Volunteering

To create deeper impact:
* **Increase Responsibility**: Take on more challenging roles over time
* **Develop Relationships**: Form meaningful connections with those you serve
* **Identify Improvement Opportunities**: Suggest thoughtful enhancements
* **Connect Resources**: Link organizations with helpful people or funding
* **Recruit Others**: Expand impact by involving more volunteers

## Measuring and Documenting Impact

Track both quantitative and qualitative measures:
* **Service Hours**: Time contributed (keep a detailed log)
* **People Served**: Number of individuals impacted
* **Projects Completed**: Tangible outputs of your work
* **Feedback Received**: Comments from supervisors and recipients
* **Observable Changes**: Differences you can see in the community
* **Personal Growth**: Skills and insights you've developed

**Competitive Advantage**: Many students simply accumulate service hours, but scholarship committees prefer applicants who can demonstrate meaningful impact and personal transformation through their service experiences.
''',
          ordinalPosition: 3,
          tags: [
            'service impact',
            'volunteer effectiveness',
            'community engagement'
          ],
        ),
        LearningContent(
          id: 'community_reflection',
          title: 'Reflecting on Service Experiences',
          type: ContentType.text,
          content: '''
# Reflecting on Service Experiences

Thoughtful reflection transforms community service from a resume item into a powerful learning experience and compelling scholarship essay material.

## The Reflection Process

Effective reflection involves:
* **Description**: What happened during your service?
* **Analysis**: Why did it happen this way?
* **Feelings**: How did the experience affect you emotionally?
* **Evaluation**: What went well or could have been improved?
* **Conclusions**: What did you learn about yourself, others, or society?
* **Action Plan**: How will this influence your future choices?

## Reflection Questions for Different Service Stages

### Before Service

* What do I hope to contribute through this service?
* What assumptions or biases might I bring to this experience?
* What challenges do I anticipate and how might I address them?

### During Service

* What surprises or challenges am I encountering?
* How is this experience confirming or challenging my expectations?
* What skills am I developing or strengthening?

### After Service

* How has this experience influenced my understanding of community needs?
* What did I learn about effective service and community engagement?
* How does this connect to my academic studies or career goals?
* What would I do differently in future service experiences?

## Reflection Methods

* **Journaling**: Regular written reflection on your experiences
* **Group Discussion**: Structured conversations with fellow volunteers
* **Creative Expression**: Art, poetry, or multimedia reflections
* **Academic Integration**: Connecting service to course concepts
* **Mentored Reflection**: Guided processing with a supervisor or advisor

## Translating Reflection to Scholarship Applications

Your reflections provide material for:
* **Essay Responses**: Thoughtful answers to application questions
* **Interview Preparation**: Articulate responses about your service
* **Reference Requests**: Details to share with recommendation writers
* **Portfolio Development**: Documentation of your learning and impact

**Action Item**: After each significant service experience, dedicate 15-30 minutes to written reflection using the questions above as prompts.
''',
          ordinalPosition: 4,
          tags: ['reflection', 'service learning', 'critical thinking'],
        ),
        LearningContent(
          id: 'community_activity',
          title: 'Community Service Impact Planning',
          type: ContentType.exercise,
          content: '''
# Community Service Impact Planning Exercise

## Instructions

This exercise will help you develop a strategic plan for community service that maximizes both impact and scholarship potential.

### Part 1: Service Inventory

1. List all your current and past community service experiences including:
   * Organization name
   * Your role
   * Dates of service
   * Approximate hours
   * Key responsibilities

2. For each experience, rate on a scale of 1-5:
   * Your level of passion for the cause
   * The depth of your involvement
   * The impact of your contribution
   * The relevance to your academic/career goals
   * The quality of documentation you maintained

### Part 2: Gap Analysis

1. Review scholarship criteria for your target scholarships and note:
   * Types of service they value
   * Duration expectations
   * Leadership components
   * Documentation requirements

2. Compare your current service profile with scholarship expectations:
   * Where do you meet or exceed requirements?
   * What gaps or weaknesses exist?
   * What additional experiences would strengthen your profile?

### Part 3: Strategic Service Plan

1. Select 1-2 primary service commitments that will:
   * Align with your genuine interests
   * Demonstrate sustained commitment
   * Allow for increasing responsibility
   * Connect to your academic/career goals
   * Address community needs effectively

2. For each selected commitment, develop:
   * Specific impact goals
   * Leadership development opportunities
   * Documentation strategy
   * Reflection plan
   * Connection to scholarship applications

### Part 4: Implementation Timeline

Create a semester-by-semester plan outlining:
* Service hours per week
* Responsibility progression
* Documentation milestones
* Reflection checkpoints
* Connection to application deadlines

## Submission

Keep this completed exercise as a personal roadmap for your service journey, updating it each semester as you gain new experiences and insights.
''',
          ordinalPosition: 5,
          tags: [
            'service planning',
            'impact assessment',
            'strategic volunteering'
          ],
        ),
      ],
      assessmentQuestions: [
        Question(
          id: 'service_experience',
          text: 'Do you have any community service experience?',
          type: QuestionType.boolean,
          category: 'community_service',
        ),
        Question(
          id: 'service_interests',
          text: 'What types of community service are you most interested in?',
          type: QuestionType.multipleChoice,
          options: [
            Option(
                id: 'education',
                text: 'Education/Tutoring',
                value: 'education'),
            Option(
                id: 'environment', text: 'Environmental', value: 'environment'),
            Option(id: 'healthcare', text: 'Healthcare', value: 'healthcare'),
            Option(id: 'elderly', text: 'Elderly Care', value: 'elderly'),
            Option(
                id: 'food_security',
                text: 'Food Security',
                value: 'food_security'),
            Option(id: 'other', text: 'Other', value: 'other'),
          ],
          category: 'community_service',
        ),
      ],
    ),

    // Application Strategy Module
    LearningModule(
      id: 'module_application_strategy',
      title: 'Strategic Scholarship Application Planning',
      description:
          'Develop a systematic approach to identifying, preparing, and submitting scholarship applications.',
      category: 'strategy',
      difficulty: 3,
      contents: [
        LearningContent(
          id: 'strategy_intro',
          title: 'The Strategic Approach to Scholarship Applications',
          type: ContentType.text,
          content: '''
# The Strategic Approach to Scholarship Applications

Applying for scholarships requires more than just completing forms—it demands a strategic approach that maximizes your opportunities and success rate.

## Why Strategy Matters

* **Competition is Intense**: Many qualified students apply for limited funds
* **Time is Limited**: You can't apply for every scholarship available
* **Requirements Vary**: Each scholarship has different criteria and processes
* **Deadlines Overlap**: Applications often cluster around similar timeframes
* **Preparation Takes Time**: Quality applications require significant effort

## Components of an Effective Strategy

* **Targeted Research**: Finding scholarships that match your profile
* **Prioritization**: Focusing on opportunities with the highest potential return
* **Timeline Management**: Planning backward from deadlines
* **Resource Optimization**: Reusing and adapting materials efficiently
* **Continuous Improvement**: Learning from each application experience

## The Four Phases of Strategic Application

1. **Discovery**: Identifying relevant scholarship opportunities
2. **Preparation**: Gathering and creating application materials
3. **Submission**: Completing and submitting polished applications
4. **Follow-up**: Tracking results and responding to outcomes

In the following sections, we'll explore each of these phases in detail, providing you with a comprehensive system for maximizing your scholarship success.
''',
          ordinalPosition: 1,
          tags: [
            'application strategy',
            'scholarship planning',
            'introduction'
          ],
        ),
        LearningContent(
          id: 'strategy_research',
          title: 'Finding and Evaluating Scholarship Opportunities',
          type: ContentType.text,
          content: '''
# Finding and Evaluating Scholarship Opportunities

The foundation of a successful scholarship strategy is identifying opportunities that match your profile and have a reasonable chance of success.

## Scholarship Search Resources

### School-Based Resources
* **Financial Aid Office**: UTech's scholarship database and advisors
* **Department Offices**: Field-specific scholarships in your major
* **Career Services**: Professional organization scholarships
* **International Student Office**: Opportunities for international students
* **Alumni Association**: Alumni-funded scholarships

### External Resources
* **Government Scholarships**: National and local government programs
* **Foundation Databases**: Private organizations offering scholarships
* **Corporate Programs**: Business-sponsored opportunities
* **Community Organizations**: Local groups providing educational support
* **Professional Associations**: Field-specific funding opportunities

### Digital Platforms
* **Scholarship Search Engines**: Websites that aggregate opportunities
* **Social Media Groups**: Communities sharing scholarship information
* **Email Alerts**: Notifications about new opportunities
* **Mobile Apps**: Scholarship discovery and management tools
* **University Websites**: Other institutions with open scholarships

## Evaluating Scholarship Fit

For each potential opportunity, assess:

### Eligibility Alignment
* **Basic Requirements**: Do you meet all stated criteria?
* **Competitive Position**: How well do you match their ideal candidate?
* **Exclusion Factors**: Are there any disqualifying elements?

### Value Assessment
* **Award Amount**: How much is the scholarship worth?
* **Renewal Potential**: Is it one-time or renewable?
* **Additional Benefits**: Are there non-financial advantages?
* **Application Effort**: How complex is the application process?
* **Competition Level**: How many applicants typically apply?

### Strategic Factors
* **Deadline Timing**: Does it fit your application calendar?
* **Material Overlap**: Can you reuse existing application materials?
* **Alignment with Goals**: Does it support your educational path?
* **Long-term Benefits**: Will it enhance your resume or network?

**Action Item**: Create a personal scholarship database with at least 10-15 opportunities that match your profile, recording key details for each.
''',
          ordinalPosition: 2,
          tags: [
            'scholarship search',
            'opportunity evaluation',
            'research strategies'
          ],
        ),
        LearningContent(
          id: 'strategy_organization',
          title: 'Organizing Your Scholarship Application Process',
          type: ContentType.text,
          content: '''
# Organizing Your Scholarship Application Process

Effective organization is crucial for managing multiple applications while maintaining high quality and meeting deadlines.

## Creating Your Scholarship Tracking System

### Essential Components to Track
* **Scholarship Name and Provider**
* **Award Amount and Type** (one-time, renewable, etc.)
* **Eligibility Requirements**
* **Application Deadline** (including time zone)
* **Required Materials** (essays, recommendations, transcripts, etc.)
* **Submission Method** (online portal, email, mail)
* **Contact Information** for questions
* **Application Status** (in progress, submitted, etc.)
* **Follow-up Requirements**
* **Results and Feedback**

### Format Options
* **Digital Spreadsheet**: Comprehensive view with multiple fields
* **Calendar System**: Timeline-focused view of deadlines
* **Project Management App**: Task-oriented approach
* **Dedicated Scholarship App**: Specialized tracking features
* **Physical Planner**: Tangible record for regular review

## Time Management for Applications

### Backward Planning
* Start from each deadline and work backward to create a timeline
* Allocate specific time blocks for different application components
* Build in buffer time for unexpected challenges
* Schedule regular check-ins on your progress

### Task Batching
* Group similar activities across multiple applications
* Complete common requirements in concentrated work sessions
* Use templates and frameworks for efficiency
* Process recommendations and transcripts in batches

### Priority System
* **Tier 1**: Highest value, best fit scholarships
* **Tier 2**: Good matches with reasonable award amounts
* **Tier 3**: Lower priority but still worth pursuing if time permits

## Document Management

### Digital Organization
* Create a logical folder structure for each scholarship
* Use consistent file naming conventions
* Maintain both working and final versions of documents
* Back up all materials in multiple locations

### Essential Documents to Keep Ready
* Official transcripts (digital and physical copies)
* Updated resume/CV in multiple formats
* Standardized test scores
* Financial documents (for need-based scholarships)
* Portfolio of achievements (certificates, awards, publications)

### Essay Collection
* Personal background statement
* Academic and career goals statement
* Financial need statement
* Leadership philosophy and experiences
* Community service impact reflection
* Field-specific passion/interest essay

### Recommendation Resources
* List of potential recommenders with contact information
* Recommendation request template emails
* Summary sheet of your achievements for recommenders
* Sample recommendation letters (when available)
* Tracking system for recommendation requests and receipts

## 4. Continuous Improvement Process

After each application cycle:
* Review successful and unsuccessful applications
* Identify patterns in results
* Collect and incorporate feedback
* Refine strategy for next cycle
* Update all core materials

**Competitive Advantage**: While most students approach each scholarship individually, using a systematic template allows you to scale your efforts efficiently while maintaining high quality.
''',
          ordinalPosition: 3,
          tags: [
            'scholarship organization',
            'application tracking',
            'time management'
          ],
        ),
        LearningContent(
          id: 'strategy_submission',
          title: 'Perfecting Your Application Submissions',
          type: ContentType.text,
          content: '''
# Perfecting Your Application Submissions

The final phase of application preparation and submission often determines success. Attention to detail and professionalism are essential.

## Pre-Submission Checklist

### Content Verification
* **Completeness**: All required components are included
* **Prompts**: Each question is fully and directly answered
* **Word Counts**: All limits are strictly observed
* **Customization**: Content is tailored to this specific scholarship
* **Accuracy**: All facts, dates, and figures are correct

### Technical Requirements
* **File Formats**: Documents are in the required format (PDF, Word, etc.)
* **File Naming**: Files follow any specified naming conventions
* **File Size**: Documents meet any size limitations
* **Compatibility**: Materials are viewable across different systems
* **Technical Tests**: Online submissions work properly

### Professional Presentation
* **Formatting**: Consistent and appropriate throughout
* **Visual Appeal**: Clean, readable layout and design
* **Proofreading**: No spelling, grammar, or punctuation errors
* **Instructions**: All specific directions are followed exactly
* **Branding**: Your personal "brand" is consistently represented

## Submission Best Practices

### Timing Strategy
* Submit at least 24-48 hours before the deadline
* Avoid last-minute rush periods when systems may be overloaded
* Schedule submission for when you're alert and focused
* Allow time to confirm receipt and resolve any issues

### Submission Process
* Read all instructions completely before starting
* Gather all materials before beginning the submission process
* Take screenshots at each confirmation step
* Save copies of all submitted materials
* Print or save submission confirmations

### Follow-Up Actions
* Send professional thank-you notes to recommenders
* Mark your calendar for expected notification dates
* Prepare for possible interviews or additional requirements
* Document the full application for future reference

## When Problems Occur

### Common Issues and Solutions
* **Technical Difficulties**: Contact technical support immediately
* **Missing Materials**: Reach out to the scholarship coordinator
* **Missed Deadlines**: Inquire about exceptions or future opportunities
* **Incomplete Information**: Submit a polite clarification request
* **Changed Circumstances**: Update relevant information promptly

**Pro Tip**: Create a submission routine that you follow for every application. This reduces errors and ensures consistency across all your applications.
''',
          ordinalPosition: 4,
          tags: [
            'application submission',
            'quality control',
            'submission process'
          ],
        ),
        LearningContent(
          id: 'strategy_template',
          title: 'Scholarship Application Planning Template',
          type: ContentType.text,
          content: '''
# Scholarship Application Planning Template

Use this comprehensive template to create your personalized scholarship application strategy.

## 1. Scholarship Inventory Spreadsheet

Create a spreadsheet with the following columns:

| Scholarship | Provider | Amount | Deadline | Requirements | Fit Score | Priority | Status | Notes |
|-------------|----------|--------|----------|--------------|-----------|----------|--------|-------|
| [Name]      | [Org]    | \$XXX  | [Date]   | [List items] | 1-10      | A/B/C    | [Stage]| [Info]|

## 2. Semester Application Timeline

Month by month breakdown of application activities:

### August-September
* Research and identify fall semester scholarships
* Request updated transcripts
* Renew connections with potential recommenders
* Update resume with summer activities

### October-November
* Focus on completing applications due in December-January
* Schedule recommendation requests with at least 3 weeks' notice
* Finalize major essay themes and personal statements
* Plan winter break application work schedule

### December-January
* Complete and submit end-of-year applications
* Research spring scholarship opportunities
* Organize fall semester achievements for resume updates
* Review and update financial information for need-based scholarships

### February-March
* Focus on completing applications due in April-May
* Update academic achievements with fall semester results
* Refine essays based on feedback from previous applications
* Schedule spring recommendation requests

### April-May
* Complete and submit end-of-academic-year applications
* Plan summer research strategy for next cycle
* Document all current year application results
* Update portfolio with spring semester achievements

### June-July
* Research major scholarships for coming academic year
* Begin drafting core essays and personal statements
* Update resume with academic year achievements
* Reconnect with recommenders for the fall cycle

## 3. Application Material Library

Maintain organized files of:

### Core Documents
* Current resume/CV (academic, leadership, service versions)
* Official and unofficial transcripts
* Standardized test scores
* Financial documents (for need-based scholarships)
* Portfolio of achievements (certificates, awards, publications)

### Essay Collection
* Personal background statement
* Academic and career goals statement
* Financial need statement
* Leadership philosophy and experiences
* Community service impact reflection
* Field-specific passion/interest essay

### Recommendation Resources
* List of potential recommenders with contact information
* Recommendation request template emails
* Summary sheet of your achievements for recommenders
* Sample recommendation letters (when available)
* Tracking system for recommendation requests and receipts

## 4. Continuous Improvement Process

After each application cycle:
* Review successful and unsuccessful applications
* Identify patterns in results
* Collect and incorporate feedback
* Refine strategy for next cycle
* Update all core materials

**Competitive Advantage**: While most students approach each scholarship individually, using a systematic template allows you to scale your efforts efficiently while maintaining high quality.
''',
          ordinalPosition: 5,
          tags: [
            'application template',
            'planning tool',
            'organization system'
          ],
        ),
      ],
      assessmentQuestions: [
        Question(
          id: 'tracking_system',
          text: 'Do you have a system for tracking scholarship applications?',
          type: QuestionType.boolean,
          category: 'strategy',
        ),
        Question(
          id: 'applications_planned',
          text:
              'How many scholarship applications do you plan to submit this year?',
          type: QuestionType.number,
          category: 'strategy',
        ),
      ],
    ),

    // Personal Statement Module
    LearningModule(
      id: 'module_personal_statement',
      title: 'Crafting Your Personal Statement',
      description:
          'Learn to write a compelling personal statement that showcases your unique qualities and experiences.',
      category: 'personal',
      difficulty: 3,
      contents: [
        LearningContent(
          id: 'personal_statement_intro',
          title: 'Understanding Personal Statements',
          type: ContentType.text,
          content: '''
# Understanding Personal Statements

A personal statement is your opportunity to tell your story beyond grades and test scores. It's where scholarship committees get to know you as a person.

## Why Personal Statements Matter

* **Differentiation**: Sets you apart from applicants with similar qualifications
* **Personal Connection**: Essays humanize your application beyond numbers and achievements
* **Values Alignment**: Shows how your goals align with the scholarship's mission
* **Character Insight**: Reveals your values, motivations, and personality

## Common Personal Statement Types

* **General Background**: Broad overview of your journey and aspirations
* **Specific Prompt**: Targeted response to a particular question
* **Personal Background**: Describing your life experiences and challenges
* **Goals Statement**: Focusing on your educational and career objectives
* **Why This Scholarship**: Explaining your fit with a specific opportunity

In this module, you'll learn how to craft powerful personal statements that highlight your unique qualities and experiences in ways that resonate with scholarship committees.
''',
          ordinalPosition: 1,
          tags: ['personal statement', 'introduction', 'scholarship essays'],
        ),
        LearningContent(
          id: 'personal_statement_elements',
          title: 'Key Elements of Effective Personal Statements',
          type: ContentType.text,
          content: '''
# Key Elements of Effective Personal Statements

Powerful personal statements share common characteristics that make them compelling to scholarship committees.

## Essential Components

### 1. Engaging Opening
* Begin with a hook that captures attention
* Consider a relevant anecdote, question, or surprising fact
* Make the reader want to continue reading

### 2. Clear Narrative Structure
* Organize your thoughts logically
* Create a coherent flow from beginning to middle to end
* Connect your past experiences to present abilities and future goals

### 3. Specific Examples
* Use concrete details rather than vague generalizations
* Describe situations that demonstrate your qualities
* Show rather than tells through descriptive language

### 4. Authentic Voice
* Write in your own natural style
* Avoid overly formal language that doesn't sound like you
* Let your personality and character shine through

### 5. Reflection and Insight
* Demonstrate self-awareness and personal growth
* Explain what you've learned from your experiences
* Show how challenges have shaped your perspective

### 6. Connection to Goals
* Link your past experiences to your educational path
* Explain how the scholarship supports your aspirations
* Demonstrate clarity about your future direction

### 7. Strong Conclusion
* End with a memorable final thought
* Reinforce your main message
* Leave the reader with a positive impression

Remember that scholarship committees read hundreds of essays. Your goal is to create a personal statement that is authentic, memorable, and persuasive.
''',
          ordinalPosition: 2,
          tags: ['personal statement', 'writing techniques', 'essay structure'],
        ),
        LearningContent(
          id: 'personal_statement_writing',
          title: 'Writing Your Personal Statement',
          type: ContentType.text,
          content: '''
# Writing Your Personal Statement: A Step-by-Step Guide

Follow this process to develop a compelling personal statement that showcases your unique qualities and experiences.

## 1. Preparation

### Self-Reflection
Before writing, take time to reflect on:
* Key experiences that have shaped you
* Challenges you've overcome
* Values that guide your decisions
* Goals and the motivation behind them
* Qualities that make you unique

### Research
* Read the scholarship provider's mission and values
* Understand what qualities they're looking for
* Study sample essays (but never copy them)
* Note the evaluation criteria if available

## 2. Planning Your Statement

### Choose Your Focus
Select 1-3 main themes or qualities to highlight, such as:
* Leadership
* Perseverance
* Innovation
* Community service
* Academic passion

### Create an Outline
* Introduction: Engaging hook and thesis
* Body paragraphs: Each illustrating a key quality with specific examples
* Conclusion: Synthesis and forward-looking statement

## 3. Writing the Draft

### Introduction Strategies
* Start with a compelling story
* Open with a meaningful quote (use sparingly)
* Begin with a thought-provoking question
* Present an interesting statistic or fact

### Body Paragraph Structure
* Topic sentence introducing the quality/theme
* Specific example demonstrating this quality
* Details that bring the example to life
* Reflection on what you learned or how you grew
* Connection to your educational/career goals

### Effective Storytelling Techniques
* Use sensory details to create vivid scenes
* Include dialogue for key conversations
* Show real personalities through dialogue and actions
* Create emotional connection through authentic emotion

### Conclusion Approaches
* Circle back to your opening (if appropriate)
* Summarize key themes without merely repeating
* Look forward to how you'll use the scholarship
* End with a memorable final thought

## 4. Revision

* Let your draft rest for at least a day
* Read aloud to catch awkward phrasing
* Check for clear transitions between paragraphs
* Ensure every sentence contributes to your main themes
* Remove clichés and overly general statements
* Replace passive voice with active constructions
* Verify that your authentic voice comes through

Follow this process, and you'll develop a personal statement that effectively communicates your unique qualities and readiness for scholarship support.
''',
          ordinalPosition: 3,
          tags: ['personal statement', 'writing process', 'scholarship essays'],
        ),
        LearningContent(
          id: 'personal_statement_examples',
          title: 'Personal Statement Examples and Analysis',
          type: ContentType.text,
          content: '''
# Personal Statement Examples and Analysis

Studying effective examples can help you understand what makes a personal statement successful. Below are sample excerpts with analysis of their strengths.

## Example 1: Narrative about personal development

> "The rhythmic beeping of hospital monitors became the soundtrack of my sophomore year when my mother was diagnosed with Stage 3 breast cancer. As the oldest child, I suddenly found myself juggling school assignments between hospital visits and helping care for my younger siblings. This experience could have derailed my education, but instead, it taught me resilience and time management skills I never knew I possessed. I created a detailed schedule that allowed me to maintain my 3.8 GPA while spending evenings at the hospital, often completing calculus homework under the glow of medical equipment. My mother's courage during treatment inspired me to approach challenges head-on, a mindset I now apply to everything from complex research projects to community leadership roles."

**Analysis:**
* Opens with vivid sensory details that immediately engage the reader
* Demonstrates resilience and time management through specific challenges
* Shows rather than tells about personal qualities
* Connects personal hardship to academic performance
* Illustrates growth and skills development through adversity

## Example 2: Academic passion and goals

> "When I discovered marine biology in a high school elective class, I didn't just find a subject I enjoyed—I found my calling. Growing up in a coastal community, I had always been fascinated by the ocean, but learning about coral reef ecosystems transformed my casual interest into a passionate commitment. After organizing a school club that conducted monthly beach clean-ups, I designed an independent research project to study microplastic pollution in local waterways. The results were concerning enough that I presented my findings to our city council, which subsequently implemented stricter regulations on single-use plastics. This experience solidified my desire to pursue a career in environmental science, where I can continue developing research that translates into tangible policy change."

**Analysis:**
* Shows the genesis and development of an academic interest
* Demonstrates initiative through specific projects
* Illustrates impact beyond personal achievement
* Connects past experiences to future goals
* Shows values and commitment to environmental issues

## Example 3: Overcoming challenges

> "Learning to read was my first real battle. Letters jumbled before my eyes, and words that seemed simple to my classmates were bewildering puzzles to me. My dyslexia diagnosis in third grade finally explained the struggle, but the real journey was just beginning. Working with specialists after school while my friends headed to the playground taught me that progress often requires sacrifice. Each new reading strategy became a tool in my arsenal, and by sixth grade, I had improved from a below-basic reading level to grade-level proficiency. This experience instilled in me a problem-solving mentality: identify the challenge, seek expert guidance, develop strategies, and persist until successful. This approach has served me well beyond academics, particularly in my work establishing a peer tutoring program for students with learning differences at my high school."

**Analysis:**
* Presents a significant challenge in a relatable way
* Shows persistence and growth through specific milestones
* Demonstrates how overcoming one challenge created transferable skills
* Connects personal struggle to helping others with similar challenges
* Reveals character through the description of the journey

When writing your personal statement, aim to incorporate the strengths demonstrated in these examples while telling your unique story.
''',
          ordinalPosition: 4,
          tags: ['personal statement', 'examples', 'analysis'],
        ),
        LearningContent(
          id: 'personal_statement_checklist',
          title: 'Personal Statement Review Checklist',
          type: ContentType.checklist,
          content: '''
- [ ] The opening paragraph captures attention and sets the tone
- [ ] Main themes or qualities are clearly demonstrated through specific examples
- [ ] The statement has a clear narrative arc or logical structure
- [ ] Each paragraph has a clear purpose that supports the overall message
- [ ] Specific, vivid details bring experiences and achievements to life
- [ ] The statement demonstrates reflection and insights from experiences
- [ ] My authentic voice and personality come through
- [ ] The statement shows rather than tells about my qualities
- [ ] Transitions between paragraphs create smooth flow
- [ ] Personal stories and examples directly relate to scholarship qualities
- [ ] Future goals are clearly articulated
- [ ] The connection between past experiences and future goals is established
- [ ] The conclusion is memorable and reinforces key themes
- [ ] Personal stories and examples are included
- [ ] No spelling or grammatical errors are present
- [ ] The statement meets the required word or character count
- [ ] Clichés and overly general statements have been eliminated
- [ ] The statement demonstrates why I deserve this specific scholarship
- [ ] At least two other people have reviewed the statement and provided feedback
- [ ] I have revised the statement at least three times
''',
          ordinalPosition: 5,
          tags: ['personal statement', 'checklist', 'revision'],
        ),
        LearningContent(
          id: 'personal_statement_quiz',
          title: 'Personal Statement Knowledge Check',
          type: ContentType.quiz,
          content: '''
Personal Statement Quiz
''',
          ordinalPosition: 6,
          tags: ['personal statement', 'quiz', 'assessment'],
        ),
      ],
      assessmentQuestions: [
        Question(
          id: 'ps_question1',
          text:
              'Which of the following is generally NOT effective in a personal statement?',
          type: QuestionType.singleChoice,
          options: [
            Option(
                id: 'q1_a',
                text: 'Using specific personal examples',
                value: 'specific_examples'),
            Option(
                id: 'q1_b',
                text: 'Including sensory details in stories',
                value: 'sensory_details'),
            Option(
                id: 'q1_c',
                text: 'Listing all extracurricular activities',
                value: 'listing_activities'),
            Option(
                id: 'q1_d',
                text: 'Reflecting on lessons learned',
                value: 'reflection'),
          ],
          required: true,
          category: 'personal',
        ),
        Question(
          id: 'ps_question2',
          text: 'What is the primary purpose of a personal statement?',
          type: QuestionType.singleChoice,
          options: [
            Option(
                id: 'q2_a',
                text: 'To repeat information already in your resume',
                value: 'repeat_resume'),
            Option(
                id: 'q2_b',
                text:
                    'To tell your unique story beyond grades and achievements',
                value: 'unique_story'),
            Option(
                id: 'q2_c',
                text: 'To explain poor academic performance',
                value: 'poor_academics'),
            Option(
                id: 'q2_d',
                text: 'To list all scholarships you\'ve won',
                value: 'list_scholarships'),
          ],
          required: true,
          category: 'personal',
        ),
      ],
    ),

    // Personal Branding Module
    LearningModule(
      id: 'module_personal_branding',
      title: 'Developing Your Personal Brand',
      description:
          'Create a consistent personal brand that showcases your strengths and aspirations to scholarship committees.',
      category: 'personal',
      difficulty: 3,
      contents: [
        LearningContent(
          id: 'personal_branding_intro',
          title: 'Understanding Personal Branding for Scholarships',
          type: ContentType.text,
          content: '''
# Understanding Personal Branding for Scholarships

Your personal brand is how you present yourself to scholarship committees across all application materials. It's the consistent impression you create that makes you memorable and distinctive.

## Why Personal Branding Matters for Scholarships

* **Differentiation**: Helps you stand out among equally qualified applicants
* **Consistency**: Creates a coherent narrative across all application elements
* **Memorability**: Makes your application stick in evaluators' minds
* **Authenticity**: Showcases your genuine strengths and values
* **Personal connection**: Authentic passion for the cause

## What Makes a Strong Personal Brand

* **Clarity**: Clear focus on key strengths and unique qualities
* **Consistency**: Similar themes across essays, recommendations, and interviews
* **Authenticity**: Genuine representation of who you are
* **Relevance**: Alignment with scholarship values and requirements
* **Distinctiveness**: Unique elements that set you apart

In this module, you'll learn how to develop and communicate a personal brand that effectively positions you for scholarship success.
''',
          ordinalPosition: 1,
          tags: ['personal branding', 'introduction', 'scholarships'],
        ),
        LearningContent(
          id: 'personal_branding_elements',
          title: 'Core Elements of Your Personal Brand',
          type: ContentType.text,
          content: '''
# Core Elements of Your Personal Brand

A compelling personal brand for scholarship applications consists of several key components that work together to create a memorable impression.

## 1. Your Unique Value Proposition

Your UVP is a clear statement that communicates:
* **Personal Strengths**: What you excel at
* **Passions**: What motivates you
* **Contributions**: How you create value for others
* **Goals**: Where you're headed
* **Personal Passions**: Causes you genuinely care about

**Example UVP**: "A first-generation college student with strong analytical skills who combines data expertise with community health advocacy to develop solutions for underserved populations."

## 2. Your Core Values

Identify 3-5 principles that guide your decisions and actions:
* **Integrity**: Ethical standards and honesty
* **Service**: Commitment to helping others
* **Excellence**: Pursuit of high standards
* **Innovation**: Creative problem-solving
* **Perseverance**: Determination in facing challenges

## 3. Your Personal Narrative

Develop a consistent story that connects:
* Your background and formative experiences
* Challenges you've overcome
* Key accomplishments and what they reveal about you
* How these experiences shape your goals
* Why your goals matter to you and others

## 4. Your Areas of Expertise

Identify your key knowledge areas and skills:
* Academic strengths
* Technical abilities
* Soft skills
* Unique combinations of skills
* Personal Growth**: Skills and insights you've developed

## 5. Your Visual Presentation

Consider how you present yourself:
* Professional appearance in interviews
* Consistent, professional email address
* Appropriate social media presence
* Well-formatted application materials
* Professional photo when required

## 6. Your Communication Style

Develop a consistent voice in your applications:
* Vocabulary that reflects your field and interests
* Level of formality appropriate to your field
* Balance of confidence and humility
* Use of field-specific terminology where appropriate
* Consistent tone across all materials

Take time to identify and develop each of these elements to create a cohesive personal brand that will strengthen your scholarship applications.
''',
          ordinalPosition: 2,
          tags: ['personal branding', 'core elements', 'value proposition'],
        ),
        LearningContent(
          id: 'personal_branding_development',
          title: 'Developing Your Personal Brand',
          type: ContentType.text,
          content: '''
# Developing Your Personal Brand: A Step-by-Step Process

Follow this process to create a compelling personal brand for your scholarship applications.

## Step 1: Self-Assessment

Begin by taking inventory of your qualities, experiences, and aspirations:

### Personal Inventory
* **Strengths**: What are you naturally good at?
* **Values**: What principles guide your decisions?
* **Passions**: What activities energize you?
* **Achievements**: What accomplishments are you most proud of?
* **Challenges**: What significant obstacles have you overcome?
* **Goals**: What do you want to accomplish in the future?

### External Feedback
* Ask 3-5 people who know you well to describe your best qualities
* Review past performance evaluations or recommendation letters
* Consider compliments you frequently receive
* Note patterns in how others describe you

## Step 2: Identify Your Brand Elements

Based on your self-assessment, define these key elements:

### Your Differentiators
What makes you unique compared to other applicants with similar qualifications?
* Unusual combination of skills or interests
* Distinctive background or perspective
* Special achievements or experiences

### Your Core Message
Develop a brief statement (1-2 sentences) that captures:
* Who you are
* What you excel at
* The impact you create or aspire to create

### Key Themes
Identify 3-5 consistent themes to emphasize across applications:
* Leadership style
* Problem-solving approach
* Community impact
* Academic excellence
* Innovative thinking

## Step 3: Express Your Brand Consistently

Apply your brand elements across all scholarship materials:

### Personal Statements
* Open and close with language that reinforces your core message
* Include stories that illustrate your key themes
* Use vocabulary that reflects your values and field of interest

### Resume/CV
* Organize to highlight experiences that support your brand themes
* Use action verbs that align with your personal qualities
* Emphasize achievements that demonstrate your unique value

### Interviews
* Prepare stories that illustrate your brand themes
* Develop clear, concise ways to communicate your unique value
* Ensure your appearance and demeanor align with your brand

### Recommendation Letters
* Brief recommenders on your brand themes and unique qualities
* Suggest specific examples they might include that reinforce your brand
* Thank recommenders who highlight aspects of your personal brand

## Step 4: Refine Your Brand

Your personal brand should evolve as you grow:

* Regularly reassess how well your brand reflects your current self
* Gather feedback on how your brand is perceived
* Make adjustments as you gain new experiences and achievements
* Ensure your brand remains authentic as it evolves

Remember: The most effective personal brand is both authentic and aspirational—it represents your true self while highlighting your best qualities and future potential.
''',
          ordinalPosition: 3,
          tags: ['personal branding', 'brand development', 'self-assessment'],
        ),
        LearningContent(
          id: 'personal_branding_exercise',
          title: 'Personal Branding Exercise',
          type: ContentType.exercise,
          content: '''
# Personal Branding Exercise: Creating Your Brand Profile

Complete this exercise to develop the key elements of your personal brand for scholarship applications.

## Part 1: Self-Discovery Questions

Take time to thoughtfully answer each question:

1. What three achievements are you most proud of, and why?

2. What challenges have you overcome that demonstrate your character?

3. What consistent positive feedback do you receive from teachers, mentors, or peers?

4. What activities do you lose track of time doing because you enjoy them so much?

5. What issues or causes do you feel most passionate about?

6. What are your top three skills or strengths?

7. What makes your perspective or approach different from others?

8. What three words would you want scholarship committees to associate with you?

## Part 2: Brand Element Development

Based on your answers above, develop these key brand elements:

### Your Personal Tagline
Create a brief (5-10 word) phrase that captures your essence and aspirations:

Example: "Building technological solutions for environmental challenges"

### Your Core Story
Identify one experience that best illustrates your key qualities and values:

Example: "When the pandemic shut down our community garden program, I developed a virtual gardening curriculum and distributed seed kits to 50 families, allowing our food security initiative to continue when it was needed most."

### Your Unique Value Proposition
Complete this statement: "Unlike other candidates with similar qualifications, I bring..."

Example: "Unlike other candidates with similar qualifications, I bring both technical data analysis skills and three years of direct community health outreach experience, allowing me to develop evidence-based solutions that work in real-world settings."

### Your Visual/Verbal Identifiers
List words, phrases, or themes you want to consistently incorporate:

Example:
- Key words: innovation, community impact, sustainable solutions
- Themes: connecting technology with human needs, data-driven social change
- Field-specific terms: community-based participatory research, iterative design

## Part 3: Consistency Check

Review your scholarship application materials with these questions:

1. Do my personal statements incorporate my core story or similar stories?

2. Does my resume highlight experiences that reflect my unique value?

3. Have I used consistent language and emphasized the same strengths across all materials?

4. Would someone reading multiple parts of my application get a clear, consistent impression of who I am?

5. Have I removed content that contradicts or dilutes my personal brand?

Keep your completed brand profile accessible as you prepare scholarship applications. Refer to it regularly to ensure consistency across all materials.
''',
          ordinalPosition: 4,
          tags: ['personal branding', 'exercise', 'profile development'],
        ),
        LearningContent(
          id: 'personal_branding_checklist',
          title: 'Personal Branding Checklist for Scholarship Applications',
          type: ContentType.checklist,
          content: '''
- [ ] I have identified 3-5 core qualities that define my personal brand
- [ ] I have developed a clear personal tagline or elevator pitch
- [ ] My personal statements consistently reflect my core brand themes
- [ ] My resume/CV highlights experiences that reinforce my brand
- [ ] I have removed or downplayed elements that dilute my brand message
- [ ] My recommendation letters reinforce consistent themes about me
- [ ] My social media profiles are consistent with my brand and professional
- [ ] My email address, profile photos, and other visual elements are professional
- [ ] I use consistent language and terminology across all application materials
- [ ] My examples and stories illustrate the same key qualities throughout my application
- [ ] I have prepared interview responses that reinforce my brand messages
- [ ] My application demonstrates clear alignment between my brand and the scholarship's values
- [ ] I have received feedback on how my brand comes across to others
- [ ] I can clearly articulate what makes me different from other applicants
- [ ] My brand feels authentic and true to who I really am
''',
          ordinalPosition: 5,
          tags: ['personal branding', 'checklist', 'application review'],
        ),
        LearningContent(
          id: 'personal_branding_quiz',
          title: 'Personal Branding Knowledge Check',
          type: ContentType.quiz,
          content: '''
Personal Branding Quiz
''',
          ordinalPosition: 6,
          tags: ['personal branding', 'quiz', 'assessment'],
        ),
      ],
      assessmentQuestions: [
        Question(
          id: 'pb_question1',
          text:
              'Which of the following is NOT typically a component of personal branding?',
          type: QuestionType.singleChoice,
          options: [
            Option(
                id: 'q1_a',
                text: 'Consistent presentation of your strengths',
                value: 'consistent_strengths'),
            Option(
                id: 'q1_b',
                text: 'Exaggerating accomplishments to impress committees',
                value: 'exaggerating'),
            Option(
                id: 'q1_c',
                text: 'Using similar themes across all application materials',
                value: 'similar_themes'),
            Option(
                id: 'q1_d',
                text: 'Highlighting what makes you unique',
                value: 'uniqueness'),
          ],
          required: true,
          category: 'personal',
        ),
        Question(
          id: 'pb_question2',
          text: 'What is a personal Unique Value Proposition (UVP)?',
          type: QuestionType.singleChoice,
          options: [
            Option(
                id: 'q2_a',
                text: 'A complete list of all your achievements',
                value: 'achievement_list'),
            Option(
                id: 'q2_b',
                text:
                    'A clear statement of what makes you valuable and distinctive',
                value: 'distinctive_value'),
            Option(
                id: 'q2_c',
                text: 'A description of your financial need',
                value: 'financial_need'),
            Option(
                id: 'q2_d',
                text: 'An explanation of why you need the scholarship money',
                value: 'need_explanation'),
          ],
          required: true,
          category: 'personal',
        ),
      ],
    ),
  ];
}
