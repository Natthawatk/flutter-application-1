import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/request/customer_register_post_req.dart';
import 'package:flutter_application_1/model/response/customer_register_post_res.dart';
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/widgets/animated_card.dart';
import 'package:flutter_application_1/widgets/travel_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _imageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  
                  // Back button and title
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Text(
                          'Create Account',
                          style: AppTheme.headingLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Subtitle
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: Center(
                      child: Text(
                        'Join us and start your journey',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Form Fields
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: AnimatedCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full Name
                          Text(
                            'Full Name',
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _fullNameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your full name',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Phone Number
                          Text(
                            'Phone Number',
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _phoneNumberController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your phone number',
                              prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.length < 10) {
                                return 'Phone number must be at least 10 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Email
                          Text(
                            'Email',
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Profile Image URL
                          Text(
                            'Profile Image URL',
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _imageController,
                            decoration: const InputDecoration(
                              hintText: 'Enter image URL (optional)',
                              prefixIcon: Icon(
                                Icons.image_outlined,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final uri = Uri.tryParse(value);
                                if (uri == null || !uri.hasAbsolutePath) {
                                  return 'Please enter a valid URL';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Password
                          Text(
                            'Password',
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: AppTheme.textSecondary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppTheme.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Confirm Password
                          Text(
                            'Confirm Password',
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Confirm your password',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: AppTheme.textSecondary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppTheme.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
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
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Register Button
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 400),
                    child: PrimaryButton(
                      text: 'Create Account',
                      isLoading: isLoading,
                      icon: Icons.person_add,
                      onPressed: _handleRegister,
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Login Link
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 500),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Sign In',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.primaryBlack,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      _registerCustomer();
    }
  }

  void _registerCustomer() async {
    setState(() {
      isLoading = true;
    });

    try {
      log('🚀 Starting registration process...');

      // Create request object
      String imageUrl = _imageController.text.trim().isEmpty 
          ? ApiConfig.defaultImageUrl 
          : _imageController.text.trim();
          
      CustomerRegisterPostRequest req = CustomerRegisterPostRequest(
        fullname: _fullNameController.text.trim(),
        phone: _phoneNumberController.text.trim(),
        email: _emailController.text.trim(),
        image: imageUrl,
        password: _passwordController.text,
      );

      log('📤 Sending registration request...');
      log('📋 Request data: ${customerRegisterPostRequestToJson(req)}');

      // Make API call to create new user
      final response = await http.post(
        Uri.parse(ApiConfig.customersUrl),
        headers: ApiConfig.headers,
        body: customerRegisterPostRequestToJson(req),
      );

      log('📥 Response status: ${response.statusCode}');
      log('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          CustomerRegisterPostResponse registerResponse =
              customerRegisterPostResponseFromJson(response.body);
          
          log('✅ Registration successful for: ${registerResponse.customer.fullname}');
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please sign in.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        } catch (parseError) {
          log('⚠️ Response parsing error: $parseError');
          // Even if parsing fails, if status is 200/201, consider it success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please sign in.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else if (response.statusCode == 409 || response.statusCode == 400) {
        // Handle duplicate user or bad request
        String errorMessage = 'Phone number or email already exists';
        
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        } catch (e) {
          log('Could not parse error message: $e');
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${response.statusCode}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      log('❌ Registration error: $error');
      
      String errorMessage = 'Connection error. Please check your internet.';
      
      // Check if it's a network error
      if (error.toString().contains('SocketException') || 
          error.toString().contains('Connection refused')) {
        errorMessage = 'Cannot connect to server. Please check your internet connection.';
      } else if (error.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (error.toString().contains('FormatException')) {
        errorMessage = 'Invalid server response.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}