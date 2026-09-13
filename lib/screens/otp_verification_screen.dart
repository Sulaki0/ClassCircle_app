import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String? studentId;
  final String? university;
  final String? course;
  final String? about;
  final String purpose;
  final bool isNewUser;
  final Function(bool) onThemeChanged;

  const OtpVerificationScreen({
    super.key,
    required this.userName,
    required this.email,
    this.studentId,
    this.university,
    this.course,
    this.about,
    this.purpose = 'login',
    this.isNewUser = false,
    required this.onThemeChanged,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
        (index) => FocusNode(),
  );

  String _errorMessage = '';
  bool _isVerifying = false;
  int _resendCooldown = 30;
  bool _canResend = false;
  bool _otpSent = false;

  final String _validOtp = '123456';

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_otpSent && mounted) {
      _otpSent = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _sendOtp();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _sendOtp() {
    if (!mounted) return;

    String purposeText = widget.purpose == 'login' ? 'Login' : 'Signup';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP (${_validOtp}) sent to ${widget.email} for $purposeText',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _startResendTimer() {
    setState(() {
      _resendCooldown = 30;
      _canResend = false;
    });
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _verifyOtp() {
    String enteredOtp = _otpControllers.map((c) => c.text).join();

    if (enteredOtp.length < 6) {
      setState(() {
        _errorMessage = 'Please enter the 6-digit code';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = '';
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _isVerifying = false;
      });

      if (enteredOtp == _validOtp) {
        // DIRECTLY GO TO HOME - No need to login again!
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userName: widget.userName,
              onThemeChanged: widget.onThemeChanged,
              isNewUser: widget.purpose == 'signup', // KEY FIX
            ),
          ),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.purpose == 'signup'
                  ? 'Account created successfully! Welcome!'
                  : 'Login successful! Welcome back!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid OTP. Please try again.';
        });
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _resendOtp() {
    if (!_canResend) return;

    setState(() {
      _errorMessage = '';
    });

    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New OTP sent to your email!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    String title = widget.purpose == 'login'
        ? 'Two-Factor Authentication'
        : 'Verify Your Email';
    String subtitle = widget.purpose == 'login'
        ? 'Enter the 6-digit code sent to'
        : 'Please verify your email address';
    String buttonText = widget.purpose == 'login' ? 'Verify OTP' : 'Create Account';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.purpose == 'login' ? 'Verify 2FA' : 'Verify Email'),
        backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
        elevation: 0,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        automaticallyImplyLeading: widget.purpose == 'login',
        leading: widget.purpose == 'login'
            ? IconButton(
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
        )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.purpose == 'login'
                      ? Icons.security
                      : Icons.verified,
                  size: 50,
                  color: const Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Use OTP: 123456',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 45,
                    height: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
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
                          borderSide: const BorderSide(
                            color: Color(0xFF6C63FF),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _errorMessage = '';
                        });
                        if (value.length == 1 && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                      onSubmitted: (_) {
                        String enteredOtp = _otpControllers.map((c) => c.text).join();
                        if (enteredOtp.length == 6) {
                          _verifyOtp();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _canResend
                        ? "Didn't receive the code?"
                        : 'Resend available in ${_resendCooldown}s',
                    style: TextStyle(
                      color: _canResend
                          ? (isDarkMode ? Colors.grey : Colors.grey[700])
                          : (isDarkMode ? Colors.grey[600] : Colors.grey[400]),
                    ),
                  ),
                  if (_canResend)
                    TextButton(
                      onPressed: _resendOtp,
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              if (widget.purpose == 'signup')
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
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[600],
                    ),
                  ),
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
    );
  }
}