import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart';
import '../shared_state.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final Function(bool) onThemeChanged;
  final bool isNewUser;

  const ProfileScreen({
    super.key,
    this.userName = 'Student',
    required this.onThemeChanged,
    this.isNewUser = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;
  bool _showEnrolledClasses = false;
  bool _showCompletedTasks = false;

  // Editable profile fields
  late String _userName;
  late String _studentId;
  late String _email;
  late String _university;
  late String _course;
  late String _joinedDate;
  late String _status;

  // Store image in multiple formats for cross-platform support
  File? _profileImageFile;
  Uint8List? _profileImageBytes;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _studentId = '20037363';

    // Generate email from username
    final cleanName = widget.userName
        .toLowerCase()
        .trim()
        .replaceAll(' ', '.')
        .replaceAll(RegExp(r'[^a-z.]'), '');
    _email = '$cleanName@student.edu';

    // New users get default empty-ish values
    _university = widget.isNewUser ? 'Not set' : "King's Own Institute";
    _course = widget.isNewUser ? 'Not set' : 'ICT725 - User Experience';
    _joinedDate = widget.isNewUser ? 'Just now' : 'February 2026';
    _status = 'Active Student';

    // Sync with any image already set in shared state (e.g., set earlier
    // on another screen, or surviving a rebuild).
    final shared = profileImageNotifier.value;
    if (shared.file != null) {
      _profileImageFile = shared.file;
    } else if (shared.bytes != null) {
      _profileImageBytes = shared.bytes;
    }
  }

  // Enrolled Classes - empty for new users
  List<Map<String, dynamic>> get _enrolledClasses {
    if (widget.isNewUser) return [];
    return [
      {'code': 'ICT725', 'name': 'User Experience Design', 'instructor': 'Dr. Sarah Johnson', 'schedule': 'Mon/Wed 10:00 AM - 12:00 PM', 'progress': 0.75},
      {'code': 'ICT701', 'name': 'Mobile App Development', 'instructor': 'Prof. Mike Chen', 'schedule': 'Tue/Thu 2:00 PM - 4:00 PM', 'progress': 0.60},
      {'code': 'PHY301', 'name': 'Physics Laboratory', 'instructor': 'Dr. Emma Wilson', 'schedule': 'Fri 1:00 PM - 4:00 PM', 'progress': 0.40},
      {'code': 'MATH201', 'name': 'Advanced Mathematics', 'instructor': 'Prof. James Brown', 'schedule': 'Mon/Wed 4:00 PM - 6:00 PM', 'progress': 0.30},
    ];
  }

  // Completed Tasks - empty for new users
  List<Map<String, dynamic>> get _completedTasks {
    if (widget.isNewUser) return [];
    return [
      {'title': 'UI Design Assignment', 'code': 'ICT725', 'grade': '85%', 'completed': 'Sep 15, 2026', 'feedback': 'Good work! Keep it up!'},
      {'title': 'Research Paper', 'code': 'ICT701', 'grade': '92%', 'completed': 'Sep 10, 2026', 'feedback': 'Excellent research!'},
      {'title': 'Midterm Exam', 'code': 'PHY301', 'grade': '78%', 'completed': 'Sep 5, 2026', 'feedback': 'Needs improvement on section 3'},
      {'title': 'Essay Draft', 'code': 'ENG101', 'grade': '88%', 'completed': 'Sep 28, 2026', 'feedback': 'Well written!'},
    ];
  }

  // GPA - empty for new users
  String get _gpa => widget.isNewUser ? 'N/A' : '3.8';
  String get _gpaStatus => widget.isNewUser ? 'No grades yet' : 'Good Standing';

  // ==================== IMAGE PICKER METHODS ====================

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          if (!mounted) return;
          setState(() {
            _profileImageBytes = bytes;
            _profileImageFile = null;
          });
          setProfileImageFromBytes(bytes);
        } else {
          if (!mounted) return;
          final file = File(pickedFile.path);
          setState(() {
            _profileImageFile = file;
            _profileImageBytes = null;
          });
          setProfileImageFromFile(file);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo updated!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera is not available on web. Please use Gallery.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        if (!mounted) return;
        final file = File(pickedFile.path);
        setState(() {
          _profileImageFile = file;
          _profileImageBytes = null;
        });
        setProfileImageFromFile(file);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo updated!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeProfileImage() {
    setState(() {
      _profileImageFile = null;
      _profileImageBytes = null;
    });
    clearProfileImage();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile photo removed'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  bool get _hasProfileImage => _profileImageFile != null || _profileImageBytes != null;

  Widget _buildProfileImageWidget(String initials) {
    if (_profileImageBytes != null) {
      return Image.memory(
        _profileImageBytes!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (_profileImageFile != null && !kIsWeb) {
      return Image.file(
        _profileImageFile!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        color: Colors.white24,
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_library, color: Color(0xFF6C63FF)),
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                if (!kIsWeb)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.camera_alt, color: Color(0xFF6C63FF)),
                    ),
                    title: Text(
                      'Take a Photo',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromCamera();
                    },
                  ),
                if (_hasProfileImage)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    title: Text(
                      'Remove Photo',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _removeProfileImage();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== EDIT PROFILE ====================

  void _showEditProfileDialog() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final nameController = TextEditingController(text: _userName);
    final studentIdController = TextEditingController(text: _studentId);
    final emailController = TextEditingController(text: _email);
    final universityController = TextEditingController(text: _university);
    final courseController = TextEditingController(text: _course);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                    const Icon(Icons.edit, color: Color(0xFF6C63FF)),
                    const SizedBox(width: 8),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildEditField(
                  controller: nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildEditField(
                  controller: studentIdController,
                  label: 'Student ID',
                  icon: Icons.badge,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildEditField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildEditField(
                  controller: universityController,
                  label: 'University',
                  icon: Icons.school,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildEditField(
                  controller: courseController,
                  label: 'Course',
                  icon: Icons.menu_book,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 24),
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
                          setState(() {
                            _userName = nameController.text.trim().isEmpty
                                ? _userName
                                : nameController.text.trim();
                            _studentId = studentIdController.text.trim().isEmpty
                                ? _studentId
                                : studentIdController.text.trim();
                            _email = emailController.text.trim().isEmpty
                                ? _email
                                : emailController.text.trim();
                            _university = universityController.text.trim().isEmpty
                                ? _university
                                : universityController.text.trim();
                            _course = courseController.text.trim().isEmpty
                                ? _course
                                : courseController.text.trim();
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully!'),
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
                          'Save Changes',
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
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.grey[600],
        ),
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? Colors.grey : Colors.grey[600],
        ),
        filled: true,
        fillColor: isDarkMode
            ? const Color(0xFF0A0A0A)
            : const Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ==================== PRIVACY POLICY ====================

  void _showPrivacyPolicy() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.privacy_tip, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 8),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPolicySection('Last Updated', 'September 2026', isDarkMode),
                        _buildPolicySection(
                          '1. Information We Collect',
                          'ClassCircle collects the following information to provide you with academic management services:\n\n'
                              '- Personal Information: Name, email address, student ID\n'
                              '- Academic Data: Enrolled courses, assignments, grades\n'
                              '- Usage Data: App interactions, chat messages, study group activity\n'
                              '- Device Information: Device type, operating system, app version',
                          isDarkMode,
                        ),
                        _buildPolicySection(
                          '2. How We Use Your Information',
                          'Your information is used to:\n\n'
                              '- Provide and maintain the ClassCircle service\n'
                              '- Enable study group collaboration and messaging\n'
                              '- Track your academic progress and assignments\n'
                              '- Send you important notifications about deadlines\n'
                              '- Improve the app experience based on usage patterns',
                          isDarkMode,
                        ),
                        _buildPolicySection(
                          '3. Information Sharing',
                          'We do not sell, trade, or rent your personal information to third parties. '
                              'Your data is only shared with:\n\n'
                              '- Your educational institution (for academic records)\n'
                              '- Study group members (only your name and course info)\n'
                              '- Service providers who help us operate the app',
                          isDarkMode,
                        ),
                        _buildPolicySection(
                          '4. Data Security',
                          'We implement industry-standard security measures including:\n\n'
                              '- Encryption of data in transit and at rest\n'
                              '- Secure authentication with two-factor verification\n'
                              '- Regular security audits and updates\n'
                              '- Limited access to personal data by authorized personnel only',
                          isDarkMode,
                        ),
                        _buildPolicySection(
                          '5. Your Rights',
                          'You have the right to:\n\n'
                              '- Access your personal data\n'
                              '- Correct inaccurate information\n'
                              '- Delete your account and associated data\n'
                              '- Opt out of non-essential communications\n'
                              '- Export your data in a portable format',
                          isDarkMode,
                        ),
                        _buildPolicySection(
                          '6. Cookies and Tracking',
                          'ClassCircle uses minimal tracking to improve your experience. '
                              'We do not use third-party advertising trackers. '
                              'Session data is stored locally on your device and cleared upon logout.',
                          isDarkMode,
                        ),
                        _buildPolicySection(
                          '7. Children\'s Privacy',
                          'ClassCircle is designed for university students aged 18 and above. '
                              'We do not knowingly collect information from children under 18. '
                              'If you believe a child has provided us with personal data, please contact us.',
                          isDarkMode,
                        ),
                        _buildPolicySection(
                          '8. Changes to This Policy',
                          'We may update this privacy policy from time to time. '
                              'We will notify you of any significant changes through the app. '
                              'Continued use of ClassCircle after changes constitutes acceptance of the updated policy.',
                          isDarkMode,
                        ),
                        _buildPolicySection(
                          '9. Contact Us',
                          'If you have questions about this privacy policy, please contact:\n\n'
                              'Email: privacy@classcircle.app\n'
                              'Address: ClassCircle Support Team\n'
                              'King\'s Own Institute\n'
                              'Sydney, Australia',
                          isDarkMode,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'ClassCircle v1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPolicySection(String title, String content, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDarkMode ? Colors.grey : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELP & SUPPORT ====================

  void _showHelpSupport() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.help, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 8),
                          Text(
                            'Help & Support',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFaqItem(
                          'How do I join a study group?',
                          'Go to the Classes tab, browse available groups, and tap the join button. '
                              'You can also create your own study group from the same screen.',
                          isDarkMode,
                        ),
                        _buildFaqItem(
                          'How do I submit an assignment?',
                          'Navigate to the Tasks tab, open a pending assignment, and complete all tasks. '
                              'Once 100% complete, tap "Submit Assignment".',
                          isDarkMode,
                        ),
                        _buildFaqItem(
                          'What is the OTP code for login?',
                          'For this demo version, the OTP is always 123456. '
                              'In production, a unique code would be sent to your email.',
                          isDarkMode,
                        ),
                        _buildFaqItem(
                          'How do I change my theme?',
                          'Go to Profile > Dark Mode toggle to switch between dark and light themes.',
                          isDarkMode,
                        ),
                        _buildFaqItem(
                          'Can I use ClassCircle offline?',
                          'Basic features like viewing your profile work offline. '
                              'Chat and group features require an internet connection.',
                          isDarkMode,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Still need help?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF2A2A2A)
                                : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildContactRow(Icons.email, 'support@classcircle.app', isDarkMode),
                              const SizedBox(height: 12),
                              _buildContactRow(Icons.phone, '+61 2 1234 5678', isDarkMode),
                              const SizedBox(height: 12),
                              _buildContactRow(Icons.language, 'www.classcircle.app/support', isDarkMode),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFaqItem(String question, String answer, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        iconColor: const Color(0xFF6C63FF),
        collapsedIconColor: isDarkMode ? Colors.grey : Colors.grey[600],
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDarkMode ? Colors.grey : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6C63FF)),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    String initials = _userName
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    if (initials.isEmpty) initials = 'S';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated!'), duration: Duration(seconds: 1)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(initials, _userName, _studentId, _email, isDarkMode),

            // New user welcome prompt
            if (widget.isNewUser) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF6C63FF), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete your profile',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap "Edit Profile" below to add your university and course details.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            _buildStatsRow(isDarkMode),
            const SizedBox(height: 24),
            _buildAboutSection(isDarkMode),
            const SizedBox(height: 24),

            // Enrolled Classes section
            if (widget.isNewUser)
              _buildEmptySection(
                title: 'Enrolled Classes',
                message: 'You have not enrolled in any classes yet',
                icon: Icons.class_outlined,
                isDarkMode: isDarkMode,
              )
            else
              _buildExpandableSection(
                title: 'Enrolled Classes',
                count: _enrolledClasses.length,
                isExpanded: _showEnrolledClasses,
                isDarkMode: isDarkMode,
                onToggle: () => setState(() => _showEnrolledClasses = !_showEnrolledClasses),
                child: _buildEnrolledClasses(isDarkMode),
              ),

            const SizedBox(height: 12),

            // Completed Tasks section
            if (widget.isNewUser)
              _buildEmptySection(
                title: 'Completed Tasks',
                message: 'You have not completed any tasks yet',
                icon: Icons.task_alt,
                isDarkMode: isDarkMode,
              )
            else
              _buildExpandableSection(
                title: 'Completed Tasks',
                count: _completedTasks.length,
                isExpanded: _showCompletedTasks,
                isDarkMode: isDarkMode,
                onToggle: () => setState(() => _showCompletedTasks = !_showCompletedTasks),
                child: _buildCompletedTasks(isDarkMode),
              ),

            const SizedBox(height: 24),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              Icons.person,
              'Edit Profile',
              'Update your personal information',
              isDarkMode: isDarkMode,
              onTap: _showEditProfileDialog,
            ),
            _buildSettingsTile(
              Icons.notifications,
              'Notifications',
              'Manage notification preferences',
              isDarkMode: isDarkMode,
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notifications ${value ? 'enabled' : 'disabled'}'), duration: const Duration(seconds: 1)),
                  );
                },
                activeColor: const Color(0xFF6C63FF),
              ),
            ),
            _buildSettingsTile(
              Icons.color_lens,
              'Dark Mode',
              'Toggle dark theme',
              isDarkMode: isDarkMode,
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() => _isDarkMode = value);
                  widget.onThemeChanged(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${value ? 'Dark' : 'Light'} mode enabled'), duration: const Duration(seconds: 1)),
                  );
                },
                activeColor: const Color(0xFF6C63FF),
              ),
            ),
            _buildSettingsTile(
              Icons.help,
              'Help & Support',
              'FAQs and contact support',
              isDarkMode: isDarkMode,
              onTap: _showHelpSupport,
            ),
            _buildSettingsTile(
              Icons.privacy_tip,
              'Privacy Policy',
              'Read our privacy policy',
              isDarkMode: isDarkMode,
              onTap: _showPrivacyPolicy,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'ClassCircle v1.0.0',
                style: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey[600], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== WIDGETS ====================

  Widget _buildEmptySection({
    required String title,
    required String message,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: isDarkMode ? Colors.grey : Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      String initials, String userName, String studentId, String email, bool isDarkMode,
      ) {
    return Container(
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
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child: _buildProfileImageWidget(initials),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'Student ID: $studentId',
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(email, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap photo to change',
            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required int count,
    required bool isExpanded,
    required bool isDarkMode,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: isDarkMode ? Colors.grey : Colors.grey[600],
            ),
            onTap: onToggle,
          ),
          if (isExpanded) child,
        ],
      ),
    );
  }

  Widget _buildEnrolledClasses(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _enrolledClasses.length,
      itemBuilder: (context, index) {
        final classItem = _enrolledClasses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${classItem['code']} - ${classItem['name']}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${(classItem['progress'] * 100).toInt()}%',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(classItem['instructor'], style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey : Colors.grey[600])),
              const SizedBox(height: 2),
              Text(classItem['schedule'], style: TextStyle(fontSize: 11, color: isDarkMode ? Colors.grey : Colors.grey[600])),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: classItem['progress'],
                  minHeight: 4,
                  backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFD0D0D0),
                  color: const Color(0xFF6C63FF),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompletedTasks(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _completedTasks.length,
      itemBuilder: (context, index) {
        final task = _completedTasks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    Text(
                      '${task['code']} - Completed: ${task['completed']}',
                      style: TextStyle(fontSize: 11, color: isDarkMode ? Colors.grey : Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task['grade'],
                  style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'GPA',
            _gpa,
            _gpaStatus,
            widget.isNewUser ? Colors.grey : Colors.green,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Classes',
            '${_enrolledClasses.length}',
            'Enrolled',
            Colors.blue,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Tasks',
            '${_completedTasks.length}',
            'Completed',
            Colors.orange,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String subtitle, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey : Colors.grey[600])),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.grey : Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('University', _university, isDarkMode),
          _buildInfoRow('Course', _course, isDarkMode),
          _buildInfoRow('Joined', _joinedDate, isDarkMode),
          _buildInfoRow('Status', _status, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey[600])),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
      IconData icon,
      String title,
      String subtitle, {
        required bool isDarkMode,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    return Card(
      color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      elevation: isDarkMode ? 0 : 1,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey : Colors.grey[600])),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? Colors.grey : Colors.grey[600]),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          title: Text('Logout', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          content: Text('Are you sure you want to logout?', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                clearProfileImage();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(onThemeChanged: widget.onThemeChanged),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully'), duration: Duration(seconds: 1)),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}