import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/home/home.dart';
import 'login.dart'; // Import Firebase Auth

class Regi extends StatefulWidget {
  const Regi({super.key});

  @override
  State<Regi> createState() => _RegiState();
}

class _RegiState extends State<Regi> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Validate methods
  String? _validateName(String? value) {
    value = value?.trim(); // Trim the value
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    value = value?.trim(); // Trim the value
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    // Simple email format validation
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    value = value?.trim(); // Trim the value
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    value = value?.trim(); // Trim the value
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text.trim()) { // Also trim password comparison
      return 'Passwords do not match';
    }
    return null;
  }

  // Function to register a user with Firebase
  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Register user with email and password (trimmed)
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
        });
        // After successful registration, navigate to the login page
        print("User Registered: ${userCredential.user?.email}");

        // Clear the input fields
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        nameController.clear();

        // Navigate to the Login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } catch (e) {
        print("Error: $e");
        // Handle error (e.g., show an alert dialog or a snackbar)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2C),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF1E1E2C),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Create an Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _buildTextField("Full Name", false, null, controller: nameController, validator: _validateName),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _buildTextField("Email", false, null, controller: emailController, validator: _validateEmail),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _buildTextField("Password", true, () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }, controller: passwordController, validator: _validatePassword, obscureText: _obscurePassword),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _buildTextField("Confirm Password", true, () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  }, controller: confirmPasswordController, validator: _validateConfirmPassword, obscureText: _obscureConfirmPassword),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _registerUser, // Call the registration function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B4FE4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "CONTINUE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: "Log In",
                            style: TextStyle(
                              color: Color(0xFF3B4FE4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, bool isPassword, VoidCallback? toggleVisibility, {bool obscureText = false, required TextEditingController controller, required String? Function(String?) validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Color(0xFF2E2E3B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          )
              : null,
        ),
        validator: validator, // Pass the respective validator
      ),
    );
  }
}



