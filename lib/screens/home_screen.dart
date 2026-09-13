import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../shared_state.dart';
import 'classes_screen.dart';
import 'chat_screen.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final Function(bool) onThemeChanged;
  final bool isNewUser;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.onThemeChanged,
    this.isNewUser = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Screens are built ONCE and kept alive using IndexedStack.
  // This preserves state when switching between tabs.
  late final List<Widget> _screens;

  // Get first name only (e.g., "Abhishek Kumar" becomes "Abhishek")
  String get _firstName {
    final name = widget.userName.trim();
    if (name.isEmpty) return 'Student';
    return name.split(' ').first;
  }

  // Get initials from name
  String get _initials {
    final name = widget.userName.trim();
    if (name.isEmpty) return 'S';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  // Data for existing users only (empty for new users)
  List<Map<String, dynamic>> get _upcomingAssignments {
    if (widget.isNewUser) return [];
    return [
      {
        'title': 'User Experience Project',
        'code': 'ICT725',
        'due': 'Sep 25, 2026',
        'daysLeft': 3,
        'priority': 'High',
      },
      {
        'title': 'Mobile App Prototype',
        'code': 'ICT701',
        'due': 'Oct 1, 2026',
        'daysLeft': 7,
        'priority': 'Medium',
      },
      {
        'title': 'Physics Lab Report',
        'code': 'PHY301',
        'due': 'Oct 5, 2026',
        'daysLeft': 11,
        'priority': 'Low',
      },
    ];
  }

  // Data for existing users only (empty for new users)
  List<Map<String, dynamic>> get _recentChats {
    if (widget.isNewUser) return [];
    return [
      {
        'name': 'Sarah Johnson',
        'message': 'See you in class tomorrow!',
        'time': '10:30 AM',
        'image': 'assets/images/sarah.png',
      },
      {
        'name': 'Mike Chen',
        'message': 'Can you share the notes?',
        'time': '9:15 AM',
        'image': 'assets/images/mike.png',
      },
      {
        'name': 'ICT725 Study Group',
        'message': 'Assignment due next week!',
        'time': 'Yesterday',
        'image': null,
      },
    ];
  }

  // Stats for new users (all zeros) vs existing users
  int get _classesCount => widget.isNewUser ? 0 : 4;
  int get _tasksCount => widget.isNewUser ? 0 : 12;
  int get _messagesCount => widget.isNewUser ? 0 : 6;

  @override
  void initState() {
    super.initState();

    // Build all screens once here so their state is preserved.
    // Important: We do NOT call Theme.of(context) in initState.
    _screens = [
      _HomeContentWidget(
        userName: widget.userName,
        firstName: _firstName,
        initials: _initials,
        isNewUser: widget.isNewUser,
        upcomingAssignments: _upcomingAssignments,
        recentChats: _recentChats,
        classesCount: _classesCount,
        tasksCount: _tasksCount,
        messagesCount: _messagesCount,
        getPriorityColor: _getPriorityColor,
        onNavigate: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      ClassesScreen(
        onThemeChanged: widget.onThemeChanged,
        isNewUser: widget.isNewUser,
      ),
      ChatScreen(
        onThemeChanged: widget.onThemeChanged,
        isNewUser: widget.isNewUser,
      ),
      TasksScreen(
        onThemeChanged: widget.onThemeChanged,
        isNewUser: widget.isNewUser,
      ),
      ProfileScreen(
        userName: widget.userName,
        onThemeChanged: widget.onThemeChanged,
        isNewUser: widget.isNewUser,
      ),
    ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps every screen alive in memory, so nothing
      // you do in one tab is lost when you switch to another.
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Separate widget for the home tab content.
// Moved out of _HomeScreenState so that Theme.of(context) can be used
// safely inside build(), and so that IndexedStack can keep it alive.
class _HomeContentWidget extends StatelessWidget {
  final String userName;
  final String firstName;
  final String initials;
  final bool isNewUser;
  final List<Map<String, dynamic>> upcomingAssignments;
  final List<Map<String, dynamic>> recentChats;
  final int classesCount;
  final int tasksCount;
  final int messagesCount;
  final Color Function(String) getPriorityColor;
  final Function(int) onNavigate;

  const _HomeContentWidget({
    required this.userName,
    required this.firstName,
    required this.initials,
    required this.isNewUser,
    required this.upcomingAssignments,
    required this.recentChats,
    required this.classesCount,
    required this.tasksCount,
    required this.messagesCount,
    required this.getPriorityColor,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF4A3DBF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Live-updating avatar: shows the shared profile photo
                    // if one has been set on the Profile screen, otherwise
                    // falls back to initials.
                    ValueListenableBuilder<ProfileImage>(
                      valueListenable: profileImageNotifier,
                      builder: (context, image, _) {
                        if (image.bytes != null) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white24,
                            backgroundImage: MemoryImage(image.bytes!),
                          );
                        }
                        if (image.file != null && !kIsWeb) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white24,
                            backgroundImage: FileImage(image.file!),
                          );
                        }
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white24,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isNewUser ? 'Welcome,' : 'Welcome back,',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            firstName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildQuickStat(
                      Icons.class_,
                      '$classesCount',
                      'Classes',
                    ),
                    _buildQuickStat(
                      Icons.task,
                      '$tasksCount',
                      'Tasks',
                    ),
                    _buildQuickStat(
                      Icons.chat,
                      '$messagesCount',
                      'Messages',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // New user welcome card
          if (isNewUser) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.celebration,
                    size: 48,
                    color: Color(0xFF6C63FF),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome to ClassCircle, $firstName!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your account has been created successfully. '
                        'Get started by joining a study group, creating a task, or connecting with peers!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onNavigate(1),
                          icon: const Icon(Icons.group_add, size: 18),
                          label: const Text('Join Group'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => onNavigate(3),
                          icon: const Icon(Icons.add_task, size: 18),
                          label: const Text('Add Task'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6C63FF),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFF6C63FF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick start guide for new users
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Start Guide',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildGuideStep(
                    Icons.group_add,
                    'Join a Study Group',
                    'Connect with classmates and collaborate on projects',
                    isDarkMode,
                  ),
                  _buildGuideStep(
                    Icons.task_alt,
                    'Track Your Tasks',
                    'Create and manage your assignments in one place',
                    isDarkMode,
                  ),
                  _buildGuideStep(
                    Icons.chat_bubble_outline,
                    'Chat with Peers',
                    'Message classmates and study group members',
                    isDarkMode,
                  ),
                  _buildGuideStep(
                    Icons.person,
                    'Complete Your Profile',
                    'Add your university, course, and about me',
                    isDarkMode,
                  ),
                ],
              ),
            ),
          ] else ...[
            // GPA Card (only for existing users)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.analytics,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current GPA',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '3.8',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Good Standing',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Upcoming Assignments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Assignments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigate(3),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...upcomingAssignments.map((assignment) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: getPriorityColor(assignment['priority'])
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.assignment,
                        color: getPriorityColor(assignment['priority']),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${assignment['code']} - Due: ${assignment['due']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${assignment['daysLeft']}d',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            // Recent Chats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Chats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigate(2),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...recentChats.map((chat) {
              final String? imagePath = chat['image'] as String?;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                      const Color(0xFF6C63FF).withValues(alpha: 0.2),
                      backgroundImage: imagePath != null
                          ? AssetImage(imagePath)
                          : null,
                      child: imagePath == null
                          ? Text(
                        chat['name'][0],
                        style: const TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            chat['message'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      chat['time'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.white70,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStep(
      IconData icon,
      String title,
      String description,
      bool isDarkMode,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6C63FF),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}