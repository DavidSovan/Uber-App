import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/auth_api_service.dart' show ApiService;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _requestSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.forgotPassword(
        _emailController.text.trim(),
      );

      setState(() {
        _isLoading = false;
        _requestSent = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _requestSent ? _buildSuccessView() : _buildRequestForm(),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
          const SizedBox(height: 24),
          const Text(
            'Password Reset Email Sent',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'We\'ve sent an email to reset your password. Please check your inbox and follow the instructions.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          const Text(
            'Forgot your password?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _resetPassword,
            child:
                _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Reset Password'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}
