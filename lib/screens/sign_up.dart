import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Added for WhatsApp
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'dart:math'; // ✅ For OTP generation

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _locationAccess = false;
  String? _generatedOtp; // ✅ Store OTP

  late AnimationController _controller;

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
    super.dispose();
  }

  // ✅ Function to send OTP on WhatsApp
  Future<void> _sendOtp() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter phone number")),
      );
      return;
    }

    // Generate random 6-digit OTP
    _generatedOtp = (100000 + Random().nextInt(900000)).toString();

    final phone = _phoneController.text;
    final whatsappUrl = Uri.parse(
        "https://wa.me/$phone?text=Your OTP is $_generatedOtp");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp not installed")),
      );
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_otpController.text != _generatedOtp) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
        );
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueAccent.withOpacity(0.7 + 0.3 * _controller.value),
                  const Color.fromARGB(255, 101, 183, 246).withOpacity(0.7 + 0.3 * (1 - _controller.value)),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Name
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration("Full Name"),
                          validator: (value) =>
                              value!.isEmpty ? "Enter your name" : null,
                        ),
                        const SizedBox(height: 15),

                        // Phone + Send OTP Button
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                decoration:
                                    _inputDecoration("Phone Number (with country code)"),
                                keyboardType: TextInputType.phone,
                                validator: (value) => value!.isEmpty
                                    ? "Enter phone number"
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _sendOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 130, 211, 255),
                              ),
                              child: const Text("Send OTP"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // OTP
                        TextFormField(
                          controller: _otpController,
                          decoration: _inputDecoration("Enter OTP"),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? "Enter OTP" : null,
                        ),
                        const SizedBox(height: 15),

                        // Location Access
                        CheckboxListTile(
                          title: const Text("Allow location access"),
                          value: _locationAccess,
                          onChanged: (val) {
                            setState(() {
                              _locationAccess = val ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Sign Up Button
                        ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text("Sign Up"),
                        ),
                        const SizedBox(height: 10),

                        // Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
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
