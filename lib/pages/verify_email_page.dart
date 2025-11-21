import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'login_page.dart';

class VerifyEmailPage extends StatefulWidget {
  final String userEmail;

  const VerifyEmailPage({super.key, required this.userEmail});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;
  bool _emailSent = false;
  bool _isVerified = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    _startPeriodicCheck();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      final updatedUser = _auth.currentUser;
      if (mounted) {
        setState(() {
          _isVerified = updatedUser != null && updatedUser.emailVerified;
        });
      }
    }
  }

  void _startPeriodicCheck() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isVerified) {
        _checkEmailVerification();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _loading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        setState(() {
          _emailSent = true;
          _resendCooldown = 60; // 60秒冷却时间
        });

        // 开始冷却计时器
        _startCooldownTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // 冷却计时器
  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCooldown > 0) {
            _resendCooldown--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  // 手动检查验证状态
  void _recheckVerification() {
    setState(() {
      _loading = true;
    });

    _checkEmailVerification().then((_) {
      if (mounted) {
        setState(() {
          _loading = false;
        });

        if (_isVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Email verified successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email not verified yet. Please check your email.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.orange.shade50,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    Icon(
                      _isVerified ? Icons.verified_user : Icons.mark_email_unread,
                      size: 80,
                      color: _isVerified ? Colors.green : Colors.orange,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      _isVerified ? 'Email Verified!' : 'Verify Your Email',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isVerified ? Colors.green.shade50 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isVerified ? Icons.check_circle : Icons.schedule,
                            size: 16,
                            color: _isVerified ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isVerified ? 'Verified' : 'Pending Verification',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isVerified ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [

                    Text(
                      _isVerified
                          ? 'Your email has been successfully verified. You can now login to your account and access all features.'
                          : 'We sent a verification link to your email address:',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.email, size: 20, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.userEmail,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!_isVerified) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Please check your inbox and click the verification link to activate your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],

                    const SizedBox(height: 24),

                    if (!_isVerified) ...[
                      // 发送验证邮件按钮
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          onPressed: _resendCooldown > 0 ? null : _sendVerificationEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _resendCooldown > 0
                              ? Text('Resend in $_resendCooldown s')
                              : Text(_emailSent ? 'Resend Verification Email' : 'Send Verification Email'),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 重新检查按钮
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _recheckVerification,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.orange),
                          ),
                          child: const Text(
                            'I\'ve Verified My Email',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ),
                    ],

                    if (_isVerified) ...[
                      // 验证成功后的按钮
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Continue to Login'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 提示信息
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.help_outline, size: 20, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Need help?',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('• Check your email inbox and spam folder'),
                    const Text('• Click the verification link in the email'),
                    Text('• Link from: noreply@mental-health-app-2eeeb.firebaseapp.com'),
                    const Text('• Link expires in 1 hour'),
                    if (!_isVerified) const Text('• This page automatically checks every 5 seconds'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}