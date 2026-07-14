import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../app/route_names.dart';
import 'services/auth_service.dart';
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SignupHeader(),
            SignupForm(),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {

  final _formKey = GlobalKey<FormState>();

  final employeeIdController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreeTerms = false;
  bool isLoading = false;

  String? selectedRole;

  final List<String> roles = [
    "Employee",
    "Admin",
  ];
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await AuthService.register(
        employeeId: employeeIdController.text.trim(),
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedRole!.toLowerCase(),
      );

      if (!mounted) return;

      final data = response['data'];

      Navigator.pushNamed(
        context,
        RouteNames.otpVerification,
        arguments: {
          'user_id': data['user_id'],
          'email': data['email'],
        },
      );
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      String message = 'Registration failed.';

      if (data is Map) {
        message = data['message']?.toString() ?? message;

        final errors = data['errors'];

        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;

          if (firstError is List && firstError.isNotEmpty) {
            message = firstError.first.toString();
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  @override
  void dispose() {
    employeeIdController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 25,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Employee ID + Name
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Employee ID",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff17153B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: employeeIdController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          "Emp ID",
                          Icons.badge_outlined,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Full Name",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff17153B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          "Name",
                          Icons.person_outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Email
            const Text(
              "Email Address",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff17153B),
              ),
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              decoration: _inputDecoration(
                "Enter your email",
                Icons.email_outlined,
              ),
            ),

            const SizedBox(height: 10),

            /// Role
            const Text(
              "Role",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff17153B),
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: _inputDecoration(
                "Select your role",
                Icons.person_add_alt_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a role';
                }
                return null;
              },
              items: roles
                  .map(
                    (role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),

            const SizedBox(height: 10),

            /// Password
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff17153B),
              ),
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              decoration: _inputDecoration(
                "Create a password",
                Icons.lock_outline,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Confirm Password
            const Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff17153B),
              ),
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              decoration: _inputDecoration(
                "Confirm your password",
                Icons.lock_outline,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Terms
            Row(
              children: [

                Checkbox(
                  value: agreeTerms,
                  activeColor: const Color(0xff8E3A8C),
                  onChanged: (value) {
                    setState(() {
                      agreeTerms = value!;
                    });
                  },
                ),

                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      children: [

                        TextSpan(
                          text: "I agree to the ",
                        ),

                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(
                            color: Color(0xff8E3A8C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextSpan(
                          text: " and ",
                        ),

                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            color: Color(0xff8E3A8C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xff8E3A8C),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
                onPressed: isLoading ? null : _register,
                child: const Row(
                  children: [

                    Spacer(),

                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Spacer(),

                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xff8E3A8C),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      String hint,
      IconData icon,
      ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: const Color(0xff8E3A8C),
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
        const BorderSide(color: Color(0xffE5E5EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xff8E3A8C),
          width: 1.5,
        ),
      ),
    );
  }
}


class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * .42,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          /// Right Background Circle
          Positioned(
            right: -180,
            top: 50,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffF2EEFB).withOpacity(0.8),
              ),
            ),
          ),

          /// Left Content
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 60,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "HRMS",
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff9042ff),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Create\nYour Account",
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff17153B),
                  ),
                ),

                const SizedBox(height: 10),

                const SizedBox(
                  width: 200,
                  child: Text(
                    "Join our HRMS platform and manage your workday effortlessly.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Illustration
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/register_logo.png",
              width: size.width * .70,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}