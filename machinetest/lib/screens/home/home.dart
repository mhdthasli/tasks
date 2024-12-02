// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:machinetest/screens/setting/settings.dart';
// import 'package:machinetest/screens/sports/tasks.dart';
//
// class Home extends StatelessWidget {
//   const Home({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E2C),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E1E2C),
//         elevation: 0,
//         title: const Text(
//           'Categories',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context)=> Setting()));
//           },
//           child: const Padding(
//             padding: EdgeInsets.only(left: 16),
//             child: CircleAvatar(
//               backgroundImage: AssetImage("assets/image/images (8).jpeg"), // Replace with actual image
//             ),
//           ),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 16),
//             child: Icon(Icons.search, color: Colors.white),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Quote Card
//             Card(
//               color: const Color(0xFF2E2E3B),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 20,
//                       backgroundImage: AssetImage("assets/image/download (10).jpeg"),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Text(
//                             '"The memories is a shield and life helper."',
//                             style: TextStyle(
//                                 color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             "Tamim Al-Barghouti",
//                             style: TextStyle(color: Colors.grey, fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             // GridView for Categories
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 1.3,
//                 ),
//                 itemCount: categories.length,
//                 itemBuilder: (context, index) {
//                   return CategoryCard(category: categories[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Category Model
// class Category {
//   final String title;
//   final String emoji;
//   final int tasks;
//
//   Category({
//     required this.title,
//     required this.emoji,
//     required this.tasks,
//   });
// }
//
// // Example categories with "Add" button as the first item
// final List<Category> categories = [
//   Category(title: "Add", emoji: "", tasks: 0),
//   Category(title: "Home", emoji: "🏡", tasks: 10),
//   Category(title: "Sport", emoji: "🏆", tasks: 5),
//   Category(title: "Homework", emoji: "📝", tasks: 13),
//   Category(title: "E-learning", emoji: "🖥️", tasks: 4),
//   Category(title: "Shopping", emoji: "🛒", tasks: 9),
//   Category(title: "Food", emoji: "🍕", tasks: 1),
//   Category(title: "Design", emoji: "👨‍🎨", tasks: 3),
// ];
//
// // Category Card Widget
// class CategoryCard extends StatelessWidget {
//   final Category category;
//
//   const CategoryCard({super.key, required this.category});
//
//   @override
//   Widget build(BuildContext context) {
//     // Special case for the "Add" button
//     if (category.title == "Add") {
//       return GestureDetector(
//         onTap: () {
//
//         },
//         child: Card(
//           color: const Color(0xFF2E2E3B),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12)),
//           child: Center(
//             child: Container(
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white24, // Light transparent background
//               ),
//               padding: const EdgeInsets.all(10),
//               child: const Icon(
//                 Icons.add,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     // Regular category card layout
//     return GestureDetector(
//       onTap: () {
//         // Handle navigation based on category
//         if (category.title == "Home") {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const HomePage()),
//           // );
//         } else if (category.title == "Sport") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Sport()),
//           );
//         } else if (category.title == "Homework") {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const HomeworkPage()),
//           // );
//         } else if (category.title == "E-learning") {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const ELearningPage()),
//           // );
//         } else if (category.title == "Shopping") {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const ShoppingPage()),
//           // );
//         } else if (category.title == "Food") {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const FoodPage()),
//           // );
//         } else if (category.title == "Design") {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const DesignPage()),
//           // );
//         }
//       },
//       child: Card(
//         color: const Color(0xFF2E2E3B),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: Icon(Icons.more_vert, color: Colors.white60),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(category.emoji, style: const TextStyle(fontSize: 24)),
//                   const SizedBox(height: 8),
//                   Text(
//                     category.title,
//                     style: const TextStyle(color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "${category.tasks} tasks",
//                     style: const TextStyle(color: Colors.white54, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../setting/settings.dart';
import '../tasks/tasks.dart';

// Define the Category class
class Category {
  final String title;
  final String emoji;
  final int tasks;
  final String documentId; // Store Firestore document ID

  Category({
    required this.title,
    required this.emoji,
    required this.tasks,
    required this.documentId, // Initialize the documentId
  });
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Load categories from Firestore
  Future<void> _loadCategories() async {
    try {
      final categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('createdAt', descending: true) // Fetch latest first
          .get();

      final List<Category> loadedCategories = categorySnapshot.docs.map((doc) {
        return Category(
          title: doc['title'],
          emoji: doc['emoji'],
          tasks: doc['tasks'],
          documentId: doc.id,  // Get the document ID
        );
      }).toList();

      setState(() {
        categories = loadedCategories;
      });
    } catch (e) {
      print("Error loading categories: $e");
    }
  }

  // Method to show dialog and add category
  void _showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController emojiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E1E2C),
          title: const Text(
            "Add Category",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category title input
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintText: "Enter title",
                  hintStyle: TextStyle(color: Colors.black87),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Emoji input
              TextField(
                controller: emojiController,
                decoration: InputDecoration(
                  hintText: "Enter Emoji",
                  hintStyle: TextStyle(color: Colors.black87),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                final newTitle = categoryController.text.trim();
                final newEmoji = emojiController.text.trim();

                // Validate if the title and emoji are not empty
                if (newTitle.isNotEmpty && newEmoji.isNotEmpty) {
                  try {
                    // Add the new category to Firestore
                    await FirebaseFirestore.instance.collection('categories').add({
                      'title': newTitle,
                      'tasks': 0,
                      'emoji': newEmoji,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context); // Close the dialog
                    _loadCategories(); // Refresh the categories list
                  } catch (e) {
                    print("Error adding category: $e");
                  }
                } else {
                  // Handle case when input is empty
                  print("Title or Emoji is empty!");
                }
              },
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Function to handle category edit
  void _editCategory(Category category) {
    print('Editing category: ${category.title}');
    // Here you can implement your logic to edit a category
  }

  // Function to handle category delete
  void _deleteCategory(String documentId) async {
    try {
      // Use Firestore document reference to delete the category
      await FirebaseFirestore.instance.collection('categories').doc(documentId).delete();
      _loadCategories(); // Refresh the categories list after deletion
      print('Category deleted');
    } catch (e) {
      print("Error deleting category: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/image/images (8).jpeg"),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF2E2E3B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/image/download (10).jpeg"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '"The memories is a shield and life helper."',
                            style: TextStyle(
                                color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Tamim Al-Barghouti",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: categories.length + 1, // Add one for the "Add" button
          itemBuilder: (context, index) {
            if (index == 0) {
              // This is the "Add" button, place it first
              return CategoryCard(
                category: Category(title: "Add", emoji: "", tasks: 0, documentId: ""),
                onAdd: _showAddCategoryDialog,
              );
            }
            return CategoryCard(
              category: categories[index - 1], // Adjust index for correct category
              onEdit: _editCategory,
              onDelete: _deleteCategory,
            );
          },
        ),
      ),
      ]
    )

    )


    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onAdd;
  final void Function(Category)? onEdit;
  final void Function(String)? onDelete;

  const CategoryCard({super.key, required this.category, this.onAdd, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (category.title == "Add") {
      return GestureDetector(
        onTap: onAdd,
        child: Card(
          color: const Color(0xFF2E2E3B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ),
      );
    }
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Tasks()));
      },
      child: Card(
        color: const Color(0xFF2E2E3B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      if (onEdit != null) onEdit!(category); // Edit logic
                    } else if (value == 'delete') {
                      if (onDelete != null) onDelete!(category.documentId); // Pass documentId for deletion
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: const [
                          Icon(Icons.edit, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert, color: Colors.white60),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text(
                    category.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}






