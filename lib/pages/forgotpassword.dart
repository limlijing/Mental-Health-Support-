// reset_test_6.0.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetTestV6 extends StatefulWidget {
  const ResetTestV6({super.key});

  @override
  State<ResetTestV6> createState() => _ResetTestV6State();
}

class _ResetTestV6State extends State<ResetTestV6> {
  final _emailController = TextEditingController();
  bool _loading = false;
  String _result = '';

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _loading = true;
      _result = 'sending.....';
    });

    try {
      print('🔐 send email to: $email');

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        _result = '''✅ email successfully send

📧 to: $email
📨 from: noreply@mental-health-app-2eeeb.firebaseapp.com
please check:
your inbox or spam''';
      });

    } on FirebaseAuthException catch (e) {
      print('❌: ${e.code} - ${e.message}');

      setState(() {
        _result = '❌: ${_getErrorMessage(e)}';
      });
    } catch (e) {
      print('❌: $e');
      setState(() {
        _result = '❌ failed to send: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Please register the email first';
      case 'invalid-email':
        return 'please correct your email address';
      case 'network-request-failed':
        return 'offline,please check your connection';
      default:
        return '${e.code}: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                hintText: 'example@gmail.com',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('send to your email'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}