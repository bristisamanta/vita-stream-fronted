import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0f2027), // dark teal-green
              Color(0xFF2c5364), // deep bluish
              Color(0xFF203a43), // deep teal
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.55,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Full Name
                    TextFormField(
                      decoration: _inputDecoration("Full Name"),
                    ),
                    const SizedBox(height: 16),
                    // Phone Number
                    TextFormField(
                      controller: phoneController,
                      decoration: _inputDecoration("Phone Number"),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 8),
                    // Send OTP Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          if (phoneController.text.isNotEmpty) {
                            setState(() {
                              otpSent = true;
                            });
                            // TODO: Send OTP logic
                          }
                        },
                        child: const Text(
                          "Send OTP",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // OTP Field (only shown after sending)
                    if (otpSent) ...[
                      TextFormField(
                        controller: otpController,
                        decoration: _inputDecoration("Enter OTP"),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Verify OTP logic
                          },
                          child: const Text(
                            "Verify OTP",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Username
                    TextFormField(
                      decoration: _inputDecoration("Username"),
                    ),
                    const SizedBox(height: 16),
                    // Password
                    TextFormField(
                      decoration: _inputDecoration("Password"),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password
                    TextFormField(
                      decoration: _inputDecoration("Confirm Password"),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    // Sign Up Button
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle sign-up logic here
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2c5364),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.black87),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
    );
  }
}
