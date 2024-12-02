// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
//
// class Account extends StatefulWidget {
//   const Account({super.key});
//
//   @override
//   State<Account> createState() => _AccountState();
// }
//
// class _AccountState extends State<Account> {
//   TextEditingController _nameController = TextEditingController();
//   DateTime selectedDate = DateTime.now();
//   bool isLoading = false;
//
//   // Firebase Firestore instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Method to pick date
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2100));
//
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   // Method to save data to Firebase Firestore
//   Future<void> _saveAccountData() async {
//     if (_nameController.text.isEmpty) {
//       Fluttertoast.showToast(
//         msg: 'Please fill in all required fields',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         fontSize: 16.0,
//         backgroundColor: Color(0xFF3A4A3D),
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       // Check if account with the same name already exists
//       var existingAccount = await _firestore
//           .collection('accounts')
//           .where('name', isEqualTo: _nameController.text)
//           .get();
//
//       if (existingAccount.docs.isNotEmpty) {
//         Fluttertoast.showToast(
//           msg: 'Account with this name already exists!',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           fontSize: 16.0,
//           backgroundColor: Color(0xFF3A4A3D),
//           textColor: Colors.white,
//         );
//         return;
//       }
//
//       // Add account data to Firestore
//       await _firestore.collection('accounts').add({
//         'name': _nameController.text,
//         'date': selectedDate,
//       });
//
//       Fluttertoast.showToast(
//         msg: 'Account saved successfully!',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         fontSize: 16.0,
//         backgroundColor: Color(0xFF3A4A3D),
//         textColor: Colors.white,
//       );
//
//       Navigator.pop(context); // Close dialog after saving
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Failed to save account: $e',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         fontSize: 16.0,
//         backgroundColor: Color(0xFF3A4A3D),
//         textColor: Colors.white,
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   // Method to delete an account
//   Future<void> _deleteAccount(String accountId) async {
//     try {
//       await _firestore.collection('accounts').doc(accountId).delete();
//       Fluttertoast.showToast(
//         msg: 'Account deleted successfully!',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         fontSize: 16.0,
//         backgroundColor: Color(0xFF3A4A3D),
//         textColor: Colors.white,
//       );
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Failed to delete account: $e',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         fontSize: 16.0,
//         backgroundColor: Color(0xFF3A4A3D),
//         textColor: Colors.white,
//       );
//     }
//   }
//
//   // Method to edit account data
//   Future<void> _editAccount(String accountId, String currentName) async {
//     _nameController.text =
//         currentName; // Set the current name in the controller
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Color(0xFFFFFFFF),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             height: 300,
//             width: 200,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Edit Account",
//                   style: TextStyle(
//                     color: Color(0xFF3A4A3D),
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     hintText: "Name",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         DateFormat("dd-MMM-yyyy").format(selectedDate),
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       IconButton(
//                         onPressed: () => _selectDate(context),
//                         icon: Icon(
//                           Icons.calendar_month,
//                           color: Color(0xFF3A4A3D),
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop(); // Close the dialog
//                       },
//                       child: Text(
//                         "CANCEL",
//                         style: TextStyle(color: Color(0xFF3A4A3D)),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         await _firestore
//                             .collection('accounts')
//                             .doc(accountId)
//                             .update({
//                           'name': _nameController.text,
//                           'date': selectedDate,
//                         });
//                         Fluttertoast.showToast(
//                           msg: 'Account updated successfully!',
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.BOTTOM,
//                           fontSize: 16.0,
//                           backgroundColor: Color(0xFF3A4A3D),
//                           textColor: Colors.white,
//                         );
//                         Navigator.of(context).pop(); // Close the dialog
//                       },
//                       child: Text(
//                         "SAVE",
//                         style: TextStyle(color: Color(0xFF3A4A3D)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFF3A4A3D),
//         title: const Text(
//           "Accounts",
//           style: TextStyle(
//             color: Color(0xFFFFFFFF),
//           ),
//         ),
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(Icons.arrow_back, color: Colors.white),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _showCustomDialog();
//             },
//             child: Text(
//               "ADD ACCOUNT",
//               style: TextStyle(
//                 color: Color(0xFFFFFFFF),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Main content
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 if (isLoading)
//                   Center(
//                     child: CircularProgressIndicator(
//                       color: Color(0xFF3A4A3D),
//                     ),
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: _firestore.collection('accounts').snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return Center(child: CircularProgressIndicator());
//                       }
//
//                       var accounts = snapshot.data!.docs;
//
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: accounts.length,
//                         itemBuilder: (context, index) {
//                           var account = accounts[index];
//                           return Card(
//                             color: Color(0xFFFFFFFF),
//                             child: ListTile(
//                               title: Text(account['name']),
//                               subtitle: Text(
//                                   "Account created on: ${account['created_at'].toString()}"),
//                               onTap: () {},
//                               trailing: PopupMenuButton(
//                                 color: Color(0xFFFFFFFF),
//                                 icon: Icon(
//                                   Icons.more_vert,
//                                   color: Colors.black87,
//                                 ),
//                                 itemBuilder: (BuildContext context) => [
//                                   PopupMenuItem(
//                                     value: 'edit',
//                                     child: Row(
//                                       children: [
//                                         Icon(Icons.edit, color: Colors.blue),
//                                         SizedBox(width: 5),
//                                         Text("Edit"),
//                                       ],
//                                     ),
//                                   ),
//                                   PopupMenuItem(
//                                     value: 'delete',
//                                     child: Row(
//                                       children: [
//                                         Icon(Icons.delete, color: Colors.red),
//                                         SizedBox(width: 5),
//                                         Text("Delete"),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                                 onSelected: (value) {
//                                   if (value == 'edit') {
//                                     _editAccount(account.id, account['name']);
//                                   } else if (value == 'delete') {
//                                     _deleteAccount(account.id);
//                                   }
//                                 },
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showCustomDialog() {
//     _nameController.clear();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Color(0xFFFFFFFF),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             height: 300,
//             width: 200,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Add Account",
//                   style: TextStyle(
//                     color: Color(0xFF3A4A3D),
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     hintText: "Name",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         DateFormat("dd-MMM-yyyy").format(selectedDate),
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       IconButton(
//                         onPressed: () => _selectDate(context),
//                         icon: Icon(
//                           Icons.calendar_month,
//                           color: Color(0xFF3A4A3D),
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop(); // Close the dialog
//                       },
//                       child: Text(
//                         "CANCEL",
//                         style: TextStyle(color: Color(0xFF3A4A3D)),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         await _saveAccountData(); // Save account data
//                       },
//                       child: Text(
//                         "SAVE",
//                         style: TextStyle(color: Color(0xFF3A4A3D)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController _nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to pick date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Method to save data to Firebase Firestore
  Future<void> _saveAccountData() async {
    if (_nameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all required fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
        backgroundColor: Color(0xFF3A4A3D),
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Check if account with the same name already exists
      var existingAccount = await _firestore
          .collection('accounts')
          .where('name', isEqualTo: _nameController.text)
          .get();

      if (existingAccount.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: 'Account with this name already exists!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0,
          backgroundColor: Color(0xFF3A4A3D),
          textColor: Colors.white,
        );
        return;
      }

      // Add account data to Firestore
      await _firestore.collection('accounts').add({
        'name': _nameController.text,
        'date': selectedDate,
        'created_at': FieldValue.serverTimestamp(), // Ensure created_at is set
      });

      Fluttertoast.showToast(
        msg: 'Account saved successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
        backgroundColor: Color(0xFF3A4A3D),
        textColor: Colors.white,
      );

      Navigator.pop(context); // Close dialog after saving
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to save account: $e',
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
  }

  // Method to delete an account
  Future<void> _deleteAccount(String accountId) async {
    try {
      await _firestore.collection('accounts').doc(accountId).delete();
      Fluttertoast.showToast(
        msg: 'Account deleted successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
        backgroundColor: Color(0xFF3A4A3D),
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to delete account: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
        backgroundColor: Color(0xFF3A4A3D),
        textColor: Colors.white,
      );
    }
  }

  // Method to edit account data
  Future<void> _editAccount(String accountId, String currentName) async {
    _nameController.text = currentName; // Set the current name in the controller

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 300,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Account",
                  style: TextStyle(
                    color: Color(0xFF3A4A3D),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("dd-MMM-yyyy").format(selectedDate),
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () => _selectDate(context),
                        icon: Icon(
                          Icons.calendar_month,
                          color: Color(0xFF3A4A3D),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        "CANCEL",
                        style: TextStyle(color: Color(0xFF3A4A3D)),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _firestore.collection('accounts').doc(accountId).update({
                          'name': _nameController.text,
                          'date': selectedDate,
                        });
                        Fluttertoast.showToast(
                          msg: 'Account updated successfully!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16.0,
                          backgroundColor: Color(0xFF3A4A3D),
                          textColor: Colors.white,
                        );
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(color: Color(0xFF3A4A3D)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF3A4A3D),
        title: const Text(
          "Accounts",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _showCustomDialog();
            },
            child: Text(
              "ADD ACCOUNT",
              style: TextStyle(
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF3A4A3D),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('accounts').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var accounts = snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: accounts.length,
                        itemBuilder: (context, index) {
                          var account = accounts[index];
                          return Card(
                            color: Color(0xFFFFFFFF),
                            child: ListTile(
                              title: Text(account['name'] ?? 'Unnamed'), // Fallback for null name

                              onTap: () {},
                              trailing: PopupMenuButton(
                                color: Color(0xFFFFFFFF),
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.black87,
                                ),
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.blue),
                                        SizedBox(width: 5),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 5),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editAccount(account.id, account['name'] ?? 'Unnamed');
                                  } else if (value == 'delete') {
                                    _deleteAccount(account.id);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomDialog() {
    _nameController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 300,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Account",
                  style: TextStyle(
                    color: Color(0xFF3A4A3D),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("dd-MMM-yyyy").format(selectedDate),
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () => _selectDate(context),
                        icon: Icon(
                          Icons.calendar_month,
                          color: Color(0xFF3A4A3D),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        "CANCEL",
                        style: TextStyle(color: Color(0xFF3A4A3D)),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _saveAccountData(); // Save account data
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(color: Color(0xFF3A4A3D)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// class Account extends StatefulWidget {
//   const Account({super.key});
//
//   @override
//   State<Account> createState() => _AccountState();
// }
//
// class _AccountState extends State<Account> {
//   TextEditingController _nameController = TextEditingController();
//   DateTime selectedDate = DateTime.now();
//   bool isLoading = false;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Fetch current logged-in user
//   String? get currentUserEmail => FirebaseAuth.instance.currentUser?.email;
//
//   // Fetch accounts based on the logged-in user's email
//   Stream<QuerySnapshot> fetchUserAccounts() {
//     return _firestore
//         .collection('accounts')
//         .where('email', isEqualTo: currentUserEmail)
//         .snapshots();
//   }
//
//   // Show Toast message
//   void _showToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       fontSize: 16.0,
//       backgroundColor: Color(0xFF3A4A3D),
//       textColor: Colors.white,
//     );
//   }
//
//   // Edit account data
//   Future<void> _editAccount(String accountId, String currentName) async {
//     _nameController.text = currentName;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Color(0xFFFFFFFF),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             height: 300,
//             width: 200,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Edit Account",
//                   style: TextStyle(
//                     color: Color(0xFF3A4A3D),
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     hintText: "Name",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         DateFormat("dd-MMM-yyyy").format(selectedDate),
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       IconButton(
//                         onPressed: () => _selectDate(context),
//                         icon: Icon(
//                           Icons.calendar_month,
//                           color: Color(0xFF3A4A3D),
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Text(
//                         "CANCEL",
//                         style: TextStyle(color: Color(0xFF3A4A3D)),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         await _firestore.collection('accounts').doc(accountId).update({
//                           'name': _nameController.text,
//                           'date': selectedDate,
//                         });
//                         _showToast('Account updated successfully!');
//                         Navigator.of(context).pop();
//                       },
//                       child: Text(
//                         "SAVE",
//                         style: TextStyle(color: Color(0xFF3A4A3D)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Method to pick date
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFF3A4A3D),
//         title: const Text(
//           "Accounts",
//           style: TextStyle(
//             color: Color(0xFFFFFFFF),
//           ),
//         ),
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(Icons.arrow_back, color: Colors.white),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: fetchUserAccounts(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           var accounts = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: accounts.length,
//             itemBuilder: (context, index) {
//               var account = accounts[index];
//               return Card(
//                 color: Color(0xFFFFFFFF),
//                 child: ListTile(
//                   title: Text(account['name']),
//                   subtitle: Text(account['email']),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.edit),
//                     onPressed: () {
//                       _editAccount(account.id, account['name']);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


