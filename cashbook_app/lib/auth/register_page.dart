import 'package:cashbook_app/utilits/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../provider/name_provider.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _addresscontroller = TextEditingController();
  TextEditingController _phonenumbercontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  // authentication

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // String? name;

  // Method to register user using Firebase Authentication
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get user input
        String email = _emailcontroller.text.trim();
        String password = _passwordcontroller.text.trim();
        String name = _namecontroller.text.trim();
        if (name.isEmpty) {
          Fluttertoast.showToast(
            msg: 'Please enter a valid name',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Color(0xFF3A4A3D),
            textColor: Colors.white,
          );
          return;
        }

        try {
          // Add the account name to Firestore
          await _firestore.collection('accounts').add({
            'name': name,
            'created_at': DateTime.now(),
          });

          Fluttertoast.showToast(
            msg: 'Account registered successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Color(0xFF3A4A3D),
            textColor: Colors.white,
          );

          // Clear the text field after registration
          _namecontroller.clear();
        } catch (e) {
          Fluttertoast.showToast(
            msg: 'Failed to register account: $e',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Color(0xFF3A4A3D),
            textColor: Colors.white,
          );
        } finally {
          setState(() {
            isLoading = false;
          });
        }
        // Register user
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Access the user details (userCredential)
        User? user = userCredential.user;

        if (user != null) {
          print('User UID: ${user.uid}'); // Access the user UID
          print('User Email: ${user.email}'); // Access the user email
          context.read<UserProvider>().userName = name;

          // If registration is successful, navigate to login page
          Fluttertoast.showToast(msg: "Registration successful!");

          // You can navigate to the login page here
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle errors from Firebase Authentication
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'email-already-in-use') {
          errorMessage =
              'The email address is already in use by another account.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        }
        Fluttertoast.showToast(msg: errorMessage);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Unexpected error: $e');
      }
    } else {
      Fluttertoast.showToast(msg: "Please fill in all required fields.");
    }

    setState(() {
      isLoading = true;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3A4A3D), Color(0xFF96AD90)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              width: 360.rw(context),
              height: 645.rh(context),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.white),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "  Sign Up",
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
                          "Already have an account?",
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
                                        const LoginPage()));
                          },
                          child: Text(
                            " Login",
                            style: TextStyle(
                              color: Color(0xFF3A4A3D),
                              fontSize: 12.rf(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.rh(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Name",
                          style: TextStyle(
                            color: Color(0xFF6C7278),
                            // Fixed the color code to 0xFF6C7278
                            fontWeight: FontWeight.w500,
                            fontSize: 12.rf(context),
                          ),
                        ),
                        SizedBox(height: 8.rh(context)),
                        // Optional: Adds spacing between the text and the TextField
                        TextFormField(
                          controller: _namecontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3),
                                // Color when unfocused
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3), // Color when focused
                                width: 1,
                              ),
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
                              return 'Please enter your companyname';
                            }
                            return null;
                          },
                          // onSaved: (ename) {
                          //   name = ename;
                          // // },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.rh(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Color(0xFF6C7278),
                            // Fixed the color code to 0xFF6C7278
                            fontWeight: FontWeight.w500,
                            fontSize: 12.rf(context),
                          ),
                        ),
                        SizedBox(height: 8.rh(context)),
                        // Optional: Adds spacing between the text and the TextField
                        TextFormField(
                          controller: _emailcontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3),
                                // Color when unfocused
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3), // Color when focused
                                width: 1,
                              ),
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
                      ],
                    ),
                    SizedBox(height: 10.rh(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address",
                          style: TextStyle(
                            color: Color(0xFF6C7278),
                            // Fixed the color code to 0xFF6C7278
                            fontWeight: FontWeight.w500,
                            fontSize: 12.rf(context),
                          ),
                        ),
                        SizedBox(height: 8.rh(context)),
                        // Optional: Adds spacing between the text and the TextField
                        TextFormField(
                          controller: _addresscontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3),
                                // Color when unfocused
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3), // Color when focused
                                width: 1,
                              ),
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
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.rh(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone number",
                          style: TextStyle(
                            color: Color(0xFF6C7278),
                            // Fixed the color code to 0xFF6C7278
                            fontWeight: FontWeight.w500,
                            fontSize: 12.rf(context),
                          ),
                        ),
                        SizedBox(height: 8.rh(context)),
                        // Optional: Adds spacing between the text and the TextField
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _phonenumbercontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3),
                                // Color when unfocused
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3), // Color when focused
                                width: 1,
                              ),
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
                              return 'Please enter your phonenumber';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.rh(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            color: Color(0xFF6C7278),
                            // Fixed the color code to 0xFF6C7278
                            fontWeight: FontWeight.w500,
                            fontSize: 12.rf(context),
                          ),
                        ),
                        SizedBox(height: 8.rh(context)),
                        // Optional: Adds spacing between the text and the TextField
                        TextFormField(
                          controller: _passwordcontroller,
                          obscureText: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3),
                                // Color when unfocused
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFEDF1F3), // Color when focused
                                width: 1,
                              ),
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
                      ],
                    ),
                    SizedBox(height: 13.rh(context)),
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 120.rw(context),
                            vertical: 15.rh(context)),
                        backgroundColor: const Color(0xFF3A4A3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 14.rw(context),
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:cashbook_app/utilits/responsive.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
//
// import '../provider/name_provider.dart';
// import 'login_page.dart';
//
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   bool isLoading = false;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Method to register user using Firebase Authentication
//   Future<void> _registerUser() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });
//       try {
//         String email = _emailController.text.trim();
//         String password = _passwordController.text.trim();
//         String name = _nameController.text.trim();
//
//         if (name.isEmpty) {
//           Fluttertoast.showToast(
//             msg: 'Please enter a valid name',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             fontSize: 16.0,
//             backgroundColor: Color(0xFF3A4A3D),
//             textColor: Colors.white,
//           );
//           return;
//         }
//
//         // Register user with Firebase Authentication
//         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//
//         User? user = userCredential.user;
//         if (user != null) {
//           // Add the account name to Firestore with the correct email
//           await _firestore.collection('accounts').add({
//             'name': name,
//             'email': email, // Store email to associate it with the account
//             'created_at': DateTime.now(),
//           });
//
//           Fluttertoast.showToast(
//             msg: 'Account registered successfully!',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             fontSize: 16.0,
//             backgroundColor: Color(0xFF3A4A3D),
//             textColor: Colors.white,
//           );
//
//           context.read<UserProvider>().userName = name;
//
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginPage()),
//           );
//         }
//       } on FirebaseAuthException catch (e) {
//         String errorMessage = 'An error occurred. Please try again.';
//         if (e.code == 'email-already-in-use') {
//           errorMessage =
//           'The email address is already in use by another account.';
//         } else if (e.code == 'weak-password') {
//           errorMessage = 'The password provided is too weak.';
//         }
//         Fluttertoast.showToast(msg: errorMessage);
//       } catch (e) {
//         Fluttertoast.showToast(msg: 'Unexpected error: $e');
//       } finally {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Please fill in all required fields.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF3A4A3D), Color(0xFF96AD90)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Center(
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               width: 360.rw(context),
//               height: 645.rh(context),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16), color: Colors.white),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Sign Up",
//                         style: TextStyle(
//                           color: Color(0xFF000000),
//                           fontSize: 32.rf(context),
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10.rh(context)),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Already have an account?",
//                           style: TextStyle(
//                             color: Color(0xFF6C7278),
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12.rf(context),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) =>
//                                     const LoginPage()));
//                           },
//                           child: Text(
//                             " Login",
//                             style: TextStyle(
//                               color: Color(0xFF3A4A3D),
//                               fontSize: 12.rf(context),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.rh(context)),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Name",
//                           style: TextStyle(
//                             color: Color(0xFF6C7278),
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12.rf(context),
//                           ),
//                         ),
//                         SizedBox(height: 8.rh(context)),
//                         TextFormField(
//                           controller: _nameController,
//                           decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFEDF1F3),
//                                 width: 1,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFEDF1F3),
//                                 width: 1,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your name';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.rh(context)),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Email",
//                           style: TextStyle(
//                             color: Color(0xFF6C7278),
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12.rf(context),
//                           ),
//                         ),
//                         SizedBox(height: 8.rh(context)),
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFEDF1F3),
//                                 width: 1,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFEDF1F3),
//                                 width: 1,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your email';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.rh(context)),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Password",
//                           style: TextStyle(
//                             color: Color(0xFF6C7278),
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12.rf(context),
//                           ),
//                         ),
//                         SizedBox(height: 8.rh(context)),
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFEDF1F3),
//                                 width: 1,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFFEDF1F3),
//                                 width: 1,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 13.rh(context)),
//                     ElevatedButton(
//                       onPressed: _registerUser,
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 120.rw(context),
//                             vertical: 15.rh(context)),
//                         backgroundColor: const Color(0xFF3A4A3D),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         "Register",
//                         style: TextStyle(
//                           fontSize: 14.rw(context),
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFFFFFFFF),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

