import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
    super.initState();
  }

   bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2C),

      body: _isLoading
          ? Center(
              child: Image.asset(
                "assets/image/02aab0ace801620cf8e3737b6995a04b-removebg-preview.png",color: Colors.white,
                height: 350,
              ),
            )
          : const Center(
              child: CircularProgressIndicator()), // Fallback for loading
    );
  }
}
