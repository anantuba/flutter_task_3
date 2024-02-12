import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhotoList(),
    );
  }
}

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  List<dynamic>? data;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery App'),
      ),
      body: ListView.builder(
        itemCount: data?.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(data?[index]['thumbnailUrl'] ?? ''),
            title: Text(data?[index]['title'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetails(photo: data?[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PhotoDetails extends StatelessWidget {
  final Map<dynamic, dynamic>? photo;

  PhotoDetails({Key? key, this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.network(photo?['url'] ?? ''),
            SizedBox(height: 8.0),
            Text('Title: ${photo?['title'] ?? ''}'),
            SizedBox(height: 8.0),
            Text('ID: ${photo?['id'] ?? ''}'),
          ],
        ),
      ),
    );
  }
}
