import 'dart:convert';
import 'package:flutter_application_1/model/product.dart';
import 'package:http/http.dart' as http;

class HttpRequest {
  Future<Product> fetchProducts(num currentPage) async {
    const pageViewCnt = 10;
    final currentIndex = pageViewCnt * (currentPage - 1);

    final response = await http.get(Uri.parse(
        'https://dummyjson.com/products?limit=$pageViewCnt&skip=$currentIndex'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load Album');
  }
}
