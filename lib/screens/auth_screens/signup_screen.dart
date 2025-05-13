import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:uber_taxi/auth/services/auth_api_service.dart' show ApiService;
import 'package:uber_taxi/screens/Customer_screens/customer_screen.dart'
    show CustomerHomeScreen;
import 'package:uber_taxi/screens/Driver_screens/driver_screen.dart'
    show DriverHomeScreen;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _userType = 'customer';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        userType: _userType,
        phoneNumber: _phoneController.text.trim(),
      );

      // Check user role and navigate to appropriate screen
      final user = result['user'];
      if (user['role'] == 'driver') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back button and title
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Text(
                            'Create Account',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // App logo
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_taxi_rounded,
                            size: 48,
                            color: Colors.white, // Icon color
                          ),
                        ),
                      ),
                    ),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Full Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
                    const SizedBox(height: 16),

                    // Phone Number field
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number (Optional)',
                        hintText: 'Enter your phone number',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Create a password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // User type selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Register as:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white, // Icon color
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.5),
                            ),
                          ),
                          child: Column(
                            children: [
                              CustomRadioListTile<String>(
                                title: 'Customer',
                                subtitle: 'Book rides and travel',
                                icon: Icons.person,
                                value: 'customer',
                                groupValue: _userType,
                                onChanged: (value) {
                                  setState(() {
                                    _userType = value!;
                                  });
                                },
                                theme: theme,
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                                color: theme.colorScheme.outline.withOpacity(
                                  0.2,
                                ),
                              ),
                              CustomRadioListTile<String>(
                                title: 'Driver',
                                subtitle: 'Provide rides to customers',
                                icon: Icons.drive_eta,
                                value: 'driver',
                                groupValue: _userType,
                                onChanged: (value) {
                                  setState(() {
                                    _userType = value!;
                                  });
                                },
                                theme: theme,
                                lastItem: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Sign up button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: theme.colorScheme.shadow,
                        disabledBackgroundColor: theme.colorScheme.primary
                            .withOpacity(0.6),
                      ),
                      child:
                          _isLoading
                              ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: theme.colorScheme.onPrimary,
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

                    // Sign in link
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Colors.white, // Icon color
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.only(left: 6),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom radio list tile with improved styling
class CustomRadioListTile<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final ThemeData theme;
  final bool lastItem;

  const CustomRadioListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.theme,
    this.lastItem = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(lastItem ? 0 : 12),
        bottom: Radius.circular(lastItem ? 12 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.onBackground.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
