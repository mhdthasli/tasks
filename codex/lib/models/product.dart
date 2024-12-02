import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final String category;

  ProductScreen(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Center(
        child: Text('Products for $category will be displayed here.'),
      ),
    );
  }
}