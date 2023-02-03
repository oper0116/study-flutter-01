import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/product.dart';
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
          children: <Widget>[
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
