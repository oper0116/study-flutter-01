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
              var products = snapshot.data!.products;

              return ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (int index = 0; index < products.length; index += 1)
                    CustomListItem(
                      title: products[index].title,
                      thumbnail: Image.network(products[index].thumbnail),
                      description: products[index].description,
                    )
                ],
              );
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

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.title,
    required this.thumbnail,
    required this.description,
  });

  final String title;
  final String description;
  final Widget thumbnail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 2, 0),
                child: ProductDescription(
                  title: title,
                  description: description,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  const ProductDescription({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.only(bottom: 2)),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Product {
  final List<ProductItem> products;
  final int total;

  const Product({required this.products, required this.total});

  factory Product.fromJson(Map<String, dynamic> json) {
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
