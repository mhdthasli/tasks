import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/screen/auth/registerpage.dart';
import 'package:task/screen/home%20screen/profile.dart';









class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stack to overlay "Hello Parent" on the image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20,),bottomLeft: Radius.circular(20)),
                  child: Image.asset(
                    "assets/image/3782085.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300, // Set a fixed height for the image
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  child: Text(
                    "Hello\nParent",
                   style: TextStyle(
                     color: Colors.black87,
                     fontWeight: FontWeight.bold,
                     fontStyle: FontStyle.normal,
                     fontSize: 30
                   ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Stay Informed, Connected, involved,\nin your Child Education",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black87,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  OutlinedButton(
                    onPressed: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Registerpage()));
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.black87,
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 100),

                  Center(
                    child: Text(
                      "By using this app, you agree and consent to our:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),

                  Text(
                    "Terms of services Cookie policy Privacy policy Your Privacy Choice",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



