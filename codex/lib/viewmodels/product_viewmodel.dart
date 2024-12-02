import 'package:flutter/material.dart';
import '../services/api_services.dart';

class ProductViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // To store categories and selected product
  List<dynamic> _categories = [];
  Map<String, dynamic>? _selectedProduct;

  // Getters to access the data
  List<dynamic> get categories => _categories;
  Map<String, dynamic>? get selectedProduct => _selectedProduct;

  // To store the loading state for categories and product details
  bool _isCategoriesLoading = false;
  bool _isProductLoading = false;

  bool get isCategoriesLoading => _isCategoriesLoading;
  bool get isProductLoading => _isProductLoading;

  // Fetch categories
  Future<void> fetchCategories(String token) async {
    _isCategoriesLoading = true;
    notifyListeners(); // Notify listeners that loading has started

    try {
      // Fetch categories from API
      final response = await _apiService.fetchProductCategories(token);
      if (response != null && response is List) {
        _categories = response;  // Set the categories
      } else {
        _categories = []; // Fallback to empty list
      }
    } catch (error) {
      _categories = []; // Set empty list in case of error
    } finally {
      _isCategoriesLoading = false;
      // Ensure notifyListeners is called after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Fetch product details by productId
  Future<void> fetchProductDetails(String token, int productId) async {
    _isProductLoading = true;

    try {
      final response = await _apiService.fetchProductDetails(token, productId);
      if (response != null) {
        _selectedProduct = response; // Set the selected product
      } else {
        _selectedProduct = null; // Fallback to null
      }
    } catch (error) {
      _selectedProduct = null; // Set null in case of error
    } finally {
      _isProductLoading = false;
      // Ensure notifyListeners is called after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
