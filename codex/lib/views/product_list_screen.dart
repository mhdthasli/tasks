import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'product_details_screen.dart';
import '../utils/constants.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Using addPostFrameCallback to ensure API call is done after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final token = authViewModel.token;

      if (token != null && productViewModel.categories.isEmpty && !productViewModel.isCategoriesLoading) {
        productViewModel.fetchCategories(token); // Fetch categories here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final token = authViewModel.token;

    if (token == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Products', style: AppConstants.headStyle),
          centerTitle: true,
          backgroundColor: AppConstants.primaryColor,
        ),
        body: Center(child: Text('User is not logged in, token is null')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Products', style: AppConstants.headStyle),
        centerTitle: true,
        backgroundColor: AppConstants.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              authViewModel.logout();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: productViewModel.isCategoriesLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : productViewModel.categories.isEmpty
          ? Center(child: Text('No categories available'))
          : ListView.builder(
        itemCount: productViewModel.categories.length,
        itemBuilder: (context, index) {
          final category = productViewModel.categories[index];

          // Debugging: print the entire category to check the structure
          print("Category: $category");

          // Safely extract category name
          String categoryName = category['parts_name'] ?? 'Unnamed Category'; // Default to 'Unnamed Category' if null

          return ListTile(
            title: Text(categoryName, style: AppConstants.subtitleStyle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(category['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
