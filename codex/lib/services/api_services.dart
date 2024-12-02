import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://prethewram.pythonanywhere.com/api";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    print("Login Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Invalid credentials: ${response.body}");
    }
  }

  Future<List<dynamic>> fetchProductCategories(String token) async {
    final url = Uri.parse('$baseUrl/parts_categories/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print("Categories Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 403) {
      throw Exception("Access Forbidden: Invalid token or insufficient permissions");
    } else {
      throw Exception("Failed to load categories: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> fetchProductDetails(String token, int productId) async {
    final url = Uri.parse('$baseUrl/parts_categories/$productId/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print("Product Details Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 403) {
      throw Exception("Access Forbidden: Invalid token or insufficient permissions");
    } else {
      throw Exception("Failed to load product details: ${response.body}");
    }
  }
}
