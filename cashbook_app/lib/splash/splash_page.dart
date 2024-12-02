//
// import 'package:cashbook_app/utilits/responsive.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../auth/login_page.dart';
//
// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});
//
//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }
//
// class _SplashPageState extends State<SplashPage> {
//
//
//   @override
//   void initState() {
//    Future.delayed(Duration(seconds: 2),(){
//      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
//    });
//     super.initState();
//   }
//
//   bool _isLoading = true;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       body: _isLoading
//           ? Center(
//         child: Image.asset(
//           "assets/image/cashbook-removebg-preview[1].png",
//           height: 200.rh(context),
//         ),
//       )
//           : const Center(child: CircularProgressIndicator()), // Fallback for loading
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import '../homeScreen/home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool _isLoading = true; // Track loading status

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // Initialize Firebase and check login status
  Future<void> _initializeApp() async {
    try {
      // Step 1: Initialize Firebase
      await Firebase.initializeApp();

      // Step 2: Check if a user is logged in (FirebaseAuth)
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Step 2: Check SharedPreferences for login status
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      // Step 3: Simulate splash delay (optional)
      await Future.delayed(const Duration(seconds: 1));

      // Step 4: Navigate based on login status
      if (currentUser != null && isLoggedIn) {
        _redirectToHome();
      } else {
        _redirectToLogin();
      }
    } catch (e) {
      // Handle errors during initialization
      print("Error during initialization: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navigate to HomePage
  Future<void> _redirectToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  // Navigate to LoginPage
  Future<void> _redirectToLogin() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
        child: Image.asset(
          "assets/image/cashbook-removebg-preview[1].png",
          height: 200,
        ),
      )
          : const Center(child: CircularProgressIndicator()), // Fallback for loading
    );
  }
}
