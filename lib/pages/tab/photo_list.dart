import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoList extends StatefulWidget {
  const PhotoList({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoList();
}

class _PhotoList extends State<PhotoList> {
  late Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Album>>(
          future: futureAlbums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (int index = 0; index < snapshot.data!.length; index += 1)
                    ListTile(
                        title: Text(snapshot.data![index].title),
                        subtitle: Text(snapshot.data![index].title))
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

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJSON(Map<String, dynamic> json) {
    return Album(id: json['id'], userId: json['userId'], title: json['title']);
  }
}

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    return Album.fromJSON(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Album');
  }
}

List<Album> parseAlbums(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Album>((json) => Album.fromJSON(json)).toList();
}

Future<List<Album>> fetchAlbums() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    return compute(parseAlbums, response.body);
  }
  throw Exception('Failed to load Album');
}
