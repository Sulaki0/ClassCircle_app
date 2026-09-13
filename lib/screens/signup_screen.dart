import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SignupScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIDController = TextEditingController();
  final _universityController = TextEditingController();
  final _courseController = TextEditingController();
  final _aboutController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Password strength tracking
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  // Dropdown values
  String? _selectedUniversity;
  String? _selectedCourse;

  // University options
  final List<String> _universities = [
    "King's Own Institute",
    'University of Sydney',
    'University of Melbourne',
    'UNSW Sydney',
    'Monash University',
    'Other',
  ];

  // Course options
  final List<String> _courses = [
    'ICT725 - User Experience',
    'ICT701 - Mobile App Development',
    'PHY301 - Physics',
    'MATH201 - Mathematics',
    'ENG101 - English',
    'Other',
  ];

  // Email validation regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Update password strength indicators
  void _updatePasswordStrength(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  // Check if password is strong enough
  bool get _isPasswordStrong =>
      _hasMinLength &&
          _hasUppercase &&
          _hasLowercase &&
          _hasNumber &&
          _hasSpecialChar;

  void _signup() async {
    // Validate full name
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your full name';
      });
      return;
    }

    if (_nameController.text.trim().length < 3) {
      setState(() {
        _errorMessage = 'Full name must be at least 3 characters';
      });
      return;
    }

    // Validate email format
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email';
      });
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    // Validate student ID
    if (_studentIDController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your student ID';
      });
      return;
    }

    if (_studentIDController.text.trim().length < 5) {
      setState(() {
        _errorMessage = 'Student ID must be at least 5 characters';
      });
      return;
    }

    // Validate university
    if (_selectedUniversity == null) {
      setState(() {
        _errorMessage = 'Please select your university';
      });
      return;
    }

    // Validate course
    if (_selectedCourse == null) {
      setState(() {
        _errorMessage = 'Please select your course';
      });
      return;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
      });
      return;
    }

    if (!_isPasswordStrong) {
      setState(() {
        _errorMessage =
        'Password must be 8+ characters with uppercase, lowercase, number & special character';
      });
      return;
    }

    // Validate confirm password
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please confirm your password';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    String fullName = _nameController.text.trim();
    String email = _emailController.text.trim();
    String studentId = _studentIDController.text.trim();
    String university = _selectedUniversity ?? '';
    String course = _selectedCourse ?? '';
    String about = _aboutController.text.trim();

    if (!mounted) return;

    // Navigate to OTP - will go directly to Home after verification
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(
          userName: fullName,
          email: email,
          studentId: studentId,
          university: university,
          course: course,
          about: about,
          purpose: 'signup',
          isNewUser: true,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(
                  onThemeChanged: widget.onThemeChanged,
                ),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All fields are required',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Full Name
                TextField(
                  controller: _nameController,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    hintText: 'John Doe',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F5F5),
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
                  onChanged: (_) => setState(() => _errorMessage = ''),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    hintText: 'student@example.com',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F5F5),
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
                  onChanged: (_) => setState(() => _errorMessage = ''),
                ),
                const SizedBox(height: 16),

                // Student ID
                TextField(
                  controller: _studentIDController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Student ID *',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.badge,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    hintText: '20037363',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F5F5),
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
                  onChanged: (_) => setState(() => _errorMessage = ''),
                ),
                const SizedBox(height: 16),

                // University Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedUniversity,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  dropdownColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                  decoration: InputDecoration(
                    labelText: 'University *',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.school,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F5F5),
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
                  items: _universities.map((uni) {
                    return DropdownMenuItem(
                      value: uni,
                      child: Text(
                        uni,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUniversity = value;
                      _errorMessage = '';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Course Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  dropdownColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Course *',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.book,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F5F5),
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
                  items: _courses.map((course) {
                    return DropdownMenuItem(
                      value: course,
                      child: Text(
                        course,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCourse = value;
                      _errorMessage = '';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // About Me (Optional)
                TextField(
                  controller: _aboutController,
                  maxLines: 3,
                  maxLength: 150,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'About Me (Optional)',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Icon(
                        Icons.info_outline,
                        color: isDarkMode ? Colors.grey : Colors.grey[600],
                      ),
                    ),
                    hintText: 'Tell us a bit about yourself...',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F5F5),
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
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: isDarkMode ? Colors.grey : Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    hintText: 'Enter a strong password',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F5F5),
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
                  onChanged: (value) {
                    _updatePasswordStrength(value);
                    setState(() => _errorMessage = '');
                  },
                ),
                const SizedBox(height: 12),

                // Password strength indicators
                if (_passwordController.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password must contain:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.grey : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        _buildRequirement('At least 8 characters', _hasMinLength),
                        _buildRequirement('One uppercase letter (A-Z)', _hasUppercase),
                        _buildRequirement('One lowercase letter (a-z)', _hasLowercase),
                        _buildRequirement('One number (0-9)', _hasNumber),
                        _buildRequirement('One special character (@ # * ! etc.)', _hasSpecialChar),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Confirm Password
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Confirm Password *',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                        color: isDarkMode ? Colors.grey : Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                    hintText: 'Re-enter your password',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F5F5),
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
                  onChanged: (_) => setState(() => _errorMessage = ''),
                  onSubmitted: (_) => _signup(),
                ),
                const SizedBox(height: 32),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.grey[700],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(
                              onThemeChanged: widget.onThemeChanged,
                            ),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Theme indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isDarkMode ? 'Dark Mode' : 'Light Mode',
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
        ),
      ),
    );
  }

  // Helper widget for password requirements
  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: met ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: met ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}