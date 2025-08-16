import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import 'sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  late AnimationController _controller;

  bool otpSent = false;
  String generatedOtp = "";

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Save login state
  Future<void> _saveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.purple.withOpacity(0.6 + 0.4 * _controller.value),
                  Colors.indigo.withOpacity(0.6 + 0.4 * (1 - _controller.value)),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        // Phone Number
                        TextFormField(
                          controller: _phoneController,
                          decoration: _inputDecoration("Phone Number"),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter phone number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // OTP (only show if OTP is sent)
                        if (otpSent)
                          TextFormField(
                            controller: _otpController,
                            decoration: _inputDecoration("Enter OTP"),
                            keyboardType: TextInputType.number,
                          ),

                        const SizedBox(height: 24),

                        // Get OTP / Login Button
                        ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;

                            if (!otpSent) {
                              // Fake OTP generator
                              generatedOtp = "1234";
                              setState(() {
                                otpSent = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("OTP sent: $generatedOtp")),
                              );
                            } else {
                              if (_otpController.text == generatedOtp) {
                                _saveLogin();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const DashboardScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Invalid OTP")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(otpSent ? "Login" : "Get OTP"),
                        ),
                        const SizedBox(height: 10),

                        // No account? Signup
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
