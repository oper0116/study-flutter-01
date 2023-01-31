import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  const ProductList({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductList();
}

class _ProductList extends State<ProductList> {
  late Future<Product> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProducts(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Product>(
          future: futureProduct,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('1');
              // return ListView(
              //   padding: EdgeInsets.symmetric(vertical: 8),
              //   children: [
              //     for (int index = 0; index < snapshot.data!.length; index += 1)
              //       ListTile(
              //           title: Text(snapshot.data![index].title),
              //           subtitle: Text(snapshot.data![index].title))
              //   ],
              // );
            } else if (snapshot.hasData) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Product {
  final List<ProductItem> products;
  final int total;

  const Product({required this.products, required this.total});

  factory Product.fromJson(Map<String, dynamic> json) {
    var list = List.from(json['products']).map((e) => ProductItem.fromJson(e));
    print('list: $list');
    return Product(
      products: List.from(json['products'])
          .map((e) => ProductItem.fromJson(e))
          .toList(),
      total: json['total'],
    );
  }
}

class ProductItem {
  final int id;
  final String title;
  final String description;
  final int price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final String category;
  // final List<String> images;

  const ProductItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.category,
    // required this.images,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    print('ProductItem json $json');
    return ProductItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      discountPercentage: json['discountPercentage'],
      rating: json['rating'],
      stock: json['stock'],
      brand: json['brand'],
      thumbnail: json['thumbnail'],
      category: json['category'],
      // images: json['images'],
    );
  }
}

Product parseProduct(String responseBody) {
  final parsed = json.decode(responseBody);
  return Product.fromJson(parsed);
}

Future<Product> fetchProducts(num currentPage) async {
  const pageViewCnt = 10;
  final currentIndex = pageViewCnt * (currentPage - 1);

  final response = await http.get(Uri.parse(
      'https://dummyjson.com/products?limit=$pageViewCnt&skip=$currentIndex'));

  if (response.statusCode == 200) {
    return compute(parseProduct, response.body);
  }
  throw Exception('Failed to load Album');
}
