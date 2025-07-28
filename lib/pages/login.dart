import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtrip.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:flutter_application_1/model/response/customer_login_post_res.dart';
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/utils/user_session.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/widgets/animated_card.dart';
import 'package:flutter_application_1/widgets/travel_widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;
  bool _isPasswordVisible = false;

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
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Welcome Section
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: AppTheme.headingLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Sign in to continue your journey',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xxxl),
                  
                  // Travel Illustration
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: AppTheme.radiusXLarge,
                        gradient: AppTheme.primaryGradient,
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        size: 80,
                        color: AppTheme.primaryWhite,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Phone Number Field
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter your phone number',
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: AppTheme.textSecondary,
                            ),
                          ),
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
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Password Field
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: passwordController,
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
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Error Message
                  if (errorMessage.isNotEmpty)
                    SlideInAnimation(
                      child: Container(
                        margin: const EdgeInsets.only(top: AppSpacing.md),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: AppTheme.radiusMedium,
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                errorMessage,
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Login Button
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 500),
                    child: PrimaryButton(
                      text: 'Sign In',
                      isLoading: isLoading,
                      icon: Icons.login,
                      onPressed: _handleLogin,
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Register Link
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 600),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: register,
                            child: Text(
                              'Sign Up',
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

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      login(phoneController.text, passwordController.text);
    }
  }

// Process
  void register() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void login(String phone, String password) async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    try {
      // Create request object
      CustomerLoginPostRequest req = CustomerLoginPostRequest(
        phone: phone.trim(),
        password: password,
      );

      // Make API call
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: ApiConfig.headers,
        body: customerLoginPostRequestToJson(req),
      );

      log('Login response status: ${response.statusCode}');
      log('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        CustomerLoginPostResponse loginResponse =
            customerLoginPostResponseFromJson(response.body);
        
        log('Login successful for: ${loginResponse.customer.fullname}');
        
        // เก็บ user session
        UserSession.setUserSession(
          userId: loginResponse.customer.idx,
          userName: loginResponse.customer.fullname,
          userPhone: loginResponse.customer.phone,
          userEmail: loginResponse.customer.email,
          userImage: loginResponse.customer.image,
        );
        
        // Navigate to ShowTripPage on successful login
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const ShowTripPage())
        );
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Invalid phone number or password';
        });
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'User not found in system';
        });
      } else {
        setState(() {
          errorMessage = 'Login failed. Please try again.';
        });
      }
    } catch (error) {
      log('Login error: $error');
      setState(() {
        errorMessage = 'Connection error. Please check your internet.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
