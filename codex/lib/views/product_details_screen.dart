import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  ProductDetailScreen(this.productId);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final token = authViewModel.token;

    if (token == null) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    try {
      await productViewModel.fetchProductDetails(token, widget.productId);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final product = productViewModel.selectedProduct;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Product Details', style: AppConstants.headStyle),
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back,color: Colors.white,)),

        backgroundColor: AppConstants.primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : _hasError
          ? Center(child: Text('Error fetching product details. Please try again.'))
          : product == null
          ? Center(child: Text('Product not found.'))
          : SingleChildScrollView( // Wrap the content inside a scrollable view
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${product['parts_name'] ?? 'Unnamed'}', style: AppConstants.titleStyle),
              SizedBox(height: 10),
              Text('Description: ${product['description'] ?? 'No description available'}', style: AppConstants.subtitleStyle),
              SizedBox(height: 10),
              Text('Price: \$${product['price'] ?? 'N/A'}', style: AppConstants.subtitleStyle),
              SizedBox(height: 10),
              // Limit the height of the image to prevent overflow
              product['part_image'] != null
                  ? Image.network(
                product['part_image'],
                height: 200, // You can adjust this as needed
                fit: BoxFit.cover, // Ensure the image scales correctly
              )
                  : SizedBox(height: 0), // If image is available, show it
              SizedBox(height: 10),
              Text('Rating: ${product['product_rating'] ?? 'N/A'}', style: AppConstants.subtitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}
