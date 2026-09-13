import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isNewUser;

  const TasksScreen({
    super.key,
    required this.onThemeChanged,
    this.isNewUser = false,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _selectedTab = 0; // 0: Pending, 1: Submitted, 2: Graded

  DateTime get _today => DateTime.now();

  int _calculateDaysLeft(DateTime dueDate) {
    final difference = dueDate.difference(_today).inDays;
    return difference > 0 ? difference : 0;
  }

  late final List<Map<String, dynamic>> pendingAssignments;
  late final List<Map<String, dynamic>> submittedAssignments;
  late final List<Map<String, dynamic>> gradedAssignments;

  @override
  void initState() {
    super.initState();

    if (widget.isNewUser) {
      pendingAssignments = [];
      submittedAssignments = [];
      gradedAssignments = [];
    } else {
      pendingAssignments = [
        {
          'title': 'User Experience Project',
          'code': 'ICT725',
          'dueDate': DateTime(2026, 9, 25),
          'due': 'Sep 25, 2026',
          'priority': 'High',
          'description': 'Design and prototype a mobile app using Figma',
          'tasks': [
            {'name': 'Research user needs', 'done': true},
            {'name': 'Create wireframes', 'done': true},
            {'name': 'Design high-fidelity UI', 'done': true},
            {'name': 'Prototype interactions', 'done': false},
            {'name': 'User testing', 'done': false},
          ],
        },
        {
          'title': 'Mobile App Prototype',
          'code': 'ICT701',
          'dueDate': DateTime(2026, 10, 1),
          'due': 'Oct 1, 2026',
          'priority': 'Medium',
          'description': 'Build a cross-platform app using Flutter',
          'tasks': [
            {'name': 'Setup Flutter project', 'done': true},
            {'name': 'Design UI screens', 'done': true},
            {'name': 'Implement navigation', 'done': false},
            {'name': 'Add state management', 'done': false},
            {'name': 'Connect to API', 'done': false},
          ],
        },
        {
          'title': 'Physics Lab Report',
          'code': 'PHY301',
          'dueDate': DateTime(2026, 10, 5),
          'due': 'Oct 5, 2026',
          'priority': 'Low',
          'description': 'Write lab report for experiment 3',
          'tasks': [
            {'name': 'Collect data', 'done': true},
            {'name': 'Analyze results', 'done': false},
            {'name': 'Write introduction', 'done': false},
            {'name': 'Write methodology', 'done': false},
            {'name': 'Conclusion and references', 'done': false},
          ],
        },
        {
          'title': 'Math Problem Set',
          'code': 'MATH201',
          'dueDate': DateTime(2026, 10, 10),
          'due': 'Oct 10, 2026',
          'priority': 'Low',
          'description': 'Complete chapter 5 problem set',
          'tasks': [
            {'name': 'Section 5.1 problems', 'done': false},
            {'name': 'Section 5.2 problems', 'done': false},
            {'name': 'Section 5.3 problems', 'done': false},
            {'name': 'Section 5.4 problems', 'done': false},
            {'name': 'Review answers', 'done': false},
          ],
        },
      ];

      submittedAssignments = [
        {
          'title': 'UI Design Assignment',
          'code': 'ICT725',
          'submittedDate': DateTime(2026, 9, 15),
          'submitted': 'Sep 15, 2026',
          'description': 'Created a comprehensive UI design system',
          'tasks': [
            {'name': 'Research UI trends', 'done': true},
            {'name': 'Create mood board', 'done': true},
            {'name': 'Design screens', 'done': true},
            {'name': 'Create design system', 'done': true},
            {'name': 'Submit project', 'done': true},
          ],
          'feedback': 'Pending review...',
        },
        {
          'title': 'Research Paper',
          'code': 'ICT701',
          'submittedDate': DateTime(2026, 9, 10),
          'submitted': 'Sep 10, 2026',
          'description': 'Research paper on mobile app development',
          'tasks': [
            {'name': 'Choose topic', 'done': true},
            {'name': 'Gather sources', 'done': true},
            {'name': 'Write outline', 'done': true},
            {'name': 'Write draft', 'done': true},
            {'name': 'Final submission', 'done': true},
          ],
          'feedback': 'Pending review...',
        },
        {
          'title': 'Database Project',
          'code': 'ICT702',
          'submittedDate': DateTime(2026, 9, 20),
          'submitted': 'Sep 20, 2026',
          'description': 'Database design and implementation',
          'tasks': [
            {'name': 'Design ER diagram', 'done': true},
            {'name': 'Create tables', 'done': true},
            {'name': 'Write queries', 'done': true},
            {'name': 'Test database', 'done': true},
            {'name': 'Submit project', 'done': true},
          ],
          'feedback': 'Pending review...',
        },
      ];

      gradedAssignments = [
        {
          'title': 'Midterm Exam',
          'code': 'PHY301',
          'grade': '78%',
          'feedback': 'Needs improvement on section 3. Review the concepts and try again.',
          'submitted': 'Sep 5, 2026',
          'tasks': [
            {'name': 'Study chapters 1-3', 'done': true},
            {'name': 'Practice problems', 'done': true},
            {'name': 'Take exam', 'done': true},
            {'name': 'Review results', 'done': true},
          ],
        },
        {
          'title': 'Essay Draft',
          'code': 'ENG101',
          'grade': '88%',
          'feedback': 'Well written! Excellent structure and flow.',
          'submitted': 'Sep 28, 2026',
          'tasks': [
            {'name': 'Choose essay topic', 'done': true},
            {'name': 'Research and outline', 'done': true},
            {'name': 'Write first draft', 'done': true},
            {'name': 'Edit and proofread', 'done': true},
            {'name': 'Final submission', 'done': true},
          ],
        },
        {
          'title': 'Web Development Project',
          'code': 'ICT703',
          'grade': '92%',
          'feedback': 'Excellent work! Great use of modern frameworks.',
          'submitted': 'Sep 15, 2026',
          'tasks': [
            {'name': 'Design wireframes', 'done': true},
            {'name': 'Build frontend', 'done': true},
            {'name': 'Create backend API', 'done': true},
            {'name': 'Connect frontend to backend', 'done': true},
            {'name': 'Deploy application', 'done': true},
          ],
        },
        {
          'title': 'Data Structures Assignment',
          'code': 'CS201',
          'grade': '76%',
          'feedback': 'Good attempt. Work on optimizing your algorithms.',
          'submitted': 'Sep 8, 2026',
          'tasks': [
            {'name': 'Understand problem', 'done': true},
            {'name': 'Design algorithm', 'done': true},
            {'name': 'Implement code', 'done': true},
            {'name': 'Test and debug', 'done': true},
            {'name': 'Submit assignment', 'done': true},
          ],
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateAssignmentDialog,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
            child: Row(
              children: [
                _buildTab('Pending', 0, Icons.pending, pendingAssignments.length),
                _buildTab('Submitted', 1, Icons.check_circle, submittedAssignments.length),
                _buildTab('Graded', 2, Icons.grade, gradedAssignments.length),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _selectedTab == 0
                  ? _buildPendingTab()
                  : _selectedTab == 1
                  ? _buildSubmittedTab()
                  : _buildGradedTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon, int count) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF6C63FF) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? const Color(0xFF6C63FF) : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF6C63FF) : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  if (count > 0)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDarkMode ? Colors.grey : Colors.grey[700],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingTab() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (pendingAssignments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 64,
                color: isDarkMode ? Colors.grey : Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No pending assignments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isNewUser
                    ? 'Add your first assignment to get started'
                    : 'All caught up!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _showCreateAssignmentDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Assignment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: pendingAssignments.length,
      itemBuilder: (context, index) {
        final assignment = pendingAssignments[index];
        return _buildAssignmentCard(assignment, 'pending');
      },
    );
  }

  Widget _buildSubmittedTab() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (submittedAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pending_outlined,
              size: 64,
              color: isDarkMode ? Colors.grey : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No submitted assignments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Submit an assignment to see it here',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: submittedAssignments.length,
      itemBuilder: (context, index) {
        final assignment = submittedAssignments[index];
        return _buildAssignmentCard(assignment, 'submitted');
      },
    );
  }

  Widget _buildGradedTab() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (gradedAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.grade_outlined,
              size: 64,
              color: isDarkMode ? Colors.grey : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No graded assignments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back after your submissions are graded',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: gradedAssignments.length,
      itemBuilder: (context, index) {
        final assignment = gradedAssignments[index];
        return _buildAssignmentCard(assignment, 'graded');
      },
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment, String type) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isSubmitted = type == 'submitted';
    final bool isGraded = type == 'graded';
    final List tasks = assignment['tasks'] ?? [];
    final int completedTasks = tasks.where((t) => t['done'] == true).length;
    final int totalTasks = tasks.length;

    final double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    int daysLeft = 0;
    if (assignment.containsKey('dueDate')) {
      daysLeft = _calculateDaysLeft(assignment['dueDate']);
    }

    return Card(
      color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showAssignmentDetails(assignment, type);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              assignment['code'],
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (assignment.containsKey('due'))
                              Text(
                                'Due: ${assignment['due']}',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.grey : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            if (assignment.containsKey('submitted'))
                              Text(
                                'Submitted: ${assignment['submitted']}',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.grey : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (assignment.containsKey('priority'))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(assignment['priority']).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        assignment['priority'],
                        style: TextStyle(
                          fontSize: 10,
                          color: _getPriorityColor(assignment['priority']),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (isGraded)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        assignment['grade'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (isSubmitted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress ${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.grey : Colors.grey[600],
                              ),
                            ),
                            Text(
                              '$completedTasks/$totalTasks tasks',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.grey : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: isDarkMode
                                ? const Color(0xFF2A2A2A)
                                : const Color(0xFFE0E0E0),
                            color: progress == 1.0
                                ? Colors.green
                                : const Color(0xFF6C63FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (type == 'pending' && daysLeft > 0)
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: daysLeft <= 3
                            ? Colors.red.withValues(alpha: 0.2)
                            : Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${daysLeft}d',
                            style: TextStyle(
                              fontSize: 14,
                              color: daysLeft <= 3 ? Colors.red : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'left',
                            style: TextStyle(
                              fontSize: 8,
                              color: isDarkMode ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isSubmitted || isGraded)
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isGraded
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isGraded ? 'Graded' : 'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          color: isGraded ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              if (tasks.isNotEmpty && type == 'pending')
                Column(
                  children: [
                    const SizedBox(height: 12),
                    ...tasks.take(3).map((task) {
                      return _buildTaskPreview(task);
                    }).toList(),
                    if (tasks.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+ ${tasks.length - 3} more tasks',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.grey : Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskPreview(Map<String, dynamic> task) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            task['done'] ? Icons.check_box : Icons.check_box_outline_blank,
            size: 16,
            color: task['done'] ? const Color(0xFF6C63FF) : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task['name'],
              style: TextStyle(
                fontSize: 13,
                decoration: task['done'] ? TextDecoration.lineThrough : null,
                color: task['done']
                    ? (isDarkMode ? Colors.grey : Colors.grey[600])
                    : (isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _submitAssignment(Map<String, dynamic> assignment) {
    final now = DateTime.now();
    final submittedDate = _formatDate(now);

    setState(() {
      pendingAssignments.remove(assignment);
      submittedAssignments.insert(0, {
        'title': assignment['title'],
        'code': assignment['code'],
        'submittedDate': now,
        'submitted': submittedDate,
        'description': assignment['description'],
        'tasks': assignment['tasks'],
        'feedback': 'Pending review...',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${assignment['title']} submitted successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // ==================== CREATE ASSIGNMENT ====================
  void _showCreateAssignmentDialog() {
    final titleController = TextEditingController();
    final codeController = TextEditingController();
    final descController = TextEditingController();

    String selectedPriority = 'Medium';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

    // Local list of tasks being created
    final List<Map<String, dynamic>> newTasks = [];

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.add_task, color: Color(0xFF6C63FF)),
                        const SizedBox(width: 8),
                        Text(
                          'New Assignment',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Title
                    TextField(
                      controller: titleController,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Assignment Title',
                        prefixIcon: const Icon(Icons.title),
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Course code
                    TextField(
                      controller: codeController,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Course Code',
                        prefixIcon: const Icon(Icons.code),
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextField(
                      controller: descController,
                      maxLines: 2,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Priority
                    Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Low', 'Medium', 'High'].map((priority) {
                        final isSelected = selectedPriority == priority;
                        final color = _getPriorityColor(priority);
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedPriority = priority;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withValues(alpha: 0.2)
                                      : (isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0)),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? color : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    priority,
                                    style: TextStyle(
                                      color: isSelected ? color : (isDarkMode ? Colors.grey : Colors.grey[600]),
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Due date
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Color(0xFF6C63FF)),
                            const SizedBox(width: 12),
                            Text(
                              'Due: ${_formatDate(selectedDate)}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ===== TASKS SECTION =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tasks (${newTasks.length})',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _showAddTaskToNewDialog(
                              context,
                              isDarkMode,
                              newTasks,
                              setModalState,
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Task'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6C63FF),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    if (newTasks.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'No tasks yet. Tap "Add Task" to break down your work.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.grey : Colors.grey[600],
                          ),
                        ),
                      )
                    else
                      Column(
                        children: List.generate(newTasks.length, (i) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color(0xFF6C63FF),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    newTasks[i]['name'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      newTasks.removeAt(i);
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: isDarkMode ? Colors.grey : Colors.grey[400]!,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (titleController.text.trim().isEmpty ||
                                  codeController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter title and course code'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (newTasks.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please add at least one task'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                pendingAssignments.insert(0, {
                                  'title': titleController.text.trim(),
                                  'code': codeController.text.trim().toUpperCase(),
                                  'dueDate': selectedDate,
                                  'due': _formatDate(selectedDate),
                                  'priority': selectedPriority,
                                  'description': descController.text.trim().isEmpty
                                      ? 'No description'
                                      : descController.text.trim(),
                                  'tasks': List<Map<String, dynamic>>.from(newTasks),
                                });
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Assignment created successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Create',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
          },
        );
      },
    );
  }

  // Helper dialog to add a task during creation
  void _showAddTaskToNewDialog(
      BuildContext parentContext,
      bool isDarkMode,
      List<Map<String, dynamic>> newTasks,
      StateSetter setModalState,
      ) {
    final controller = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          title: Text(
            'Add Task',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'Task Name',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
              filled: true,
              fillColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                setModalState(() {
                  newTasks.add({'name': value.trim(), 'done': false});
                });
                Navigator.pop(dialogContext);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey : Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setModalState(() {
                    newTasks.add({'name': controller.text.trim(), 'done': false});
                  });
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // ==================== ADD TASK TO EXISTING ASSIGNMENT ====================
  void _addTaskToExistingAssignment(
      Map<String, dynamic> assignment,
      StateSetter setModalState,
      ) {
    final controller = TextEditingController();
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          title: Text(
            'Add Task',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'Task Name',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
              filled: true,
              fillColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                setModalState(() {
                  assignment['tasks'].add({
                    'name': value.trim(),
                    'done': false,
                  });
                });
                setState(() {});
                Navigator.pop(dialogContext);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey : Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setModalState(() {
                    assignment['tasks'].add({
                      'name': controller.text.trim(),
                      'done': false,
                    });
                  });
                  setState(() {});
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // ==================== ASSIGNMENT DETAILS ====================
  void _showAssignmentDetails(Map<String, dynamic> assignment, String type) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isSubmitted = type == 'submitted';
    final bool isGraded = type == 'graded';
    final List tasks = assignment['tasks'] ?? [];
    final int totalTasks = tasks.length;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final int completedTasks = tasks.where((t) => t['done'] == true).length;
            final double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          assignment['title'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      if (isGraded)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            assignment['grade'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isSubmitted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Pending Review',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Course: ${assignment['code']}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                  ),
                  if (assignment.containsKey('due'))
                    Text(
                      'Due: ${assignment['due']}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.grey[600],
                      ),
                    ),
                  if (assignment.containsKey('submitted'))
                    Text(
                      'Submitted: ${assignment['submitted']}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.grey[600],
                      ),
                    ),
                  if (assignment.containsKey('priority'))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(assignment['priority']).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Priority: ${assignment['priority']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: _getPriorityColor(assignment['priority']),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // ===== PROGRESS =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}% ($completedTasks/$totalTasks)',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: isDarkMode
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFE0E0E0),
                      color: progress == 1.0
                          ? Colors.green
                          : const Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== TASKS HEADER + ADD BUTTON =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      if (type == 'pending')
                        TextButton.icon(
                          onPressed: () {
                            _addTaskToExistingAssignment(assignment, setModalState);
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Task'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6C63FF),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // ===== TASKS LIST =====
                  if (tasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No tasks yet. Tap "Add Task" to create one.',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                      ),
                    )
                  else
                    ...List.generate(tasks.length, (i) {
                      return _buildTaskTileModalWithDelete(
                        tasks[i],
                        setModalState,
                        allowToggle: type == 'pending',
                        onDelete: type == 'pending'
                            ? () {
                          setModalState(() {
                            tasks.removeAt(i);
                          });
                          setState(() {});
                        }
                            : null,
                      );
                    }),

                  const SizedBox(height: 24),

                  // ===== DESCRIPTION =====
                  if (assignment.containsKey('description'))
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            assignment['description'],
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (assignment.containsKey('feedback') && isSubmitted)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.timer, size: 16, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Status',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'This assignment has been submitted and is waiting for grading.',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (assignment.containsKey('feedback') && isGraded)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.feedback, size: 16, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  'Feedback',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              assignment['feedback'],
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // ===== ACTION BUTTONS =====
                  Row(
                    children: [
                      if (type == 'pending' && progress < 1.0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setModalState(() {
                                for (var task in tasks) {
                                  task['done'] = true;
                                }
                              });
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All tasks completed!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                            ),
                            child: const Text('Complete All'),
                          ),
                        ),
                      if (type == 'pending' && progress == 1.0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _submitAssignment(assignment);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Submit'),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDarkMode ? Colors.grey : Colors.grey[400]!,
                            ),
                          ),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  Widget _buildTaskTileModalWithDelete(
      Map<String, dynamic> task,
      StateSetter setModalState, {
        bool allowToggle = true,
        VoidCallback? onDelete,
      }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Checkbox(
            value: task['done'],
            onChanged: allowToggle
                ? (bool? value) {
              setModalState(() {
                task['done'] = value ?? false;
              });
              setState(() {});
            }
                : null,
            activeColor: const Color(0xFF6C63FF),
            checkColor: Colors.white,
          ),
          Expanded(
            child: Text(
              task['name'],
              style: TextStyle(
                fontSize: 14,
                decoration: task['done'] ? TextDecoration.lineThrough : null,
                color: task['done']
                    ? (isDarkMode ? Colors.grey : Colors.grey[600])
                    : (isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ),
          if (task['done'])
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 16,
              ),
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: isDarkMode ? Colors.grey : Colors.grey[600],
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDelete,
              tooltip: 'Remove task',
            ),
        ],
      ),
    );
  }
}