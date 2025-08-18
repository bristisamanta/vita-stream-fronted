import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  const Color.fromARGB(212, 149, 163, 247)
                      .withOpacity(0.6 + 0.4 * (1 - _controller.value)),
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

                        // Phone
                        TextFormField(
                          controller: _phoneController,
                          decoration: _inputDecoration("Phone Number"),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value == null || value.isEmpty
                                  ? "Please enter phone number"
                                  : null,
                        ),
                        const SizedBox(height: 16),

                        // OTP
                        if (otpSent)
                          TextFormField(
                            controller: _otpController,
                            decoration: _inputDecoration("Enter OTP"),
                            keyboardType: TextInputType.number,
                          ),

                        const SizedBox(height: 24),

                        // Button
                        ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;

                            if (!otpSent) {
                              generatedOtp = "1234"; // Fake OTP
                              setState(() => otpSent = true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("OTP sent: $generatedOtp")),
                              );
                            } else {
                              if (_otpController.text == generatedOtp) {
                                _saveLogin();
                                // ✅ Go to Dashboard
                                Navigator.pushReplacementNamed(
                                    context, "/dashboard");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Invalid OTP")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 194, 190, 255),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(otpSent ? "Login" : "Get OTP"),
                        ),

                        const SizedBox(height: 10),

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, "/signup"),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 87, 69, 135)),
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
