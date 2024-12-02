import 'package:cashbook_app/auth/register_page.dart';
import 'package:cashbook_app/utilits/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homeScreen/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  // Login function
  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Sign in with email and password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),  // Get email from the controller
          password: _passwordController.text.trim(),  // Get password from the controller
        );

        // On successful login, update SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Access user information from UserCredential
        User? user = userCredential.user;
        if (user != null) {
          // Successfully signed in
          print('Logged in user UID: ${user.uid}');
          print('Logged in user email: ${user.email}');

          Fluttertoast.showToast(msg: 'Login Successful');

          // Navigate to HomePage after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        } else {
          Fluttertoast.showToast(msg: 'User not found.');
        }
      } on FirebaseAuthException catch (e) {
        // Handle errors
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(msg: 'Incorrect password.');
        } else {
          Fluttertoast.showToast(msg: e.message ?? 'Login failed');
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(


   body:  Form(
     key: _formKey,
     child: Container(
       width: double.infinity,
       height: double.infinity,
       decoration: const BoxDecoration(
         gradient: LinearGradient(
           colors: [
             Color(0xFF3A4A3D),
             Color(0xFF96AD90)



           ],
           begin: Alignment.topCenter,
           end: Alignment.bottomCenter,
         ),
       ),
       child: Center(
         child: SingleChildScrollView(
           child: Container(
             padding: const EdgeInsets.all(24),
             width: 360.rw(context),
             height: 468.rh(context),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(16),
               color: Colors.white,
             ),
             child: SingleChildScrollView(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                    Center(
                     child: Text(
                       "Login",
                       style: TextStyle(
                         color: Color(0xFF000000),
                         fontSize: 32.rf(context),
                         fontWeight: FontWeight.w700,
                       ),
                     ),
                   ),
                    SizedBox(height: 10.rh(context)),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                        Text(
                         "Don’t have a company?",
                         style: TextStyle(
                           color: Color(0xFF6C7278),
                           fontWeight: FontWeight.w500,
                           fontSize: 12.rf(context),
                         ),
                       ),
                       GestureDetector(
                         onTap: () {
                           Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(
                               builder: (BuildContext context) =>
                               const RegisterPage(),
                             ),
                           );
                         },
                         child:  Text(
                           " Create",
                           style: TextStyle(
                             color: Color(0xFF3A4A3D),
                             fontSize: 12.rf(context),
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ),
                     ],
                   ),
                    SizedBox(height: 20.rh(context)),
                    Text("Email",
                       style: TextStyle(
                           color: Color(0xFF6C7278),
                           fontWeight: FontWeight.w500,
                           fontSize: 12.rf(context))),
                    SizedBox(height: 8.rh(context)),
                   TextFormField(
                     controller: _emailController,

                     decoration: InputDecoration(
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(
                             color: Color(0xFFEDF1F3), width: 1),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(
                             color: Color(0xFFEDF1F3), width: 1),
                       ),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(
                           color: Color(0xFFEDF1F3), // Default color
                           width: 1,
                         ),
                       ),
                     ),
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return 'Please enter your email';
                       }
                       return null;
                     },
                   ),
                    SizedBox(height: 25.rh(context)),
                    Text("Password",
                       style: TextStyle(
                           color: Color(0xFF6C7278),
                           fontWeight: FontWeight.w500,
                           fontSize: 12.rh(context))),
                    SizedBox(height: 8.rh(context)),
                   TextFormField(
                     obscureText: true,
                     controller: _passwordController,
                     decoration: InputDecoration(
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(
                             color: Color(0xFFEDF1F3), width: 1),

                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(
                             color: Color(0xFFEDF1F3), width: 1),
                       ),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(
                           color: Color(0xFFEDF1F3), // Default color
                           width: 1,
                         ),

                       ),

                     ),
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return 'Please enter your password';
                       }
                       return null;
                     },
                   ),
                    SizedBox(height: 10.rh(context)),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           Checkbox(
                             value: false,
                             onChanged: (bool? value) {},
                           ),
                            Text(
                             "Remember me",
                             style: TextStyle(
                               color: Color(0xFF6C7278),
                               fontWeight: FontWeight.w500,
                               fontSize: 13.rf(context),
                             ),
                           ),
                         ],
                       ),
                       GestureDetector(
                         onTap: () {
                           // Add Forgot Password logic here
                         },
                         child:  Text(
                           "Forgot Password?",
                           style: TextStyle(
                             color: Color(0xFF3A4A3D),
                             fontSize: 12.rf(context),
                             fontWeight: FontWeight.w600,
                           ),
                         ),
                       ),
                     ],
                   ),
                    SizedBox(height: 20.rh(context)),
                   ElevatedButton(
                     onPressed:

                       _loginUser,
                     style: ElevatedButton.styleFrom(
                       padding:  EdgeInsets.symmetric(
                           horizontal: 120.rw(context), vertical: 15.rh(context)),
                       backgroundColor: const Color(0xFF3A4A3D),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8),
                       ),
                     ),
                     child:  Text(
                       "Log In",
                       style: TextStyle(
                           fontSize: 14.rf(context),
                           fontWeight: FontWeight.w500,
                           color: Color(0xFFFFFFFF)),
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       ),
     ),
   ),



    );
  }
}
